import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackyond/core/network/client/client.dart';
import 'package:trackyond/core/services/device_header/app_info_service.dart';
import 'package:trackyond/core/services/device_header/device_id_service.dart';
import 'package:trackyond/core/services/device_header/device_info_service.dart';
import 'package:trackyond/core/services/device_header/platform_info_service.dart';
import 'package:trackyond/core/services/notification/fcm_token_service.dart';
import 'package:trackyond/core/services/notification/notification_service.dart';
import 'package:trackyond/core/services/token/token_service.dart';
import 'package:trackyond/core/services/token/token_service_impl.dart';
import 'package:trackyond/core/services/user/user_service.dart';

class AppInitializer {
  const AppInitializer._();

  static Future<void> initialize() async {
    debugPrint('INIT: Starting AppInitializer.initialize()');
    await Firebase.initializeApp();
    debugPrint('INIT: Firebase initialized');
    NotificationService.registerBackgroundHandler();
    debugPrint('INIT: Background notification handler registered');
    await _initStorage();
    debugPrint('INIT: Storage initialized');
    await _initServices();
    debugPrint('INIT: Services initialized');
  }

  // ------------------ STORAGE ------------------

  static Future<void> _initStorage() async {
    debugPrint('INIT: Initializing SharedPreferences');
    final prefs = await SharedPreferences.getInstance();
    Get.put<SharedPreferences>(prefs, permanent: true);
    Get.put<FlutterSecureStorage>(const FlutterSecureStorage(), permanent: true);
    debugPrint('INIT: Storage initialized');
  }

  // ------------------ SERVICES ------------------

  static Future<void> _initServices() async {
    debugPrint('INIT: Initializing services');
    Get.put<TokenService>(TokenServiceImpl(Get.find()), permanent: true);
    debugPrint('INIT: TokenService initialized');

    Get.put<FCMTokenService>(FCMTokenService(Get.find()), permanent: true);
    debugPrint('INIT: FCMTokenService initialized');

    final userService = UserService(Get.find());
    debugPrint('INIT: Initializing UserService');
    await userService.init();
    Get.put<UserService>(userService, permanent: true);
    debugPrint('INIT: UserService initialized');

    // Device header services (used by PlatformInfoInterceptor on every request)
    final deviceIdService = DeviceIdService(Get.find<FlutterSecureStorage>());
    Get.put<DeviceIdService>(deviceIdService, permanent: true);
    debugPrint('INIT: DeviceIdService initialized');

    Get.put<DeviceInfoService>(
      DeviceInfoService(deviceIdService),
      permanent: true,
    );
    debugPrint('INIT: DeviceInfoService initialized');

    Get.put<AppInfoService>(AppInfoService(), permanent: true);
    debugPrint('INIT: AppInfoService initialized');

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
