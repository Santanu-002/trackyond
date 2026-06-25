import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/notification/domain/repositories/i_notification_repository.dart';

class ClearConversationNotificationsUseCase implements BaseUseCase<Unit, String> {
  final INotificationRepository _repository;

  ClearConversationNotificationsUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> call(String jobId) {
    return _repository.clearConversationNotifications(jobId);
  }
}
