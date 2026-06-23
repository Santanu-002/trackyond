import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/services/notification/background_ack_service.dart';
import 'package:trackyond/core/services/notification/local_notification_service.dart';
import 'package:trackyond/core/services/user/user_service.dart';
import 'package:trackyond/core/services/notification/fcm_token_service.dart';
import 'package:trackyond/features/notification/data/datasources/notification_data_source.dart';
import 'package:trackyond/features/notification/data/models/request/notification_filter_request_model.dart';
import 'package:trackyond/features/notification/domain/entities/notification_entity.dart';
import 'package:trackyond/features/notification/domain/entities/notification_filter_options.dart';
import 'package:trackyond/features/notification/domain/repositories/i_notification_repository.dart';

class NotificationRepositoryImpl implements INotificationRepository {
  final INotificationDataSource _dataSource;
  final UserService _userService;
  final LocalNotificationService _localNotificationService;
  final FCMTokenService _fcmTokenService;
  final BackgroundAckService _backgroundAckService;

  NotificationRepositoryImpl(
    this._dataSource,
    this._userService,
    this._localNotificationService,
    this._fcmTokenService,
    this._backgroundAckService,
  );

  @override
  Future<Either<AppFailure, void>> syncFcmToken() async {
    final role = _userService.getUserRole();
    if (role == null) {
      return Left(CacheFailure(AppStrings.notifications.userRoleNotFound));
    }

    final fcmToken = await _fcmTokenService.getCurrentToken();
    if (fcmToken == null) {
      return Left(CacheFailure(AppStrings.notifications.fcmTokenNotFound));
    }

    final lastToken = _fcmTokenService.getLastToken();
    final isSynced = _fcmTokenService.getIsSynced();

    // Check if token is already synced and hasn't changed
    if (fcmToken == lastToken && isSynced) {
      return const Right(null);
    }

    final response = await _dataSource.syncFcmToken(
      role: role,
      fcmToken: fcmToken,
    );

    return response.when(
      success: (_, message, _) {
        _fcmTokenService.markTokenAsSynced(fcmToken);
        return const Right(null);
      },
      error: (_, message, _, _) {
        _fcmTokenService.markTokenAsUnsynced();
        return Left(ServerFailure(message));
      },
    );
  }

  @override
  Future<Either<AppFailure, void>> deleteFcmToken() async {
    try {
      await _fcmTokenService.deleteToken();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    try {
      await _localNotificationService.showNotification(
        id: DateTime.now().millisecond,
        title: title,
        body: body,
        payload: payload != null ? jsonEncode(payload) : null,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<NotificationEntity>>> getNotifications({
    required NotificationFilterOptions options,
  }) async {
    final role = _userService.getUserRole();
    if (role == null) {
      return Left(CacheFailure(AppStrings.notifications.userRoleNotFound));
    }

    final response = await _dataSource.getNotifications(
      role: role,
      options: NotificationFilterRequestModel.fromEntity(options),
    );
    return response.when(
      success: (_, message, models) {
        if (models == null) return Left(ServerFailure(message));
        return Right(models.map((model) => model.toEntity()).toList());
      },
      error: (_, message, _, _) => Left(ServerFailure(message)),
    );
  }

  @override
  Future<Either<AppFailure, void>> updateNotificationsStatus({
    required List<String> notificationIds,
    required String status,
  }) async {
    final role = _userService.getUserRole();
    if (role == null) {
      return Left(CacheFailure(AppStrings.notifications.userRoleNotFound));
    }

    final response = await _dataSource.updateNotificationsStatus(
      role: role,
      notificationIds: notificationIds,
      status: status,
    );
    return _mapVoidResponse(response);
  }

  @override
  Future<Either<AppFailure, void>> deleteNotifications({
    required List<String> notificationIds,
  }) async {
    final role = _userService.getUserRole();
    if (role == null) {
      return Left(CacheFailure(AppStrings.notifications.userRoleNotFound));
    }

    final response = await _dataSource.deleteNotifications(
      role: role,
      notificationIds: notificationIds,
    );
    return _mapVoidResponse(response);
  }

  @override
  Future<Either<AppFailure, void>> retryFailedAcks() async {
    try {
      await _backgroundAckService.retryFailedAcks();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Either<AppFailure, void> _mapVoidResponse(ApiResponse<void> response) {
    return response.when(
      success: (_, _, _) => const Right(null),
      error: (_, message, _, _) => Left(ServerFailure(message)),
    );
  }

  @override
  Future<Either<AppFailure, void>> clearConversationNotifications(String jobId) async {
    try {
      _localNotificationService.clearConversationMessages(jobId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
