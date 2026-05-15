import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/core/network/interceptors/auth_interceptor.dart';
import 'package:trackyond/core/network/interceptors/logging_interceptor.dart';
import 'package:trackyond/core/network/interceptors/network_error_interceptor.dart';
import 'package:trackyond/core/network/interceptors/platform_info_interceptor.dart';
import 'package:trackyond/core/services/device_header/app_info_service.dart';
import 'package:trackyond/core/services/device_header/device_id_service.dart';
import 'package:trackyond/core/services/device_header/device_info_service.dart';
import 'package:trackyond/core/services/device_header/platform_info_service.dart';
import 'package:trackyond/core/services/token/token_service.dart';
import 'package:trackyond/core/services/token/token_service_impl.dart';
import 'package:trackyond/core/services/user/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkClient {
  late final Dio dio;
  late final UserService userService;

  NetworkClient({
    required TokenService tokenService,
    required PlatformInfoService platformInfoService,
    required this.userService,
  }) : dio = Dio(
         BaseOptions(
           baseUrl: ApiEndpoints.baseUrl,
           connectTimeout: const Duration(seconds: 15),
           receiveTimeout: const Duration(seconds: 15),
           contentType: 'application/json',
         ),
       ) {
    dio.interceptors.add(AuthInterceptor(tokenService, platformInfoService, userService));
    dio.interceptors.add(PlatformInfoInterceptor(platformInfoService));
    dio.interceptors.add(NetworkErrorInterceptor());
    dio.interceptors.add(LoggingInterceptor());
  }

  NetworkClient._();

  // 🔹 Background initialization (self bootstrap)
  static Future<NetworkClient> createBackground() async {
    final storage = const FlutterSecureStorage();
    final prefs = await SharedPreferences.getInstance();
    final tokenService = TokenServiceImpl(storage);
    final userService = UserService(prefs);
    await userService.init();

    final platformInfoService = PlatformInfoService(
      deviceInfoService: DeviceInfoService(DeviceIdService(storage)),
      appInfoService: AppInfoService(),
    );

    final client = NetworkClient._();
    client._init(tokenService, platformInfoService, userService);
    return client;
  }

  void _init(
    TokenService tokenService,
    PlatformInfoService platformInfoService,
    UserService userService,
  ) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );
    this.userService = userService;

    dio.interceptors.add(AuthInterceptor(tokenService, platformInfoService, userService));
    dio.interceptors.add(PlatformInfoInterceptor(platformInfoService));
    dio.interceptors.add(NetworkErrorInterceptor());
    dio.interceptors.add(LoggingInterceptor());
  }
}
