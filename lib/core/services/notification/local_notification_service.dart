import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/notification_constants.dart';

class LocalNotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    init();
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
        // Handle notification tap
        _handleNotificationTap(response.payload);
      },
    );
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

  void _handleNotificationTap(String? payload) {
    if (payload != null) {
      // For now, just open the app (Get.toNamed or similar if routing is needed later)
      // Since it's GetX, we can use Get.toNamed if we have routes.
      // The requirement says "onclick to open the app (currently will change in future)".
      debugPrint('Notification tapped with payload: $payload');
    }
  }
}
