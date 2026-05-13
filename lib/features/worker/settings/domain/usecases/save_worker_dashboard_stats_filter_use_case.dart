import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/worker/settings/domain/repositories/i_worker_settings_repository.dart';

class SaveWorkerDashboardStatsFilterUseCase implements BaseUseCase<void, String> {
  final IWorkerSettingsRepository _repository;

  SaveWorkerDashboardStatsFilterUseCase(this._repository);

  @override
  Future<Either<AppFailure, void>> call(String params) {
    return _repository.saveDashboardStatsFilter(params);
  }
}
