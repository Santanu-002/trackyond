import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/worker/dashboard/domain/repositories/i_worker_dashboard_repository.dart';

class SendMockJobNotificationUseCase implements BaseUseCase<void, NoParams> {
  final IWorkerDashboardRepository _repository;

  SendMockJobNotificationUseCase(this._repository);

  @override
  Future<Either<AppFailure, void>> call(NoParams params) {
    return _repository.sendMockJobNotification();
  }
}
