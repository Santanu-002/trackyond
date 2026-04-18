import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:trackyond/core/services/device_header/device_id_service.dart';

class DeviceInfoService {
  final DeviceIdService _deviceIdService;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  Map<String, String>? _cache;

  DeviceInfoService(this._deviceIdService);

  Future<Map<String, String>> getDeviceInfo() async {
    if (_cache != null) return _cache!;

    String deviceOs = '';
    String deviceOsVersion = '';
    String deviceId = await _deviceIdService.getDeviceId();
    String deviceName = '';
    String browser = 'NA';
    String browserVersion = 'NA';

    if (kIsWeb) {
      final web = await _deviceInfo.webBrowserInfo;
      deviceOs = web.platform ?? 'web';
      deviceName = 'browser';
      browser = web.browserName.name;
      browserVersion = web.appVersion ?? 'NA';
      deviceOsVersion = 'NA';
    } else if (Platform.isAndroid) {
      final a = await _deviceInfo.androidInfo;
      deviceOs = 'android';
      deviceOsVersion = a.version.release;
      deviceName = a.model;
    } else if (Platform.isIOS) {
      final i = await _deviceInfo.iosInfo;
      deviceOs = 'ios';
      deviceOsVersion = i.systemVersion;
      deviceName = i.name;
    }

    _cache = {
      'device-os': deviceOs,
      'device-os-version': deviceOsVersion,
      'device-id': deviceId,
      'device-name': deviceName,
      'browser': browser,
      'browser-version': browserVersion,
    };

    return _cache!;
  }

  void clearCache() => _cache = null;
}
