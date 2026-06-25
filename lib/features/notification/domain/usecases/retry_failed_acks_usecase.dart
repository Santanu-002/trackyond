import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/notification/domain/repositories/i_notification_repository.dart';

class RetryFailedAcksUseCase implements BaseUseCase<Unit, NoParams> {
  final INotificationRepository _repository;

  RetryFailedAcksUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> call(NoParams params) {
    return _repository.retryFailedAcks();
  }
}
