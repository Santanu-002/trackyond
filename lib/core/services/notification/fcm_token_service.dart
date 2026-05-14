import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FCMTokenService extends GetxService {
  final SharedPreferences _prefs;
  
  static const String _fcmTokenKey = 'last_fcm_token';
  static const String _isSyncedKey = 'is_fcm_synced';

  FCMTokenService(this._prefs);

  /// Get current FCM token from Firebase
  Future<String?> getCurrentToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint("Failed to get FCM token: $e");
      return null;
    }
  }

  /// Get last stored FCM token from local storage
  String? getLastToken() {
    return _prefs.getString(_fcmTokenKey);
  }

  /// Check if token has been synced to the server
  bool getIsSynced() {
    return _prefs.getBool(_isSyncedKey) ?? false;
  }

  /// Mark token as synced and save it to local storage
  Future<void> markTokenAsSynced(String token) async {
    await _prefs.setString(_fcmTokenKey, token);
    await _prefs.setBool(_isSyncedKey, true);
  }

  /// Mark token as unsynced (needs to be synced with server)
  Future<void> markTokenAsUnsynced() async {
    await _prefs.setBool(_isSyncedKey, false);
  }

  /// Delete FCM token from Firebase and clear local storage
  Future<void> deleteToken() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
      await _prefs.remove(_fcmTokenKey);
      await _prefs.remove(_isSyncedKey);
    } catch (e) {
      debugPrint("Failed to delete FCM token: $e");
    }
  }
}
