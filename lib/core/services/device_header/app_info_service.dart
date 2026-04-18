import 'package:package_info_plus/package_info_plus.dart';

class AppInfoService {
  Map<String, String>? _cache;

  Future<Map<String, String>> getAppInfo() async {
    if (_cache != null) return _cache!;

    final info = await PackageInfo.fromPlatform();

    _cache = {'app-version': info.version};

    return _cache!;
  }

  void clearCache() => _cache = null;
}
