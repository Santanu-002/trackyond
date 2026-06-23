import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/notification_constants.dart';
import 'package:trackyond/core/services/notification/background_ack_service.dart';
import 'package:trackyond/core/services/notification/local_notification_service.dart';
import 'package:trackyond/core/services/database/database_service_impl.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_local_datasource.dart';
import 'package:trackyond/features/job_chat/data/models/response/job_chat_message_model.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling a background message: ${message.messageId}');

  try {
    final type = message.data['type'] ?? message.data[NotificationConstants.dataKeys.type];
    if (type == 'cancelNotification') {
      final jobId = message.data['jobId'];
      if (jobId != null) {
        await FlutterLocalNotificationsPlugin().cancel(id: jobId.hashCode);
        LocalNotificationService.clearConversationMessagesStatic(jobId);
        debugPrint('FCM: Cancelled background notification for job $jobId');
      }
      return;
    }

    if (type == NotificationConstants.types.jobChatMessage) {
      final messageJsonStr = message.data['message'];
      if (messageJsonStr != null) {
        final messageJson = jsonDecode(messageJsonStr);
        final jobId = messageJson['jobId'] as String?;
        final messageUid = messageJson['uid'] as String?;
        if (jobId != null && messageUid != null) {
          try {
            // Save the received message to SQLite first!
            final dbService = DatabaseServiceImpl();
            final localDataSource = JobChatLocalDataSourceImpl(dbService);
            final chatMessageModel = JobChatMessageModel.fromJson(messageJson as Map<String, dynamic>);
            
            await localDataSource.saveMessages([chatMessageModel]);
            debugPrint('FCM Background: Successfully cached message $messageUid in SQLite.');

            // Send delivered status update to backend in background
            await LocalNotificationService.markAsDelivered(jobId, [messageUid]);
          } catch (dbError) {
            debugPrint('FCM Background: Error saving message to database (suppressing ack): $dbError');
          }
        }
      }
    }
  } catch (e) {
    debugPrint('Error handling background chat message delivery: $e');
  }

  try {
    final notificationId =
        message.data[NotificationConstants.dataKeys.notificationId];
    if (notificationId != null) {
      final ackService = await BackgroundAckService.init();
      await ackService.sendAck(
        notificationId,
        NotificationConstants.statuses.delivered,
      );
    }
  } catch (e) {
    debugPrint('Error sending background ack: $e');
  }
}

class NotificationService extends GetxService {
  NotificationService();

  static void registerBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
}
