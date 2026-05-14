import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/notification/domain/repositories/i_notification_repository.dart';

class DeleteFcmTokenUseCase implements BaseUseCase<void, NoParams> {
  final INotificationRepository _repository;

  DeleteFcmTokenUseCase(this._repository);

  @override
  Future<Either<AppFailure, void>> call(NoParams params) async {
    return await _repository.deleteFcmToken();
  }
}
