import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/settings/domain/repositories/i_owner_settings_repository.dart';

class SaveOwnerDashboardStatsFilterUseCase
    implements BaseUseCase<void, String> {
  final IOwnerSettingsRepository _repository;

  SaveOwnerDashboardStatsFilterUseCase(this._repository);

  @override
  Future<Either<AppFailure, void>> call(String params) {
    return _repository.saveDashboardStatsFilter(params);
  }
}
