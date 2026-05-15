import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/notification_constants.dart';
import 'package:trackyond/core/services/notification/background_ack_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling a background message: ${message.messageId}');

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
