import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/worker/dashboard/domain/entities/dashboard/worker_dashboard_data.dart';
import 'package:trackyond/features/worker/dashboard/domain/repositories/i_worker_dashboard_repository.dart';

class GetWorkerDashboardUseCase
    implements BaseUseCase<WorkerDashboardData, NoParams> {
  final IWorkerDashboardRepository _repository;

  GetWorkerDashboardUseCase(this._repository);

  @override
  Future<Either<AppFailure, WorkerDashboardData>> call(NoParams params) {
    return _repository.getDashboardData();
  }
}
