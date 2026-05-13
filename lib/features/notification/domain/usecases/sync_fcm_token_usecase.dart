import 'package:fpdart/fpdart.dart';
import 'package:trackyond/features/notification/domain/repositories/i_notification_repository.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';

class SyncFcmTokenUseCase implements BaseUseCase<void, NoParams> {
  final INotificationRepository _repository;

  SyncFcmTokenUseCase(this._repository);

  @override
  Future<Either<AppFailure, void>> call(NoParams params) async {
    return await _repository.syncFcmToken();
  }
}
