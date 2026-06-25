import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/notification/domain/entities/notification_entity.dart';
import 'package:trackyond/features/notification/domain/entities/notification_filter_options.dart';

abstract interface class INotificationRepository {
  Future<Either<AppFailure, Unit>> syncFcmToken();

  Future<Either<AppFailure, Unit>> deleteFcmToken();

  Future<Either<AppFailure, Unit>> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  });

  Future<Either<AppFailure, List<NotificationEntity>>> getNotifications({
    required NotificationFilterOptions options,
  });

  Future<Either<AppFailure, Unit>> updateNotificationsStatus({
    required List<String> notificationIds,
    required String status,
  });

  Future<Either<AppFailure, Unit>> deleteNotifications({
    required List<String> notificationIds,
  });

  Future<Either<AppFailure, Unit>> retryFailedAcks();

  Future<Either<AppFailure, Unit>> clearConversationNotifications(String jobId);
}
