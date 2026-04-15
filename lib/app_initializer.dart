import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackyond/core/services/token/token_service.dart';
import 'package:trackyond/core/services/token/token_service_impl.dart';
import 'package:trackyond/core/services/user/user_service.dart';

class AppInitializer {
const  AppInitializer._();

  static Future<void> initialize() async {
    await _initStorage();
    await _initServices();
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
  }
}