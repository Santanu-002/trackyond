import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';

abstract class INotificationRepository {
  Future<Either<AppFailure, void>> syncFcmToken();
}
