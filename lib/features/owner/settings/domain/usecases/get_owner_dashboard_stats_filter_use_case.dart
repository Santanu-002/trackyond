import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/settings/domain/repositories/i_owner_settings_repository.dart';

class GetOwnerDashboardStatsFilterUseCase
    implements BaseUseCase<String?, NoParams> {
  final IOwnerSettingsRepository _repository;

  GetOwnerDashboardStatsFilterUseCase(this._repository);

  @override
  Future<Either<AppFailure, String?>> call(NoParams params) {
    return _repository.getDashboardStatsFilter();
  }
}
