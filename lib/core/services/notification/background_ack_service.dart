import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/core/network/api/request_extras.dart';
import 'package:trackyond/core/network/client/client.dart';
import 'package:trackyond/core/services/user/user_service.dart';

class BackgroundAckService {
  late final NetworkClient _networkClient;
  Dio get dio => _networkClient.dio;
  UserService get userService => _networkClient.userService;

  BackgroundAckService._();

  static Future<BackgroundAckService> init() async {
    final service = BackgroundAckService._();
    await service._setup();
    return service;
  }

  Future<void> _setup() async {
    _networkClient = await NetworkClient.createBackgroundClient();
  }

  Future<void> sendAck(String notificationId, String status) async {
    final role = userService.getUserRole();
    if (role == null) return; // Cannot send ack if not logged in

    final endpoint = role == UserRole.owner
        ? '${ApiEndpoints.admin.notifications}/$notificationId/status'
        : '${ApiEndpoints.employee.notifications}/$notificationId/status';

    try {
      await dio.put(
        endpoint,
        data: {'status': status},
        options: Options(
          extra: {RequestExtras.userRole: role.value},
        ),
      );
      debugPrint('DEBUG: Successfully sent $status ack for notification $notificationId');
    } catch (e) {
      debugPrint('DEBUG: Failed to send $status ack for notification $notificationId: $e');
      if (status == 'delivered') {
         await _saveFailedAck(notificationId, status);
      }
    }
  }

  Future<void> _saveFailedAck(String notificationId, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final failedAcksStr = prefs.getString('failed_acks') ?? '[]';
    final List<dynamic> failedAcks = jsonDecode(failedAcksStr);
    
    // Avoid duplicates
    if (!failedAcks.any((ack) => ack['id'] == notificationId && ack['status'] == status)) {
      failedAcks.add({'id': notificationId, 'status': status});
      await prefs.setString('failed_acks', jsonEncode(failedAcks));
    }
  }

  Future<void> retryFailedAcks() async {
    final prefs = await SharedPreferences.getInstance();
    final failedAcksStr = prefs.getString('failed_acks') ?? '[]';
    final List<dynamic> failedAcks = jsonDecode(failedAcksStr);

    if (failedAcks.isEmpty) return;

    List<dynamic> remainingAcks = [];

    for (final ack in failedAcks) {
      final role = userService.getUserRole();
      if (role == null) continue;

      final notificationId = ack['id'];
      final status = ack['status'];

      final endpoint = role == UserRole.owner
          ? '${ApiEndpoints.admin.notifications}/$notificationId/status'
          : '${ApiEndpoints.employee.notifications}/$notificationId/status';

      try {
        await dio.put(
          endpoint,
          data: {'status': status},
          options: Options(
            extra: {RequestExtras.userRole: role.value},
          ),
        );
        debugPrint('DEBUG: Successfully retried $status ack for notification $notificationId');
      } catch (e) {
        debugPrint('DEBUG: Failed to retry $status ack for notification $notificationId: $e');
        remainingAcks.add(ack); // Keep it for next retry
      }
    }

    await prefs.setString('failed_acks', jsonEncode(remainingAcks));
  }
}

