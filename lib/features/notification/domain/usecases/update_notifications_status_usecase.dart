import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/notification/domain/repositories/i_notification_repository.dart';

class UpdateNotificationsStatusUseCase implements BaseUseCase<void, UpdateNotificationsStatusParams> {
  final INotificationRepository _repository;

  UpdateNotificationsStatusUseCase(this._repository);

  @override
  Future<Either<AppFailure, void>> call(UpdateNotificationsStatusParams params) async {
    return _repository.updateNotificationsStatus(
      notificationIds: params.notificationIds,
      status: params.status,
    );
  }
}

class UpdateNotificationsStatusParams {
  final List<String> notificationIds;
  final String status;

  UpdateNotificationsStatusParams({
    required this.notificationIds,
    required this.status,
  });
}
