import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackyond/core/network/interceptors/logging_interceptor.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/core/network/interceptors/auth_interceptor.dart';
import 'package:trackyond/core/network/interceptors/network_error_interceptor.dart';
import 'package:trackyond/core/network/interceptors/platform_info_interceptor.dart';
import 'package:trackyond/core/services/device_header/app_info_service.dart';
import 'package:trackyond/core/services/device_header/device_id_service.dart';
import 'package:trackyond/core/services/device_header/device_info_service.dart';
import 'package:trackyond/core/services/device_header/platform_info_service.dart';
import 'package:trackyond/core/services/token/token_service.dart';
import 'package:trackyond/core/services/token/token_service_impl.dart';
import 'package:trackyond/core/services/user/user_service.dart';

class NetworkClient {
  late final Dio dio;
  final UserService userService; // Exposed for background access

  NetworkClient({
    required TokenService tokenService,
    required PlatformInfoService platformInfoService,
    required this.userService,
  }) {
    _init(tokenService, platformInfoService, userService);
  }

  // Private constructor for background initialization
  NetworkClient._background(this.userService, TokenService tokenService, PlatformInfoService platformInfoService) {
     _init(tokenService, platformInfoService, userService);
  }

  void _init(TokenService tokenService, PlatformInfoService platformInfoService, UserService userService) {
    dio = Dio(
         BaseOptions(
           baseUrl: ApiEndpoints.baseUrl,
           connectTimeout: const Duration(seconds: 15),
           receiveTimeout: const Duration(seconds: 15),
           contentType: 'application/json',
         ),
       );

    dio.interceptors.add(
      AuthInterceptor(tokenService, platformInfoService, userService),
    );
    dio.interceptors.add(PlatformInfoInterceptor(platformInfoService));
    dio.interceptors.add(NetworkErrorInterceptor());

    dio.interceptors.add(LoggingInterceptor());
  }

  /// Creates a self-bootstrapped NetworkClient for use in background isolates 
  /// where GetX dependencies are not fully mounted.
  static Future<NetworkClient> createBackgroundClient() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = const FlutterSecureStorage();
    final tokenService = TokenServiceImpl(storage);
    
    final deviceIdService = DeviceIdService(storage);
    final deviceInfoService = DeviceInfoService(deviceIdService);
    final appInfoService = AppInfoService();
    
    final platformInfoService = PlatformInfoService(
      deviceInfoService: deviceInfoService,
      appInfoService: appInfoService,
    );

    final userService = UserService(prefs);
    await userService.init(); // Loads user role from prefs

    return NetworkClient._background(userService, tokenService, platformInfoService);
  }
}
