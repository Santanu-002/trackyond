import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/notification/domain/repositories/i_notification_repository.dart';

class SyncFcmTokenUseCase implements BaseUseCase<Unit, NoParams> {
  final INotificationRepository _repository;

  SyncFcmTokenUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> call(NoParams params) async {
    return await _repository.syncFcmToken();
  }
}
