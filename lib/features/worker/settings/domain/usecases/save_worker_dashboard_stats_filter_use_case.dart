import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/worker/settings/domain/repositories/i_worker_settings_repository.dart';

class SaveWorkerDashboardStatsFilterUseCase
    implements BaseUseCase<Unit, String> {
  final IWorkerSettingsRepository _repository;

  SaveWorkerDashboardStatsFilterUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> call(String params) {
    return _repository.saveDashboardStatsFilter(params);
  }
}
