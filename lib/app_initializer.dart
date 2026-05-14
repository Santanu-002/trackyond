import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackyond/core/network/client/client.dart';
import 'package:trackyond/core/services/device_header/app_info_service.dart';
import 'package:trackyond/core/services/device_header/device_id_service.dart';
import 'package:trackyond/core/services/device_header/device_info_service.dart';
import 'package:trackyond/core/services/device_header/platform_info_service.dart';
import 'package:trackyond/core/services/token/token_service.dart';
import 'package:trackyond/core/services/token/token_service_impl.dart';
import 'package:trackyond/core/services/user/user_service.dart';

import 'package:trackyond/core/services/notification/background_ack_service.dart';

class AppInitializer {
  const AppInitializer._();

  static Future<void> initialize() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _initStorage();
    await _initServices();
    
    // Retry any failed acks on app startup
    try {
      final ackService = await BackgroundAckService.init();
      await ackService.retryFailedAcks();
    } catch (e) {
      debugPrint("Failed to retry acks on startup: $e");
    }
  }

  // MUST be a top-level function
  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
    debugPrint("Handling a background message: ${message.messageId}");
    
    try {
      final notificationId = message.data['notificationId'];
      if (notificationId != null) {
        final ackService = await BackgroundAckService.init();
        await ackService.sendAck(notificationId, 'delivered');
      }
    } catch (e) {
      debugPrint("Error sending background ack: $e");
    }
  }

  // ------------------ STORAGE ------------------

  static Future<void> _initStorage() async {
    final prefs = await SharedPreferences.getInstance();
    Get.put<SharedPreferences>(prefs, permanent: true);
    Get.put<FlutterSecureStorage>(const FlutterSecureStorage(), permanent: true);
  }

  // ------------------ SERVICES ------------------

  static Future<void> _initServices() async {
    Get.put<TokenService>(TokenServiceImpl(Get.find()), permanent: true);

    final userService = UserService(Get.find());
    await userService.init();
    Get.put<UserService>(userService, permanent: true);

    // Device header services (used by PlatformInfoInterceptor on every request)
    final deviceIdService = DeviceIdService(Get.find<FlutterSecureStorage>());
    Get.put<DeviceIdService>(deviceIdService, permanent: true);

    Get.put<DeviceInfoService>(
      DeviceInfoService(deviceIdService),
      permanent: true,
    );

    Get.put<AppInfoService>(AppInfoService(), permanent: true);

    Get.put<PlatformInfoService>(
      PlatformInfoService(
        deviceInfoService: Get.find(),
        appInfoService: Get.find(),
      ),
      permanent: true,
    );

    // Initialize Network and register Dio for individual injection
    final networkClient = NetworkClient(
      tokenService: Get.find(),
      platformInfoService: Get.find(),
      userService: Get.find(),
    );

    Get.put<Dio>(networkClient.dio, permanent: true);
  }
}
