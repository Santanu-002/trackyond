import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'package:trackyond/core/common/events/chat_event.dart';
import 'package:trackyond/core/common/models/auth_tokens/auth_tokens.dart';
import 'package:trackyond/core/common/repositories/i_event_bus_repository.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/core/services/device_header/platform_info_service.dart';
import 'package:trackyond/core/services/token/token_service.dart';
import 'package:trackyond/core/common/models/job/job_model.dart';
import 'package:trackyond/features/job_chat/data/models/response/job_chat_message_model.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_local_datasource.dart';

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
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
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
        debugPrint('WebSocket: Access token is expired/about to expire. Refreshing token...');
        final refreshed = await authController.refreshAuthToken();
        if (!refreshed) {
          debugPrint('WebSocket: Token refresh failed. Delaying connection.');
          _isConnecting = false;
          _scheduleReconnect();
          return;
        }
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

  void sendEvent(String event, String type, Map<String, dynamic> data) async {
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

      final payload = {
        'event': event,
        'type': type,
        'headers': headers,
        'data': data,
      };

      final String jsonPayload = jsonEncode(payload);
      debugPrint('WebSocket: Sending event payload: $jsonPayload');
      _channel!.sink.add(jsonPayload);
      debugPrint('WebSocket: Sent event $event/$type');
    } catch (e) {
      debugPrint('WebSocket: Failed to send event: $e');
    }
  }

  Future<void> _handleIncomingMessage(dynamic rawMessage) async {
    debugPrint('WebSocket: Received raw message: $rawMessage');
    try {
      final Map<String, dynamic> frame = jsonDecode(rawMessage as String) as Map<String, dynamic>;
      final event = frame['event'] as String?;
      final type = frame['type'] as String?;
      final data = frame['data'];

      if (event == null || type == null) {
        debugPrint('WebSocket: Invalid frame structure: $frame');
        return;
      }

      if (event == 'system') {
        if (type == 'connected') {
          _isConnected.value = true;
          _connectionStateController.add(true);
          _reconnectDelaySeconds = 2;
          final interval = (data as Map<String, dynamic>?)?['heartbeatIntervalSeconds'] as int? ?? 30;
          _startHeartbeat(interval);
          debugPrint('WebSocket: Connected and heartbeat started');
        } else if (type == 'heartbeatAck') {
          debugPrint('WebSocket: Heartbeat acknowledged');
        } else if (type == 'tokenRenewal') {
          _handleTokenRenewal(data as Map<String, dynamic>);
        }
      } else if (event == 'chat') {
        if (type == 'received') {
          await _handleChatReceived(data as Map<String, dynamic>);
        } else if (type == 'deleted') {
          await _handleChatDeleted(data as Map<String, dynamic>);
        } else if (type == 'delivered') {
          await _handleChatDelivered(data as Map<String, dynamic>);
        } else if (type == 'seen') {
          await _handleChatSeen(data as Map<String, dynamic>);
        }
      }

      // Send ack back to the server for non-heartbeatAck events
      if (type != 'heartbeatAck') {
        final Map<String, dynamic> ackData = {
          'ackedEvent': event,
          'ackedType': type,
          'timestamp': DateTime.now().toUtc().toIso8601String(),
        };

        if (event == 'chat' && type == 'received' && data is Map<String, dynamic>) {
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

        sendEvent('system', 'ack', ackData);
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
      final jobEntity = jobMap != null ? JobModel.fromJson(jobMap).toEntity() : null;

      final List<JobChatMessageModel> messagesToSave = [];
      if (messagesList != null) {
        for (final m in messagesList) {
          messagesToSave.add(JobChatMessageModel.fromJson(m as Map<String, dynamic>));
        }
      } else if (data['message'] != null) {
        messagesToSave.add(JobChatMessageModel.fromJson(data['message'] as Map<String, dynamic>));
      }

      if (messagesToSave.isNotEmpty) {
        final localDataSource = Get.find<IJobChatLocalDataSource>();
        await localDataSource.saveMessages(messagesToSave);
        debugPrint('WebSocket: Cached ${messagesToSave.length} received message(s) to SQLite.');

        for (final model in messagesToSave) {
          debugPrint('WebSocket: Dispatched ChatMessageReceivedEvent for: ${model.content}');
          _eventBus.fire(ChatMessageReceivedEvent(model.toEntity(), job: jobEntity));
        }
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
        sendEvent('system', 'heartbeat', {});
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
}
