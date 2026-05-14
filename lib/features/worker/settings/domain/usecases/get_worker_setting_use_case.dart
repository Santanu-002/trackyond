import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/worker/settings/domain/repositories/i_worker_settings_repository.dart';

class GetWorkerSettingParams {
  final String key;
  final Type type;

  GetWorkerSettingParams({required this.key, required this.type});
}

class GetWorkerSettingUseCase
    implements BaseUseCase<dynamic, GetWorkerSettingParams> {
  final IWorkerSettingsRepository _repository;

  GetWorkerSettingUseCase(this._repository);

  @override
  Future<Either<AppFailure, dynamic>> call(GetWorkerSettingParams params) {
    if (params.type == bool) {
      return _repository.getBool(params.key);
    } else if (params.type == String) {
      return _repository.getString(params.key);
    }
    return Future.value(left(CacheFailure('Unsupported type')));
  }
}
