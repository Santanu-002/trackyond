import 'package:trackyond/core/services/device_header/app_info_service.dart';
import 'package:trackyond/core/services/device_header/device_info_service.dart';

class PlatformInfoService {
  final DeviceInfoService deviceInfoService;
  final AppInfoService appInfoService;

  Map<String, String>? _cache;

  PlatformInfoService({
    required this.deviceInfoService,
    required this.appInfoService,
  });

  Future<Map<String, String>> getPlatformInfo() async {
    if (_cache != null) return _cache!;

    final deviceInfo = await deviceInfoService.getDeviceInfo();
    final appInfo = await appInfoService.getAppInfo();

    _cache = {
      ...deviceInfo,
      ...appInfo,
    };

    return _cache!;
  }

  void clearCache() {
    _cache = null;
    deviceInfoService.clearCache();
    appInfoService.clearCache();
  }
}
