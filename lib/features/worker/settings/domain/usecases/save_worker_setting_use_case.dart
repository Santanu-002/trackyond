import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/features/worker/settings/domain/repositories/i_worker_settings_repository.dart';

class SaveWorkerSettingParams {
  final String key;
  final dynamic value;

  SaveWorkerSettingParams({required this.key, required this.value});
}

class SaveWorkerSettingUseCase
    implements BaseUseCase<Unit, SaveWorkerSettingParams> {
  final IWorkerSettingsRepository _repository;

  SaveWorkerSettingUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> call(SaveWorkerSettingParams params) {
    if (params.value is bool) {
      return _repository.saveBool(params.key, params.value as bool);
    } else if (params.value is String) {
      return _repository.saveString(params.key, params.value as String);
    }
    return Future.value(left(CacheFailure('Unsupported type')));
  }
}
