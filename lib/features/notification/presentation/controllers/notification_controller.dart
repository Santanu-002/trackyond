import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_new_badger/flutter_new_badger.dart';
import 'package:get/get.dart';
import 'package:synchronized/synchronized.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/models/job/job_model.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/notification_constants.dart';
import 'package:trackyond/features/job_chat/data/models/job_chat_message_model.dart';
import 'package:trackyond/features/job_chat/domain/usecases/emit_chat_message_received_use_case.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/notification/domain/entities/notification_entity.dart';
import 'package:trackyond/features/notification/domain/entities/notification_filter_options.dart';
import 'package:trackyond/features/notification/domain/usecases/delete_fcm_token_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/delete_notifications_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/retry_failed_acks_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/show_local_notification_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/sync_fcm_token_usecase.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:trackyond/core/services/notification/local_notification_service.dart';
import 'package:trackyond/features/notification/domain/usecases/update_notifications_status_usecase.dart';
import 'package:trackyond/features/worker/dashboard/presentation/controllers/worker_dashboard_controller.dart';

class NotificationController extends GetxController {
  final SyncFcmTokenUseCase _syncFcmTokenUseCase;
  final DeleteFcmTokenUseCase _deleteFcmTokenUseCase;
  final ShowLocalNotificationUseCase _showLocalNotificationUseCase;
  final GetNotificationsUseCase _getNotificationsUseCase;
  final UpdateNotificationsStatusUseCase _updateNotificationsStatusUseCase;
  final DeleteNotificationsUseCase _deleteNotificationsUseCase;
  final RetryFailedAcksUseCase _retryFailedAcksUseCase;
  final EmitChatMessageReceivedUseCase _emitChatMessageReceivedUseCase;

  NotificationController({
    required SyncFcmTokenUseCase syncFcmTokenUseCase,
    required DeleteFcmTokenUseCase deleteFcmTokenUseCase,
    required ShowLocalNotificationUseCase showLocalNotificationUseCase,
    required GetNotificationsUseCase getNotificationsUseCase,
    required UpdateNotificationsStatusUseCase updateNotificationsStatusUseCase,
    required DeleteNotificationsUseCase deleteNotificationsUseCase,
    required RetryFailedAcksUseCase retryFailedAcksUseCase,
    required EmitChatMessageReceivedUseCase emitChatMessageReceivedUseCase,
  })  : _syncFcmTokenUseCase = syncFcmTokenUseCase,
        _deleteFcmTokenUseCase = deleteFcmTokenUseCase,
        _showLocalNotificationUseCase = showLocalNotificationUseCase,
        _getNotificationsUseCase = getNotificationsUseCase,
        _updateNotificationsStatusUseCase = updateNotificationsStatusUseCase,
        _deleteNotificationsUseCase = deleteNotificationsUseCase,
        _retryFailedAcksUseCase = retryFailedAcksUseCase,
        _emitChatMessageReceivedUseCase = emitChatMessageReceivedUseCase;

  final _lock = Lock();
  StreamSubscription<String>? _tokenRefreshSubscription;

  // Shared observables — readable by NotificationsPageController
  final unreadCount = 0.obs;
  final notifications = <NotificationEntity>[].obs;
  final isLoading = false.obs;
  final isMoreLoading = false.obs;
  final hasMore = true.obs;
  int _offset = 0;
  static const int _limit = 50;
  NotificationFilterOptions _currentOptions = const NotificationFilterOptions();

  @override
  void onInit() {
    super.onInit();
    _requestPermission();
    syncToken();
    _retryFailedAcks();

    _tokenRefreshSubscription =
        FirebaseMessaging.instance.onTokenRefresh.listen((_) => syncToken());

    _handleInitialMessage();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotificationClick(message.data);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundMessage(message);
    });
  }

  // ---------------------------------------------------------------------------
  // FCM Token Management
  // ---------------------------------------------------------------------------

  Future<void> syncToken() async {
    await _lock.synchronized(() async {
      await _syncFcmTokenUseCase(const NoParams());
    });
  }

  Future<void> deleteFcmToken() async {
    await _deleteFcmTokenUseCase(const NoParams());
  }

  // ---------------------------------------------------------------------------
  // Notification List
  // ---------------------------------------------------------------------------

  Future<void> fetchNotifications({NotificationFilterOptions? options}) async {
    isLoading.value = true;
    _offset = 0;
    hasMore.value = true;
    
    if (options != null) {
      _currentOptions = options;
    }
    
    final result = await _getNotificationsUseCase(_currentOptions.copyWith(
      limit: _limit,
      offset: _offset,
    ));
    
    result.fold(
      (failure) => AppSnackbar.destructive(failure.message),
      (data) {
        notifications.assignAll(data);
        unreadCount.value = notifications.where((n) => !n.isSeen).length;
        _updateAppBadge();
        
        if (data.length < _limit) {
          hasMore.value = false;
        } else {
          _offset += data.length;
        }
      },
    );
    isLoading.value = false;
  }

  Future<void> loadMoreNotifications() async {
    if (isMoreLoading.value || !hasMore.value) return;

    isMoreLoading.value = true;
    final result = await _getNotificationsUseCase(_currentOptions.copyWith(
      limit: _limit,
      offset: _offset,
    ));

    result.fold(
      (failure) => AppSnackbar.destructive(failure.message),
      (data) {
        if (data.isEmpty) {
          hasMore.value = false;
        } else {
          notifications.addAll(data);
          unreadCount.value = notifications.where((n) => !n.isSeen).length;
          _updateAppBadge();
          
          if (data.length < _limit) {
            hasMore.value = false;
          } else {
            _offset += data.length;
          }
        }
      },
    );
    isMoreLoading.value = false;
  }

  Future<void> markAllAsSeen() async {
    final unseenIds =
        notifications.where((n) => !n.isSeen).map((n) => n.id).toList();
    if (unseenIds.isEmpty) return;

    final result = await _updateNotificationsStatusUseCase(
      UpdateNotificationsStatusParams(
        notificationIds: unseenIds,
        status: NotificationConstants.statuses.seen,
      ),
    );

    result.fold(
      (failure) => debugPrint('Error marking seen: ${failure.message}'),
      (_) {
        for (var i = 0; i < notifications.length; i++) {
          if (!notifications[i].isSeen) {
            notifications[i] = notifications[i].copyWith(isSeen: true);
          }
        }
        unreadCount.value = 0;
        _updateAppBadge();
      },
    );
  }

  Future<void> markAsRead(List<String> ids) async {
    final result = await _updateNotificationsStatusUseCase(
      UpdateNotificationsStatusParams(
        notificationIds: ids,
        status: NotificationConstants.statuses.read,
      ),
    );

    result.fold(
      (failure) => AppSnackbar.destructive(failure.message),
      (_) {
        for (var i = 0; i < notifications.length; i++) {
          if (ids.contains(notifications[i].id)) {
            notifications[i] =
                notifications[i].copyWith(isRead: true, isSeen: true);
          }
        }
        unreadCount.value = notifications.where((n) => !n.isSeen).length;
        _updateAppBadge();
      },
    );
  }

  Future<void> deleteNotifications(List<String> ids) async {
    final result = await _deleteNotificationsUseCase(
        DeleteNotificationsParams(notificationIds: ids));

    result.fold(
      (failure) => AppSnackbar.destructive(failure.message),
      (_) {
        notifications.removeWhere((n) => ids.contains(n.id));
        unreadCount.value = notifications.where((n) => !n.isSeen).length;
        _updateAppBadge();
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  void handleNotificationClick(Map<String, dynamic> data) {
    final type = data[NotificationConstants.dataKeys.type];
    if (type == NotificationConstants.types.jobChatMessage) {
      try {
        final jobDataStr = data[NotificationConstants.dataKeys.job];
        if (jobDataStr != null) {
          final jobJson = jsonDecode(jobDataStr);
          final jobModel = JobModel.fromJson(jobJson);
          final jobEntity = jobModel.toEntity();
          Get.toNamed(AppRoutes.common.jobChat, arguments: jobEntity);
          return;
        }
      } catch (e) {
        debugPrint('Error handling chat notification click: $e');
      }
    }

    final notificationId =
        data[NotificationConstants.dataKeys.notificationId];
    if (notificationId != null) {
      markAsRead([notificationId]);
    }
    Get.toNamed(AppRoutes.common.notificationDetails, arguments: data);
  }

  // ---------------------------------------------------------------------------
  // Internal / Private
  // ---------------------------------------------------------------------------

  Future<void> _retryFailedAcks() async {
    await _retryFailedAcksUseCase(const NoParams());
  }

  Future<void> _handleInitialMessage() async {
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleNotificationClick(initialMessage.data);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    final data = message.data;

    final type = data['type'] ?? data[NotificationConstants.dataKeys.type];
    if (type == 'cancelNotification') {
      final jobId = data['jobId'];
      if (jobId != null) {
        FlutterLocalNotificationsPlugin().cancel(id: jobId.hashCode);
        LocalNotificationService.clearConversationMessagesStatic(jobId);
        debugPrint('FCM: Cancelled foreground notification for job $jobId');
      }
      return;
    }

    if (type == NotificationConstants.types.jobChatMessage) {
      final messageJsonStr = data['message'];
      if (messageJsonStr != null) {
        try {
          final messageJson = jsonDecode(messageJsonStr);
          final messageModel = JobChatMessageModel.fromJson(messageJson);
          final messageEntity = messageModel.toEntity();

          // Mark message as delivered since we received it in foreground
          LocalNotificationService.markAsDelivered(messageEntity.jobId, [messageEntity.uid]);

          bool isChatOpen = false;
          if (Get.isRegistered<JobChatController>()) {
            final chatController = Get.find<JobChatController>();
            if (chatController.job.jobId == messageEntity.jobId) {
              isChatOpen = true;
              _emitChatMessageReceivedUseCase(messageEntity);
            }
          }

          if (isChatOpen) {
            // Suppress notification if the chat is open
            return;
          }
        } catch (e) {
          debugPrint('Error parsing foreground chat message: $e');
        }
      }

      // If we are not on the chat page, show the local notification
      final title = notification?.title ?? 'New Message';
      final body = notification?.body ?? '';
      _showLocalNotificationUseCase(
        ShowLocalNotificationParams(title: title, body: body, payload: data),
      );
      return;
    }

    unreadCount.value++;
    _updateAppBadge();

    final notificationId =
        data[NotificationConstants.dataKeys.notificationId];
    if (notificationId != null) {
      _sendAck(notificationId, NotificationConstants.statuses.delivered);
    }

    final title = notification?.title ??
        AppStrings.notifications.defaultNotificationTitle;
    final body = notification?.body ?? '';

    if (data[NotificationConstants.dataKeys.type] ==
        NotificationConstants.types.jobAssigned) {
      try {
        final jobDataStr =
            data[NotificationConstants.dataKeys.job];
        if (jobDataStr != null) {
          final jobJson = jsonDecode(jobDataStr);
          final jobModel = JobModel.fromJson(jobJson);
          final jobEntity = jobModel.toEntity();

          if (Get.isRegistered<WorkerDashboardController>()) {
            Get.find<WorkerDashboardController>().onNewJobReceived(jobEntity);
          }
        }
      } catch (e) {
        debugPrint('Error parsing reactive job data: $e');
      }
    }

    final newNotification = NotificationEntity(
      id: notificationId ??
          message.messageId ??
          DateTime.now().toIso8601String(),
      title: title,
      body: body,
      createdAt: DateTime.now(),
      data: data,
    );
    notifications.insert(0, newNotification);

    _showLocalNotificationUseCase(
      ShowLocalNotificationParams(title: title, body: body, payload: data),
    );
  }

  Future<void> _sendAck(String notificationId, String status) async {
    final result = await _updateNotificationsStatusUseCase(
      UpdateNotificationsStatusParams(
        notificationIds: [notificationId],
        status: status,
      ),
    );
    result.fold(
      (failure) =>
          debugPrint('Error sending ack from controller: ${failure.message}'),
      (_) {},
    );
  }

  void _updateAppBadge() {
    if (kIsWeb) return;
    if (unreadCount.value > 0) {
      FlutterNewBadger.setBadge(unreadCount.value);
    } else {
      FlutterNewBadger.removeBadge();
    }
  }

  Future<void> _requestPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  @override
  void onClose() {
    _tokenRefreshSubscription?.cancel();
    super.onClose();
  }
}

