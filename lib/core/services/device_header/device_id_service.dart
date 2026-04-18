import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeviceIdService {
  final FlutterSecureStorage _storage;
  static const _deviceIdKey = 'device_id';
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  DeviceIdService(this._storage);

  static const MethodChannel _channel = MethodChannel('device_id_channel');

  Future<String> _getAndroidIdFromNative() async {
    try {
      final String? id = await _channel.invokeMethod<String>('getAndroidId');
      return id ?? '';
    } catch (e) {
      debugPrint('Failed to get Android ID: $e');
      return '';
    }
  }

  Future<String> getDeviceId() async {
    final deviceId = await _storage.read(key: _deviceIdKey);
    if (deviceId != null) return deviceId;

    if (Platform.isAndroid) {
      final id = await _getAndroidIdFromNative();
      await _setDeviceId(id);
      return id;
    } else if (Platform.isIOS) {
      final i = await _deviceInfo.iosInfo;
      final id = i.identifierForVendor ?? '';
      await _setDeviceId(id);
      return id;
    } else if (kIsWeb) {
      const id = 'NA';
      await _setDeviceId(id);
      return id;
    } else {
      return 'NA';
    }
  }

  Future<void> _setDeviceId(String deviceId) async {
    await _storage.write(key: _deviceIdKey, value: deviceId);
  }
}
