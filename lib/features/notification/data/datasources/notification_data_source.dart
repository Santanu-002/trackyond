import 'dart:io';

import 'package:dio/dio.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/common/mixins/base_remote_data_source/base_remote_data_source.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/core/services/device_header/device_id_service.dart';
import 'package:trackyond/features/notification/data/models/notification_model.dart';

import 'package:trackyond/features/notification/domain/entities/notification_filter_options.dart';

abstract interface class INotificationDataSource {
  Future<ApiResponse<void>> syncFcmToken({
    required UserRole role,
    required String fcmToken,
  });

  Future<ApiResponse<List<NotificationModel>>> getNotifications({
    required UserRole role,
    required NotificationFilterOptions options,
  });

  Future<ApiResponse<void>> updateNotificationsStatus({
    required UserRole role,
    required List<String> notificationIds,
    required String status,
  });

  Future<ApiResponse<void>> deleteNotifications({
    required UserRole role,
    required List<String> notificationIds,
  });
}

class NotificationDataSourceImpl
    with BaseRemoteDataSource
    implements INotificationDataSource {
  final Dio _dio;
  final DeviceIdService _deviceService;

  NotificationDataSourceImpl(this._dio, this._deviceService);

  @override
  Future<ApiResponse<void>> syncFcmToken({
    required UserRole role,
    required String fcmToken,
  }) async {
    final fcmEndpoint = role == UserRole.owner
        ? ApiEndpoints.admin.notificationsFcmToken
        : ApiEndpoints.employee.notificationsFcmToken;
    final deviceId = await _deviceService.getDeviceId();

    return performApiRequest(
      _dio.post(
        fcmEndpoint,
        data: {
          _NotificationApiFields.deviceId: deviceId,
          _NotificationApiFields.fcmToken: fcmToken,
          _NotificationApiFields.platform: Platform.operatingSystem,
          _NotificationApiFields.appVersion:
              _NotificationApiValues.appVersion,
        },
      ),
      (_) {},
    );
  }

  @override
  Future<ApiResponse<List<NotificationModel>>> getNotifications({
    required UserRole role,
    required NotificationFilterOptions options,
  }) async {
    final endpoint = role == UserRole.owner
        ? ApiEndpoints.admin.notifications
        : ApiEndpoints.employee.notifications;

    return performApiRequest(
      _dio.get(
        endpoint,
        queryParameters: {
          _NotificationApiFields.limit: options.limit,
          _NotificationApiFields.offset: options.offset,
          if (options.isRead != null) 'is_read': options.isRead,
          'is_newest_first': options.isNewestFirst,
        },
      ),
      (data) {
        final notifications =
            (data as Map<String, dynamic>)[_NotificationApiFields.notifications]
                as List;
        return notifications
            .map((json) =>
                NotificationModel.fromJson(json as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<ApiResponse<void>> updateNotificationsStatus({
    required UserRole role,
    required List<String> notificationIds,
    required String status,
  }) async {
    final endpoint = role == UserRole.owner
        ? ApiEndpoints.admin.notificationsStatus
        : ApiEndpoints.employee.notificationsStatus;

    return performApiRequest(
      _dio.post(
        endpoint,
        data: {
          _NotificationApiFields.notificationIds: notificationIds,
          _NotificationApiFields.status: status,
        },
      ),
      (_) {},
    );
  }

  @override
  Future<ApiResponse<void>> deleteNotifications({
    required UserRole role,
    required List<String> notificationIds,
  }) async {
    final endpoint = role == UserRole.owner
        ? ApiEndpoints.admin.notifications
        : ApiEndpoints.employee.notifications;

    return performApiRequest(
      _dio.delete(
        endpoint,
        data: {
          _NotificationApiFields.notificationIds: notificationIds,
        },
      ),
      (_) {},
    );
  }
}

class _NotificationApiFields {
  const _NotificationApiFields._();

  static const appVersion = 'appVersion';
  static const deviceId = 'deviceId';
  static const fcmToken = 'fcmToken';
  static const limit = 'limit';
  static const notificationIds = 'notificationIds';
  static const notifications = 'notifications';
  static const offset = 'offset';
  static const platform = 'platform';
  static const status = 'status';
}

class _NotificationApiValues {
  const _NotificationApiValues._();

  static const appVersion = '1.0.0';
}
