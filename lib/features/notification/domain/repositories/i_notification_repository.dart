import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';

abstract class INotificationRepository {
  Future<Either<AppFailure, void>> syncFcmToken();
  Future<Either<AppFailure, void>> deleteFcmToken();
  Future<Either<AppFailure, void>> showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  });
}
