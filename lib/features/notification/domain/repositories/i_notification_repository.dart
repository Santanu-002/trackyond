import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/notification/domain/entities/notification_entity.dart';
import 'package:trackyond/features/notification/domain/entities/notification_filter_options.dart';

abstract interface class INotificationRepository {
  Future<Either<AppFailure, void>> syncFcmToken();

  Future<Either<AppFailure, void>> deleteFcmToken();

  Future<Either<AppFailure, void>> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  });

  Future<Either<AppFailure, List<NotificationEntity>>> getNotifications({
    required NotificationFilterOptions options,
  });

  Future<Either<AppFailure, void>> updateNotificationsStatus({
    required List<String> notificationIds,
    required String status,
  });

  Future<Either<AppFailure, void>> deleteNotifications({
    required List<String> notificationIds,
  });

  Future<Either<AppFailure, void>> retryFailedAcks();

  Future<Either<AppFailure, void>> clearConversationNotifications(String jobId);
}
