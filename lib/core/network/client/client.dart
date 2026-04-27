import 'package:dio/dio.dart';
import 'package:trackyond/core/network/interceptors/logging_interceptor.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/core/network/interceptors/auth_interceptor.dart';
import 'package:trackyond/core/network/interceptors/network_error_interceptor.dart';
import 'package:trackyond/core/network/interceptors/platform_info_interceptor.dart';
import 'package:trackyond/core/services/device_header/platform_info_service.dart';
import 'package:trackyond/core/services/token/token_service.dart';
import 'package:trackyond/core/services/user/user_service.dart';

class NetworkClient {
  late final Dio dio;

  NetworkClient({
    required TokenService tokenService,
    required PlatformInfoService platformInfoService,
    required UserService userService,
  }) : dio = Dio(
         BaseOptions(
           baseUrl: ApiEndpoints.baseUrl,
           connectTimeout: const Duration(seconds: 15),
           receiveTimeout: const Duration(seconds: 15),
           contentType: 'application/json',
         ),
       ) {
    dio.interceptors.add(
      AuthInterceptor(tokenService, platformInfoService, userService),
    );
    dio.interceptors.add(PlatformInfoInterceptor(platformInfoService));
    dio.interceptors.add(NetworkErrorInterceptor());

    dio.interceptors.add(LoggingInterceptor());
  }
}
