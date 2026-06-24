import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';
import 'package:trackyond/core/common/events/chat_event.dart';
import 'package:trackyond/core/common/models/job/job_model.dart';
import 'package:trackyond/core/common/repositories/i_event_bus_repository.dart';
import 'package:trackyond/core/constants/notification_constants.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/core/services/device_header/app_info_service.dart';
import 'package:trackyond/core/services/device_header/device_id_service.dart';
import 'package:trackyond/core/services/device_header/device_info_service.dart';
import 'package:trackyond/core/services/device_header/platform_info_service.dart';
import 'package:trackyond/core/services/token/token_service_impl.dart';
import 'package:trackyond/core/common/enums/websocket_events.dart';
import 'package:trackyond/core/services/websocket/websocket_service.dart';
import 'package:trackyond/core/services/user/user_service.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) async {
  if (response.actionId == 'reply') {
    final replyText = response.input;
    final payload = response.payload;
    if (replyText != null && replyText.trim().isNotEmpty && payload != null) {
      try {
        final data = jsonDecode(payload);
        final jobId = data['jobId'] as String?;
        if (jobId != null) {
          await LocalNotificationService.sendReply(jobId, replyText, payload: payload);
        }
      } catch (e) {
        debugPrint('LocalNotificationService background tap error: $e');
      }
    }
  }
  if (response.actionId == 'mark_as_read') {
    debugPrint('LocalNotificationService: Mark as read tapped in background');
    final payload = response.payload;
    if (payload != null) {
      try {
        final data = jsonDecode(payload);
        final jobId = data['jobId'] as String?;
        if (jobId != null) {
          await FlutterLocalNotificationsPlugin().cancel(id: jobId.hashCode);
          LocalNotificationService.clearConversationMessagesStatic(jobId);
          await LocalNotificationService.markAsRead(jobId);
        }
      } catch (e) {
        debugPrint('LocalNotificationService: Error handling background mark as read: $e');
      }
    }
  }
}

class LocalNotificationService extends GetxService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  StreamSubscription? _chatSubscription;

  /// Store messages per conversation (in memory) to support group messaging style
  static final Map<String, List<Message>> _conversationMessages = {};

  @override
  void onInit() {
    super.onInit();
    init();
  }

  @override
  void onClose() {
    _chatSubscription?.cancel();
    super.onClose();
  }

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
          NotificationConstants.localChannel.launcherIcon,
        );

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    _listenToChatMessages();
  }

  void _listenToChatMessages() {
    try {
      final eventBus = Get.find<IEventBusRepository>();
      _chatSubscription = eventBus.on<ChatMessageReceivedEvent>().listen((event) {
        _handleIncomingMessage(event.message, event.job);
      });
    } catch (e) {
      debugPrint('LocalNotificationService: Error setting up event bus listener: $e');
    }
  }

  Future<void> _handleIncomingMessage(JobChatMessageEntity message, JobEntity? job) async {
    try {
      // 1. Skip if message is from the current user
      final userService = Get.find<UserService>();
      final currentUserProfileUid = userService.getProfileUid();
      if (message.senderUid == currentUserProfileUid) {
        return;
      }

      // 2. Skip if the user is currently looking at this job chat room
      final bool isChatControllerRegistered = Get.isRegistered<JobChatController>();
      if (isChatControllerRegistered) {
        final chatController = Get.find<JobChatController>();
        if (chatController.job.jobId == message.jobId) {
          return;
        }
      }

      // 3. Resolve Sender Name and Conversation Name
      String conversationTitle = job?.jobTitle ?? 'Job Chat';
      String senderName = 'User';
      if (job != null) {
        if (message.senderUid == job.workerProfileUid) {
          senderName = job.workerName ?? 'Worker';
        } else if (message.senderUid == job.createdByProfileUid) {
          senderName = job.createdByName ?? 'Admin';
        }
      }

      // 4. Parse content list to find attachment and caption
      JobChatMessageContentEntity? attachment;
      String? caption;

      for (final item in message.content) {
        switch (item.type) {
          case JobChatMessageContentType.text:
            caption = item.content;
            break;
          case JobChatMessageContentType.image:
          case JobChatMessageContentType.video:
          case JobChatMessageContentType.document:
          case JobChatMessageContentType.pdf:
            attachment = item;
            break;
          default:
            break;
        }
      }

      // 5. Build message text and check if it has an image
      String messageText = '';
      final prefix = _emojiPrefix(attachment?.type ?? JobChatMessageContentType.unknown);
      if (attachment != null) {
        final fileName = attachment.content?.split('/').last ?? 'file';
        if (caption != null && caption.isNotEmpty) {
          messageText = '$prefix $caption';
        } else {
          messageText = '$prefix $fileName';
        }
      } else if (caption != null) {
        messageText = caption;
      }

      // 6. Show the notification immediately (text fallback)
      await showChatMessageNotification(
        jobId: message.jobId,
        conversationTitle: conversationTitle,
        messageText: messageText,
        messageCreatedAt: message.createdByAuthorAt,
        senderUid: message.senderUid ?? 'sender',
        senderName: senderName,
        currentUserProfileUid: currentUserProfileUid,
        job: job,
      );

      // 7. If there is an image, download it and update the notification silently
      final hasImage = attachment?.type == JobChatMessageContentType.image;
      if (hasImage && attachment!.content != null) {
        final imageUrl = attachment.content!;
        final fileName = imageUrl.split('/').last;
        final localPath = await _downloadNotificationImage(imageUrl, fileName);
        if (localPath != null) {
          // Check again if the user hasn't entered the chat room while downloading
          final stillNotViewing = !Get.isRegistered<JobChatController>() ||
              Get.find<JobChatController>().job.jobId != message.jobId;
              
          if (stillNotViewing) {
            final mimeType = lookupMimeType(fileName) ?? 'image/jpeg';
            await showChatMessageNotification(
              jobId: message.jobId,
              conversationTitle: conversationTitle,
              messageText: messageText,
              messageCreatedAt: message.createdByAuthorAt,
              senderUid: message.senderUid ?? 'sender',
              senderName: senderName,
              currentUserProfileUid: currentUserProfileUid,
              imagePath: localPath,
              mimeType: mimeType,
              job: job,
            );
          }
        }
      }
    } catch (e) {
      debugPrint('LocalNotificationService: Error handling incoming message: $e');
    }
  }

  Future<void> showChatMessageNotification({
    required String jobId,
    required String conversationTitle,
    required String messageText,
    required DateTime messageCreatedAt,
    required String senderUid,
    required String senderName,
    required String? currentUserProfileUid,
    required JobEntity? job,
    String? imagePath,
    String? mimeType,
  }) async {
    final me = Person(
      key: currentUserProfileUid ?? 'me',
      name: 'You',
      important: true,
    );

    final person = Person(
      key: senderUid,
      name: senderName,
      important: true,
    );

    _conversationMessages.putIfAbsent(jobId, () => []);
    final messages = _conversationMessages[jobId]!;

    final isImagePathPresent = imagePath != null && imagePath.isNotEmpty;
    bool silentUpdate = false;

    Message localMessage;

    if (isImagePathPresent) {
      final contentUri = await _toContentUri(imagePath);
      localMessage = Message(
        messageText,
        messageCreatedAt,
        person,
        dataMimeType: mimeType ?? 'image/jpeg',
        dataUri: contentUri,
      );
      // Replace last message or clear to show only the image message silently
      messages.clear();
      silentUpdate = true;
    } else {
      localMessage = Message(
        messageText,
        messageCreatedAt,
        person,
      );
    }

    if (messages.length > 10) {
      messages.removeAt(0);
    }
    messages.add(localMessage);

    final messagingStyle = MessagingStyleInformation(
      me,
      conversationTitle: conversationTitle,
      groupConversation: true,
      messages: messages,
    );

    final androidDetails = AndroidNotificationDetails(
      'conversation_$jobId',
      conversationTitle,
      importance: silentUpdate ? Importance.none : Importance.max,
      priority: silentUpdate ? Priority.min : Priority.high,
      playSound: !silentUpdate,
      enableVibration: !silentUpdate,
      showWhen: !silentUpdate,
      onlyAlertOnce: silentUpdate,
      styleInformation: messagingStyle,
      groupKey: jobId,
      category: AndroidNotificationCategory.message,
      actions: [
        AndroidNotificationAction(
          'reply',
          'Reply',
          semanticAction: SemanticAction.reply,
          showsUserInterface: true,
          inputs: [AndroidNotificationActionInput(label: 'Message')],
        ),
        AndroidNotificationAction(
          'mark_as_read',
          'Mark as read',
          semanticAction: SemanticAction.markAsRead,
        ),
      ],
    );

    final platformChannelSpecifics = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    final Map<String, dynamic> payloadMap = {
      'jobId': jobId,
      'type': 'chat',
      'conversationTitle': conversationTitle,
      'senderName': senderName,
      'senderUid': senderUid,
      'currentUserProfileUid': currentUserProfileUid,
    };
    if (job != null) {
      // Convert JobEntity to JobModel so we can serialize it to json
      final jobModel = JobModel(
        jobId: job.jobId,
        jobTitle: job.jobTitle,
        customerName: job.customerName,
        customerPhone: job.customerPhone,
        customerAddress: job.customerAddress,
        workerProfileUid: job.workerProfileUid,
        workerName: job.workerName,
        workerImage: job.workerImage,
        createdByProfileUid: job.createdByProfileUid,
        createdByName: job.createdByName,
        status: job.status.value,
        requirePhotoOnStart: job.requirePhotoOnStart,
        requirePhotoOnComplete: job.requirePhotoOnComplete,
        captureLocation: job.captureLocation,
        createdAt: job.createdAt,
        assignedAt: job.assignedAt,
        updatedAt: job.updatedAt,
        completedAt: job.completedAt,
        allowedActions: job.allowedActions,
        lastMessage: job.lastMessage,
        lastMessageAt: job.lastMessageAt,
        lastActivityType: job.lastActivityType,
        lastActivityMessage: job.lastActivityMessage,
        lastActivityAt: job.lastActivityAt,
      );
      payloadMap['job'] = jobModel.toJson();
    }

    await _notificationsPlugin.show(
      id: jobId.hashCode,
      title: senderName,
      body: messageText,
      notificationDetails: platformChannelSpecifics,
      payload: jsonEncode(payloadMap),
    );
  }

  Future<String?> _downloadNotificationImage(String imageUrl, String fileName) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final savePath = '${tempDir.path}/$fileName';
      final file = File(savePath);

      if (!file.existsSync()) {
        final dio = Get.find<Dio>();
        final resolvedUrl = imageUrl.startsWith('http') 
            ? imageUrl 
            : ApiEndpoints.common.download(imageUrl);
            
        await dio.download(resolvedUrl, savePath);
      }
      return savePath;
    } catch (e) {
      debugPrint('LocalNotificationService: Failed to download notification image: $e');
      return null;
    }
  }

  Future<String> _toContentUri(String filePath) async {
    try {
      if (Platform.isAndroid) {
        const fileProviderChannel = MethodChannel('com.example.trackyond/fileprovider');
        final contentUri = await fileProviderChannel.invokeMethod<String>(
          'getContentUri',
          {'filePath': filePath},
        );
        if (contentUri != null) {
          debugPrint('LocalNotificationService: Resolved Content URI natively: $contentUri');
          return contentUri;
        }
      }
    } catch (e) {
      debugPrint('LocalNotificationService: Method Channel error converting to content URI: $e');
    }

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final packageName = packageInfo.packageName;
      final authority = '$packageName.fileProvider';
      final cachePrefix = '/data/user/0/$packageName/cache/';

      if (filePath.startsWith(cachePrefix)) {
        final relativePath = filePath.substring(cachePrefix.length);
        return 'content://$authority/cache-path/$relativePath';
      }
    } catch (e) {
      debugPrint('LocalNotificationService: Fallback error converting to content URI: $e');
    }
    return filePath;
  }

  static String _emojiPrefix(JobChatMessageContentType type) {
    return switch (type) {
      JobChatMessageContentType.image => '📷',
      JobChatMessageContentType.video => '🎥',
      JobChatMessageContentType.pdf => '📄',
      JobChatMessageContentType.document => '📎',
      _ => '',
    };
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          NotificationConstants.localChannel.jobChannelId,
          NotificationConstants.localChannel.jobChannelName,
          channelDescription:
              NotificationConstants.localChannel.jobChannelDescription,
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          styleInformation: DefaultStyleInformation(true, true),
        );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
      payload: payload,
    );
  }

  static void clearConversationMessagesStatic(String jobId) {
    _conversationMessages.remove(jobId);
  }

  void clearConversationMessages(String jobId) {
    clearConversationMessagesStatic(jobId);
    try {
      _notificationsPlugin.cancel(id: jobId.hashCode);
      debugPrint('LocalNotificationService: Cancelled active notification for job $jobId on entering conversation');
    } catch (e) {
      debugPrint('LocalNotificationService: Error cancelling notification for job $jobId: $e');
    }
  }

  void _handleNotificationTap(NotificationResponse response) async {
    final payload = response.payload;
    if (response.actionId == 'reply') {
      final replyText = response.input;
      if (replyText != null && replyText.trim().isNotEmpty && payload != null) {
        try {
          final data = jsonDecode(payload);
          final jobId = data['jobId'] as String?;
          if (jobId != null) {
            await LocalNotificationService.sendReply(jobId, replyText, payload: payload);
          }
        } catch (e) {
          debugPrint('LocalNotificationService reply error: $e');
        }
      }
      return;
    }

    if (response.actionId == 'mark_as_read') {
      debugPrint('LocalNotificationService: Mark as read tapped in foreground');
      if (payload != null) {
        try {
          final data = jsonDecode(payload);
          final jobId = data['jobId'] as String?;
          if (jobId != null) {
            await _notificationsPlugin.cancel(id: jobId.hashCode);
            clearConversationMessages(jobId);
            await LocalNotificationService.markAsRead(jobId);
            
            // Publish Event on EventBus
            try {
              final eventBus = Get.find<IEventBusRepository>();
              eventBus.fire(ChatMessageSeenEvent(jobId));
            } catch (_) {}
          }
        } catch (e) {
          debugPrint('LocalNotificationService: Error handling foreground mark as read: $e');
        }
      }
      return;
    }

    if (payload != null) {
      try {
        final data = jsonDecode(payload);
        if (data is Map && data['type'] == 'chat') {
          final jobId = data['jobId'] as String?;
          if (jobId != null) {
            clearConversationMessages(jobId);
          }
          final jobMap = data['job'];
          if (jobMap != null) {
            final jobEntity = JobModel.fromJson(Map<String, dynamic>.from(jobMap as Map)).toEntity();
            Get.toNamed(AppRoutes.common.jobChat, arguments: jobEntity);
          }
        }
      } catch (e) {
        debugPrint('LocalNotificationService: Error on notification tap: $e');
      }
    }
  }

  static Future<({Dio dio, String? profileUid})?> _getBackgroundAuthData() async {
    try {
      final storage = const FlutterSecureStorage();
      final prefs = await SharedPreferences.getInstance();
      
      final tokenService = TokenServiceImpl(storage);
      final userService = UserService(prefs);
      await userService.init();

      final accessToken = await tokenService.getAccessToken();
      if (accessToken == null) {
        return null;
      }

      final profileUid = userService.getProfileUid();

      final deviceIdService = DeviceIdService(storage);
      final deviceInfoService = DeviceInfoService(deviceIdService);
      final appInfoService = AppInfoService();
      final platformInfoService = PlatformInfoService(
        deviceInfoService: deviceInfoService,
        appInfoService: appInfoService,
      );
      final platformHeaders = await platformInfoService.getPlatformInfo();

      final dio = Dio(BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        contentType: 'application/json',
        headers: {
          'Authorization': 'Bearer $accessToken',
          ...platformHeaders,
        },
      ));

      return (dio: dio, profileUid: profileUid);
    } catch (e) {
      debugPrint('LocalNotificationService: Error creating background auth data: $e');
      return null;
    }
  }

  static Future<void> sendReply(String jobId, String replyText, {String? payload}) async {
    try {
      final authData = await _getBackgroundAuthData();
      if (authData == null || authData.profileUid == null) {
        debugPrint('LocalNotificationService: sendReply failed - not authenticated');
        return;
      }

      final localId = 'loc_${DateTime.now().millisecondsSinceEpoch}';
      final payloadData = [
        {
          'localId': localId,
          'jobId': jobId,
          'senderUid': authData.profileUid,
          'content': [
            {
              'type': 'text',
              'content': replyText,
            }
          ],
          'type': 'message',
          'createdByAuthorAt': DateTime.now().toUtc().toIso8601String(),
        }
      ];

      final response = await authData.dio.post(
        ApiEndpoints.common.jobChatMessages(jobId),
        data: payloadData,
      );

      if (response.statusCode == 200) {
        debugPrint('LocalNotificationService: sendReply success');
        await updateNotificationAfterReply(
          jobId: jobId,
          replyText: replyText,
          payload: payload,
        );
      } else {
        debugPrint('LocalNotificationService: sendReply failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('LocalNotificationService: sendReply error: $e');
    }
  }

  static Future<void> updateNotificationAfterReply({
    required String jobId,
    required String replyText,
    required String? payload,
  }) async {
    try {
      if (payload == null) return;
      final data = jsonDecode(payload);
      final conversationTitle = data['conversationTitle'] as String? ?? 'Job Chat';
      final currentUserProfileUid = data['currentUserProfileUid'] as String? ?? 'me';
      
      final me = Person(
        key: currentUserProfileUid,
        name: 'You',
        important: true,
      );

      _conversationMessages.putIfAbsent(jobId, () => []);
      final messages = _conversationMessages[jobId]!;
      
      final myMessage = Message(
        replyText,
        DateTime.now(),
        me,
      );

      if (messages.length > 10) {
        messages.removeAt(0);
      }
      messages.add(myMessage);

      final messagingStyle = MessagingStyleInformation(
        me,
        conversationTitle: conversationTitle,
        groupConversation: true,
        messages: messages,
      );

      final androidDetails = AndroidNotificationDetails(
        'conversation_$jobId',
        conversationTitle,
        importance: Importance.max,
        priority: Priority.high,
        playSound: false,
        enableVibration: false,
        showWhen: true,
        onlyAlertOnce: true,
        styleInformation: messagingStyle,
        groupKey: jobId,
        category: AndroidNotificationCategory.message,
        actions: [
          AndroidNotificationAction(
            'reply',
            'Reply',
            semanticAction: SemanticAction.reply,
            showsUserInterface: true,
            inputs: [AndroidNotificationActionInput(label: 'Message')],
          ),
          AndroidNotificationAction(
            'mark_as_read',
            'Mark as read',
            semanticAction: SemanticAction.markAsRead,
          ),
        ],
      );

      final platformChannelSpecifics = NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await _notificationsPlugin.show(
        id: jobId.hashCode,
        title: 'You',
        body: replyText,
        notificationDetails: platformChannelSpecifics,
        payload: payload,
      );
    } catch (e) {
      debugPrint('LocalNotificationService: Error updating notification after reply: $e');
    }
  }

  static Future<void> markAsRead(String jobId) async {
    try {
      bool sentViaWebSocket = false;
      try {
        if (Get.isRegistered<WebSocketService>()) {
          final wsService = Get.find<WebSocketService>();
          if (wsService.isConnected) {
            wsService.sendEvent(
              WebSocketEvents.message,
              WebSocketEvents.message.types.readMessage,
              {
                'jobId': jobId,
              },
            );
            sentViaWebSocket = true;
            debugPrint('LocalNotificationService: markAsRead sent via WebSocket');
          }
        }
      } catch (e) {
        debugPrint('LocalNotificationService: WebSocket markAsRead attempt failed: $e');
      }

      if (sentViaWebSocket) return;

      final authData = await _getBackgroundAuthData();
      if (authData == null) {
        debugPrint('LocalNotificationService: markAsRead failed - not authenticated');
        return;
      }

      final response = await authData.dio.post(
        ApiEndpoints.common.jobChatSeen(jobId),
      );

      if (response.statusCode == 200) {
        debugPrint('LocalNotificationService: markAsRead success');
      } else {
        debugPrint('LocalNotificationService: markAsRead failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('LocalNotificationService: markAsRead error: $e');
    }
  }

  static Future<void> markAsDelivered(String jobId, List<String> messageUids) async {
    if (messageUids.isEmpty) return;
    try {
      bool sentViaWebSocket = false;
      try {
        if (Get.isRegistered<WebSocketService>()) {
          final wsService = Get.find<WebSocketService>();
          if (wsService.isConnected) {
            wsService.sendEvent(
              WebSocketEvents.message,
              WebSocketEvents.message.types.ack,
              {
                'ackedEvent': WebSocketEvents.message.value,
                'ackedType': WebSocketEvents.message.types.newMessage.value,
                'messageUids': messageUids,
                'timestamp': DateTime.now().toUtc().toIso8601String(),
              },
            );
            sentViaWebSocket = true;
            debugPrint('LocalNotificationService: markAsDelivered sent via WebSocket');
          }
        }
      } catch (e) {
        debugPrint('LocalNotificationService: WebSocket delivery ack attempt failed: $e');
      }

      if (sentViaWebSocket) return;

      final authData = await _getBackgroundAuthData();
      if (authData == null) {
        debugPrint('LocalNotificationService: markAsDelivered failed - not authenticated');
        return;
      }

      final response = await authData.dio.post(
        ApiEndpoints.common.jobChatDelivered(jobId),
        data: {
          'messageUids': messageUids,
        },
      );

      if (response.statusCode == 200) {
        debugPrint('LocalNotificationService: markAsDelivered success via REST');
      } else {
        debugPrint('LocalNotificationService: markAsDelivered failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('LocalNotificationService: markAsDelivered error: $e');
    }
  }
}
