import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/notification/domain/repositories/i_notification_repository.dart';

class DeleteNotificationsUseCase implements BaseUseCase<Unit, DeleteNotificationsParams> {
  final INotificationRepository _repository;

  DeleteNotificationsUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> call(DeleteNotificationsParams params) async {
    return _repository.deleteNotifications(notificationIds: params.notificationIds);
  }
}

class DeleteNotificationsParams {
  final List<String> notificationIds;

  DeleteNotificationsParams({required this.notificationIds});
}
