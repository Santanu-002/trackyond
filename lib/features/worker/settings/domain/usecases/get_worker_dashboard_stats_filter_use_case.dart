import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/worker/settings/domain/repositories/i_worker_settings_repository.dart';

class GetWorkerDashboardStatsFilterUseCase
    implements BaseUseCase<String?, NoParams> {
  final IWorkerSettingsRepository _repository;

  GetWorkerDashboardStatsFilterUseCase(this._repository);

  @override
  Future<Either<AppFailure, String?>> call(NoParams params) {
    return _repository.getDashboardStatsFilter();
  }
}
