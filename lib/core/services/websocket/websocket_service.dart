import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:trackyond/core/common/enums/websocket_events.dart';
import 'package:trackyond/core/common/models/websocket/websocket_event_model.dart';
import 'package:trackyond/core/common/events/chat_event.dart';
import 'package:trackyond/core/common/events/auth_event.dart';
import 'package:trackyond/core/common/models/auth_tokens/auth_tokens.dart';
import 'package:trackyond/core/common/repositories/i_event_bus_repository.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/core/services/device_header/platform_info_service.dart';
import 'package:trackyond/core/services/token/token_service.dart';
import 'package:trackyond/core/common/models/job/job_model.dart';
import 'package:trackyond/features/job_chat/data/models/response/job_chat_message_model.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_local_datasource.dart';
import 'package:trackyond/features/worker/dashboard/data/datasources/job_local_datasource.dart';
import 'package:trackyond/core/services/sync/models/enqueue_task.dart';
import 'package:trackyond/core/services/sync/models/queue_response.dart';


class WebSocketService extends GetxService {
  static WebSocketService get find => Get.find<WebSocketService>();

  final TokenService _tokenService;
  final PlatformInfoService _platformInfoService;
  final IEventBusRepository _eventBus;

  WebSocketService({
    required TokenService tokenService,
    required PlatformInfoService platformInfoService,
    required IEventBusRepository eventBus,
  })  : _tokenService = tokenService,
        _platformInfoService = platformInfoService,
        _eventBus = eventBus;

  IOWebSocketChannel? _channel;
  bool _isConnecting = false;
  bool _explicitlyDisconnected = false;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;
  int _reconnectDelaySeconds = 2;

  final RxBool _isConnected = false.obs;
  bool get isConnected => _isConnected.value;

  final _connectionStateController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStatusStream => _connectionStateController.stream;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<AuthTokensUpdatedEvent>? _tokensUpdatedSubscription;

  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      final isOnline = results.any((result) => result != ConnectivityResult.none);
      if (isOnline && !isConnected && !_isConnecting && !_explicitlyDisconnected) {
        debugPrint('WebSocket: Network restored. Reconnecting immediately.');
        _reconnectDelaySeconds = 2;
        _reconnectTimer?.cancel();
        connect();
      }
    });

    _tokensUpdatedSubscription = _eventBus.on<AuthTokensUpdatedEvent>().listen((event) {
      debugPrint('WebSocket: Auth tokens updated, reconnecting WebSocket instantly...');
      _reconnectDelaySeconds = 2;
      _reconnectTimer?.cancel();
      
      if (_channel != null) {
        _channel!.sink.close();
        _channel = null;
      }
      _isConnected.value = false;
      _isConnecting = false;
      connect();
    });
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    _tokensUpdatedSubscription?.cancel();
    _reconnectTimer?.cancel();
    _heartbeatTimer?.cancel();
    _channel?.sink.close();
    _connectionStateController.close();
    super.onClose();
  }

  Future<void> connect() async {
    if (_isConnecting || isConnected) return;
    _isConnecting = true;
    _explicitlyDisconnected = false;

    try {
      // 1. Check network connectivity
      final connectivity = await Connectivity().checkConnectivity();
      final isOnline = connectivity.any((result) => result != ConnectivityResult.none);
      if (!isOnline) {
        debugPrint('WebSocket: Network is offline. Delaying connection.');
        _isConnecting = false;
        _scheduleReconnect();
        return;
      }

      // 2. Check authentication and token validity
      if (!Get.isRegistered<AuthController>()) {
        debugPrint('WebSocket: AuthController not registered. Delaying connection.');
        _isConnecting = false;
        _scheduleReconnect();
        return;
      }

      final authController = Get.find<AuthController>();
      final isAuth = await authController.isAuthenticated;
      if (!isAuth) {
        debugPrint('WebSocket: User is not authenticated. Not connecting.');
        _isConnecting = false;
        return;
      }

      final isTokenAboutToExpired = await _tokenService.isAccessTokenAboutToExpired();
      if (isTokenAboutToExpired) {
        debugPrint('WebSocket: Access token is expired/about to expire. Delaying connection.');
        _isConnecting = false;
        _scheduleReconnect();
        return;
      }

      final base = ApiEndpoints.baseUrl;
      final uri = Uri.parse(base);
      final wsScheme = uri.scheme == 'https' ? 'wss' : 'ws';
      final accessToken = await _tokenService.getAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('WebSocket: No access token found. Delaying connection.');
        _isConnecting = false;
        _scheduleReconnect();
        return;
      }

      final wsPath = '${uri.path}/common/ws';
      final queryParams = {
        'token': accessToken,
      };

      final wsUri = uri.replace(
        scheme: wsScheme,
        path: wsPath,
        queryParameters: queryParams,
      );

      final platformInfo = await _platformInfoService.getPlatformInfo();
      final headers = {
        'Authorization': 'Bearer $accessToken',
        ...platformInfo,
      };

      debugPrint('WebSocket: Connecting to $wsUri');
      final channel = IOWebSocketChannel.connect(
        wsUri,
        headers: headers,
      );

      _channel = channel;

      channel.stream.listen(
        (message) async {
          await _handleIncomingMessage(message);
        },
        onDone: () {
          _handleDisconnect();
        },
        onError: (error) {
          debugPrint('WebSocket error: $error');
          _handleDisconnect();
        },
      );

      await channel.ready;
    } catch (e) {
      debugPrint('WebSocket connection failed: $e');
      _handleDisconnect();
    } finally {
      _isConnecting = false;
    }
  }

  Future<void> disconnect() async {
    _explicitlyDisconnected = true;
    _reconnectTimer?.cancel();
    _heartbeatTimer?.cancel();
    if (_channel != null) {
      await _channel!.sink.close();
      _channel = null;
    }
    if (_isConnected.value) {
      _isConnected.value = false;
      _connectionStateController.add(false);
    }
    debugPrint('WebSocket: Disconnected manually');
  }

  final List<_PendingRequest> _pendingRequests = [];

  void sendEvent(WebSocketEvents event, dynamic type, Map<String, dynamic> data) async {
    if (_channel == null || !isConnected) {
      debugPrint('WebSocket: Cannot send event. WebSocket is not connected.');
      return;
    }

    try {
      final accessToken = await _tokenService.getAccessToken() ?? '';
      final platformInfo = await _platformInfoService.getPlatformInfo();

      final headers = {
        'Authorization': 'Bearer $accessToken',
        ...platformInfo,
      };

      final eventModel = WebSocketEventModel<Map<String, dynamic>>(
        event: event,
        type: type,
        headers: headers,
        data: data,
      );

      final String jsonPayload = jsonEncode(eventModel.toJson((d) => d));
      debugPrint('WebSocket: Sending event payload: $jsonPayload');
      _channel!.sink.add(jsonPayload);
      debugPrint('WebSocket: Sent event ${event.value}/${eventModel.toJson((d) => d)['type']}');
    } catch (e) {
      debugPrint('WebSocket: Failed to send event: $e');
    }
  }

  Future<QueueResponse> sendRequestWithResponse(
    EnqueueTask task, {
    required WebSocketEvents event,
    required dynamic type,
    Duration timeout = const Duration(seconds: 8),
  }) async {
    if (!isConnected) {
      throw StateError('WebSocket is not connected');
    }

    final completer = Completer<QueueResponse>();
    final pendingRequest = _PendingRequest(
      requestId: task.requestId,
      completer: completer,
      expiry: DateTime.now().add(timeout),
    );

    _pendingRequests.add(pendingRequest);

    // Clean up expired requests
    _pendingRequests.removeWhere((r) => DateTime.now().isAfter(r.expiry));

    // Send the task data to the socket
    sendEvent(event, type, task.toJson());

    try {
      return await completer.future.timeout(timeout);
    } catch (e) {
      _pendingRequests.remove(pendingRequest);
      rethrow;
    }
  }


  Future<void> _handleIncomingMessage(dynamic rawMessage) async {
    debugPrint('WebSocket: Received raw message: $rawMessage');
    try {
      final Map<String, dynamic> frame = jsonDecode(rawMessage as String) as Map<String, dynamic>;
      
      final eventModel = WebSocketEventModel<dynamic>.fromJson(frame, (json) => json);
      final event = eventModel.event;
      final type = eventModel.type;
      final data = eventModel.data;

      // Match outgoing request completers
      if (data is Map<String, dynamic>) {
        final matchIds = _extractMatchIds(data);
        _PendingRequest? pending;
        for (final id in matchIds) {
          pending = _pendingRequests.firstWhereOrNull((r) => r.requestId == id);
          if (pending != null) break;
        }

        if (pending != null) {
          final actionTypeStr = data['action'] as String? ?? type.toString();
          final qResponse = QueueResponse.fromWebSocketFrame(actionTypeStr, data);
          pending.completer.complete(qResponse);
          _pendingRequests.remove(pending);
          debugPrint('WebSocket: Resolved pending request ${pending.requestId}');
        }
      }


      // Connection events from server
      if (event == WebSocketEvents.connection) {
        if (type == WebSocketConnectionType.connected) {
          _isConnected.value = true;
          _connectionStateController.add(true);
          _reconnectDelaySeconds = 2;
          final interval = (data as Map<String, dynamic>?)?['heartbeatIntervalSeconds'] as int? ?? 30;
          _startHeartbeat(interval);
          debugPrint('WebSocket: Connected and heartbeat started');
        }
      } else if (event == WebSocketEvents.heartbeat) {
        if (type == WebSocketHeartbeatType.pong) {
          debugPrint('WebSocket: Heartbeat pong received');
        }
      } else if (event == WebSocketEvents.token) {
        if (type == WebSocketTokenType.renewal) {
          _handleTokenRenewal(data as Map<String, dynamic>);
        }
      } else if (event == WebSocketEvents.message) {
        if (type == WebSocketMessageType.sendResponse) {
          final Map<String, dynamic>? responseData = (data as Map<String, dynamic>?)?['data'] as Map<String, dynamic>?;
          if (responseData != null) {
            await _handleChatReceived(responseData);
          }
        } else if (type == WebSocketMessageType.newMessage) {
          await _handleChatReceived(data as Map<String, dynamic>);
        } else if (type == WebSocketMessageType.deleteResponse) {
          final Map<String, dynamic>? responseData = (data as Map<String, dynamic>?)?['data'] as Map<String, dynamic>?;
          if (responseData != null) {
            await _handleChatDeleted(responseData);
          }
        } else if (type == WebSocketMessageType.deleted) {
          await _handleChatDeleted(data as Map<String, dynamic>);
        } else if (type == WebSocketMessageType.seenResponse) {
          final Map<String, dynamic>? responseData = (data as Map<String, dynamic>?)?['data'] as Map<String, dynamic>?;
          if (responseData != null) {
            await _handleChatSeen(responseData);
          }
        } else if (type == WebSocketMessageType.ackReceived) {
          final status = (data as Map<String, dynamic>?)?['status'] as String?;
          if (status == 'delivered') {
            await _handleChatDelivered(data as Map<String, dynamic>);
          } else if (status == 'seen') {
            await _handleChatSeen(data as Map<String, dynamic>);
          }
        }
      }

      // Send ack back to the server only for new_message events
      if (event == WebSocketEvents.message && type == WebSocketMessageType.newMessage) {
        final Map<String, dynamic> ackData = {
          'ackedEvent': event.value,
          'ackedType': (type as WebSocketMessageType).value,
          'timestamp': DateTime.now().toUtc().toIso8601String(),
        };

        if (data is Map<String, dynamic>) {
          final List<String> messageUids = [];
          final messagesList = data['messages'] as List?;
          if (messagesList != null) {
            for (final m in messagesList) {
              if (m is Map && m['uid'] != null) {
                messageUids.add(m['uid'] as String);
              }
            }
          } else if (data['message'] != null && data['message'] is Map) {
            final uid = (data['message'] as Map)['uid'] as String?;
            if (uid != null) {
              messageUids.add(uid);
            }
          }
          ackData['messageUids'] = messageUids;
        }

        sendEvent(
          WebSocketEvents.message,
          WebSocketEvents.message.types.ack,
          ackData,
        );
      }
    } catch (e) {
      debugPrint('WebSocket error processing incoming message (ack suppressed): $e');
    }
  }

  void _handleTokenRenewal(Map<String, dynamic> data) async {
    try {
      final tokens = AuthTokens.fromJson(data);
      await _tokenService.saveTokens(tokens);
      debugPrint('WebSocket: Token renewed successfully via WebSocket');
    } catch (e) {
      debugPrint('WebSocket: Failed to save renewed tokens: $e');
    }
  }

  Future<void> _handleChatReceived(Map<String, dynamic> data) async {
    try {
      final messagesList = data['messages'] as List?;
      final jobMap = data['job'] as Map<String, dynamic>?;

      // 1. Save Job details first if present
      if (jobMap != null) {
        final jobModel = JobModel.fromJson(jobMap);
        final jobLocalDataSource = Get.find<IJobLocalDataSource>();
        await jobLocalDataSource.saveJobs([jobModel]);
        debugPrint('WebSocket: Cached job ${jobModel.jobId} details to SQLite.');
      }

      // 2. Parse chat messages
      final List<JobChatMessageModel> messagesToSave = [];
      if (messagesList != null) {
        for (final m in messagesList) {
          messagesToSave.add(JobChatMessageModel.fromJson(m as Map<String, dynamic>));
        }
      } else if (data['message'] != null) {
        messagesToSave.add(JobChatMessageModel.fromJson(data['message'] as Map<String, dynamic>));
      }

      // 3. Save chat messages to DB (this will automatically notify the EventBus)
      if (messagesToSave.isNotEmpty) {
        final localDataSource = Get.find<IJobChatLocalDataSource>();
        await localDataSource.saveMessages(messagesToSave);
        debugPrint('WebSocket: Cached ${messagesToSave.length} received message(s) to SQLite.');
      }
    } catch (e) {
      debugPrint('WebSocket: Failed to parse or save chat received: $e');
      rethrow;
    }
  }

  Future<void> _handleChatDeleted(Map<String, dynamic> data) async {
    try {
      final jobId = data['jobId'] as String;
      final messageUids = List<String>.from(data['messageUids'] ?? []);

      final localDataSource = Get.find<IJobChatLocalDataSource>();
      await localDataSource.deleteCachedMessages(
        messageUids,
        deleteType: 'forEveryone',
      );
      debugPrint('WebSocket: Deleted ${messageUids.length} message(s) from SQLite.');

      _eventBus.fire(ChatMessageDeletedEvent(
        jobId: jobId,
        messageUids: messageUids,
      ));
    } catch (e) {
      debugPrint('WebSocket: Failed to parse or delete chat locally: $e');
      rethrow;
    }
  }

  Future<void> _handleChatDelivered(Map<String, dynamic> data) async {
    try {
      final jobId = data['jobId'] as String?;
      final uidsList = data['messageUids'] as List?;
      if (jobId != null && uidsList != null) {
        final messageUids = List<String>.from(uidsList);
        final deliveredAtStr = data['deliveredAt'] as String?;
        final deliveredAt = deliveredAtStr != null ? DateTime.parse(deliveredAtStr) : DateTime.now();

        final localDataSource = Get.find<IJobChatLocalDataSource>();
        await localDataSource.markMessagesAsDelivered(
          jobId,
          messageUids,
          deliveredAt,
        );
        debugPrint('WebSocket: Marked ${messageUids.length} message(s) as delivered in SQLite.');
        
        _eventBus.fire(ChatMessageDeliveredEvent(
          jobId: jobId,
          messageUids: messageUids,
          deliveredAt: deliveredAt,
        ));
      }
    } catch (e) {
      debugPrint('WebSocket: Error handling or saving chat delivered event: $e');
      rethrow;
    }
  }

  Future<void> _handleChatSeen(Map<String, dynamic> data) async {
    try {
      final jobId = data['jobId'] as String?;
      final uidsList = data['messageUids'] as List?;
      if (jobId != null && uidsList != null) {
        final messageUids = List<String>.from(uidsList);
        final seenAtStr = data['seenAt'] as String?;
        final seenAt = seenAtStr != null ? DateTime.parse(seenAtStr) : DateTime.now();

        final localDataSource = Get.find<IJobChatLocalDataSource>();
        await localDataSource.markMessagesAsSeen(
          jobId,
          messageUids,
          seenAt,
        );
        debugPrint('WebSocket: Marked ${messageUids.length} message(s) as seen in SQLite.');
        
        _eventBus.fire(ChatMessageReadEvent(
          jobId: jobId,
          messageUids: messageUids,
          seenAt: seenAt,
        ));
      }
    } catch (e) {
      debugPrint('WebSocket: Error handling or saving chat seen event: $e');
      rethrow;
    }
  }

  void _startHeartbeat(int intervalSeconds) {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(Duration(seconds: intervalSeconds), (timer) {
      if (isConnected) {
        sendEvent(
          WebSocketEvents.heartbeat,
          WebSocketEvents.heartbeat.types.ping,
          {},
        );
      } else {
        timer.cancel();
      }
    });
  }

  void _handleDisconnect() {
    _heartbeatTimer?.cancel();
    if (_isConnected.value) {
      _isConnected.value = false;
      _connectionStateController.add(false);
    }
    _channel = null;

    if (!_explicitlyDisconnected) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    if (_explicitlyDisconnected) return;

    debugPrint('WebSocket: Reconnecting in $_reconnectDelaySeconds seconds...');
    _reconnectTimer = Timer(Duration(seconds: _reconnectDelaySeconds), () {
      connect();
    });

    _reconnectDelaySeconds = (_reconnectDelaySeconds * 2).clamp(2, 60);
  }

  List<String> _extractMatchIds(Map<String, dynamic> data) {
    final ids = <String>[];

    // 1. Direct requestId or localId
    if (data['requestId'] != null) ids.add(data['requestId'].toString());
    if (data['localId'] != null) ids.add(data['localId'].toString());

    // 2. Nested data mapping
    final nestedData = data['data'];
    if (nestedData is Map<String, dynamic>) {
      if (nestedData['requestId'] != null) ids.add(nestedData['requestId'].toString());
      if (nestedData['localId'] != null) ids.add(nestedData['localId'].toString());
      
      // Check messageUids in nested data
      final messageUids = nestedData['messageUids'];
      if (messageUids is List) {
        ids.addAll(messageUids.map((e) => e.toString()));
      }

      // Check single message in nested data
      final message = nestedData['message'];
      if (message is Map<String, dynamic>) {
        if (message['localId'] != null) ids.add(message['localId'].toString());
        if (message['uid'] != null) ids.add(message['uid'].toString());
      }

      // Check messages list in nested data
      final messages = nestedData['messages'];
      if (messages is List) {
        for (final m in messages) {
          if (m is Map<String, dynamic>) {
            if (m['localId'] != null) ids.add(m['localId'].toString());
            if (m['uid'] != null) ids.add(m['uid'].toString());
          }
        }
      }
    }

    // 3. Root messages/messageUids check
    final rootMessage = data['message'];
    if (rootMessage is Map<String, dynamic>) {
      if (rootMessage['localId'] != null) ids.add(rootMessage['localId'].toString());
      if (rootMessage['uid'] != null) ids.add(rootMessage['uid'].toString());
    }

    final rootMessages = data['messages'];
    if (rootMessages is List) {
      for (final m in rootMessages) {
        if (m is Map<String, dynamic>) {
          if (m['localId'] != null) ids.add(m['localId'].toString());
          if (m['uid'] != null) ids.add(m['uid'].toString());
        }
      }
    }

    final rootMessageUids = data['messageUids'];
    if (rootMessageUids is List) {
      ids.addAll(rootMessageUids.map((e) => e.toString()));
    }

    return ids.where((id) => id.isNotEmpty).toList();
  }
}

class _PendingRequest {
  final String requestId;
  final Completer<QueueResponse> completer;
  final DateTime expiry;

  _PendingRequest({
    required this.requestId,
    required this.completer,
    required this.expiry,
  });
}
