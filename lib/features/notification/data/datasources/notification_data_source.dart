import 'package:dio/dio.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/common/mixins/base_remote_data_source/base_remote_data_source.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/features/notification/data/models/notification/notification_model.dart';
import 'package:trackyond/features/notification/data/models/request/notification_filter_request_model.dart';

abstract interface class INotificationDataSource {
  Future<ApiResponse<void>> syncFcmToken({
    required UserRole role,
    required String fcmToken,
  });

  Future<ApiResponse<List<NotificationModel>>> getNotifications({
    required UserRole role,
    required NotificationFilterRequestModel options,
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

  NotificationDataSourceImpl(this._dio);

  @override
  Future<ApiResponse<void>> syncFcmToken({
    required UserRole role,
    required String fcmToken,
  }) async {
    final fcmEndpoint = role == UserRole.owner
        ? ApiEndpoints.admin.notificationsFcmToken
        : ApiEndpoints.employee.notificationsFcmToken;

    return performApiRequest(
      _dio.post(fcmEndpoint, data: {_NotificationApiFields.fcmToken: fcmToken}),
      (_) {},
    );
  }

  @override
  Future<ApiResponse<List<NotificationModel>>> getNotifications({
    required UserRole role,
    required NotificationFilterRequestModel options,
  }) async {
    final endpoint = role == UserRole.owner
        ? ApiEndpoints.admin.notifications
        : ApiEndpoints.employee.notifications;

    return performApiRequest(
      _dio.get(endpoint, queryParameters: options.toJson()),
      (data) {
        final notifications =
            (data as Map<String, dynamic>)[_NotificationApiFields.notifications]
                as List;

        return notifications
            .map(
              (json) =>
                  NotificationModel.fromJson(json as Map<String, dynamic>),
            )
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
        data: {_NotificationApiFields.notificationIds: notificationIds},
      ),
      (_) {},
    );
  }
}

class _NotificationApiFields {
  const _NotificationApiFields._();

  static const fcmToken = 'fcmToken';
  static const notificationIds = 'notificationIds';
  static const notifications = 'notifications';
  static const status = 'status';
}
