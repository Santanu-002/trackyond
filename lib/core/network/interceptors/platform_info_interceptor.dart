import 'package:dio/dio.dart';
import 'package:trackyond/core/services/device_header/platform_info_service.dart';

class PlatformInfoInterceptor extends Interceptor {
  final PlatformInfoService platformInfoService;

  PlatformInfoInterceptor(this.platformInfoService);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final platformHeaders = await platformInfoService.getPlatformInfo();

    options.headers.addAll(platformHeaders);

    handler.next(options);
  }
}
