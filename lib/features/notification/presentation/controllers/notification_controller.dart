import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:synchronized/synchronized.dart';
import 'package:trackyond/core/common/models/job/job_model.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/services/notification/background_ack_service.dart';
import 'package:trackyond/features/notification/domain/entities/notification_entity.dart';
import 'package:trackyond/features/notification/domain/usecases/delete_fcm_token_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/show_local_notification_usecase.dart';
import 'package:trackyond/features/notification/domain/usecases/sync_fcm_token_usecase.dart';
import 'package:trackyond/features/worker/dashboard/presentation/controllers/worker_dashboard_controller.dart';

class NotificationController extends GetxController {
  final SyncFcmTokenUseCase _syncFcmTokenUseCase;
  final DeleteFcmTokenUseCase _deleteFcmTokenUseCase;
  final ShowLocalNotificationUseCase _showLocalNotificationUseCase;

  final _lock = Lock();
  StreamSubscription<String>? _tokenRefreshSubscription;

  // UI Observables
  final unreadCount = 0.obs;
  final notifications = <NotificationEntity>[].obs;

  NotificationController({
    required SyncFcmTokenUseCase syncFcmTokenUseCase,
    required DeleteFcmTokenUseCase deleteFcmTokenUseCase,
    required ShowLocalNotificationUseCase showLocalNotificationUseCase,
  }) : _syncFcmTokenUseCase = syncFcmTokenUseCase,
       _deleteFcmTokenUseCase = deleteFcmTokenUseCase,
       _showLocalNotificationUseCase = showLocalNotificationUseCase;

  @override
  void onInit() {
    super.onInit();

    // request permission
    _requestPermission();

    // Initial sync
    syncToken();

    // Listen for token refreshes
    _tokenRefreshSubscription = FirebaseMessaging.instance.onTokenRefresh
        .listen((_) {
          syncToken();
        });

    // 1. Handle Terminated state (when app is opened from a notification)
    _handleInitialMessage();

    // 2. Handle Background/Paused state (when app is in background and notification is tapped)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('DEBUG ON MESSAGE OPENED APP: ${message.toMap()}');
      _handleNotificationClick(message.data);
    });

    // 3. Handle Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('DEBUG FOREGROUND FCM RAW PAYLOAD: ${message.toMap()}');
      _handleForegroundMessage(message);
    });
  }

  Future<void> _handleInitialMessage() async {
    final RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('DEBUG INITIAL MESSAGE (TERMINATED): ${initialMessage.toMap()}');
      _handleNotificationClick(initialMessage.data);
    }
  }

  void _handleNotificationClick(Map<String, dynamic> data) {
    // Clear unread count when clicking a notification
    unreadCount.value = 0;

    // For now, just open the app (currently handled by OS/Flutter opening the main screen)
    // If specific routing is needed, add it here:
    if (data['type'] == 'jobAssigned') {
      final jobId = data['jobId'];
      debugPrint('User clicked on Job Assigned notification for Job ID: $jobId');
      // Get.toNamed(Routes.JOB_DETAILS, arguments: jobId);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    final data = message.data;

    // Increment badge count
    unreadCount.value++;

    final notificationId = data['notificationId'];
    if (notificationId != null) {
      _sendAck(notificationId, 'delivered');
    }

    // Default values if notification object is missing (data-only message)
    String title = notification?.title ?? 'New Job Assigned';
    String body = notification?.body ?? '';

    // If it's a job assignment, we can customize the body from data
    if (data['type'] == 'jobAssigned') {
      title = 'New Job Assigned';
      final jobTitle = data['title'] ?? '';
      final jobId = data['jobId'] ?? '';
      body = 'Job: $jobTitle (ID: $jobId)';

      // --- REACTIVE UPDATE ---
      try {
        final fullJobDataStr = data['fullJobData'];
        if (fullJobDataStr != null) {
          final jobJson = jsonDecode(fullJobDataStr);
          final jobModel = JobModel.fromJson(jobJson);
          final jobEntity = jobModel.toEntity();

          // Update WorkerDashboardController if it's in memory
          if (Get.isRegistered<WorkerDashboardController>()) {
            Get.find<WorkerDashboardController>().onNewJobReceived(jobEntity);
          }
        }
      } catch (e) {
        debugPrint('Error parsing reactive job data: $e');
      }
    }

    // Add to local notifications list
    final newNotification = NotificationEntity(
      id: notificationId ?? message.messageId ?? DateTime.now().toIso8601String(),
      title: title,
      body: body,
      createdAt: DateTime.now(),
      data: data,
    );
    notifications.insert(0, newNotification);

    _showLocalNotificationUseCase(
      ShowLocalNotificationParams(
        title: title,
        body: body,
        payload: data,
      ),
    );
  }

  void clearUnread() {
    if (unreadCount.value > 0) {
      markAllAsRead();
    }
    unreadCount.value = 0;
  }

  void markAllAsRead() {
    for (var i = 0; i < notifications.length; i++) {
      if (!notifications[i].isRead) {
        notifications[i] = notifications[i].copyWith(isRead: true);
        if (notifications[i].data?['notificationId'] != null) {
          sendReadAck(notifications[i].data!['notificationId']);
        }
      }
    }
  }

  Future<void> sendReadAck(String notificationId) async {
    await _sendAck(notificationId, 'read');
  }

  Future<void> _sendAck(String notificationId, String status) async {
    try {
      final ackService = await BackgroundAckService.init();
      await ackService.sendAck(notificationId, status);
    } catch (e) {
      debugPrint("Error sending ack from controller: $e");
    }
  }

  @override
  void onClose() {
    _tokenRefreshSubscription?.cancel();
    super.onClose();
  }

  Future<void> syncToken() async {
    await _lock.synchronized(() async {
      await _syncFcmTokenUseCase(const NoParams());
    });
  }

  Future<void> deleteFcmToken() async {
    await _deleteFcmTokenUseCase(const NoParams());
  }

  Future<void> _requestPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
