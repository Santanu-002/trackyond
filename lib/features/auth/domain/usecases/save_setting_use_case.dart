import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/auth/domain/repositories/i_settings_repository.dart';

class SaveSettingParams {
  final String key;
  final dynamic value;

  SaveSettingParams({required this.key, required this.value});
}

class SaveSettingUseCase implements BaseUseCase<void, SaveSettingParams> {
  final ISettingsRepository _repository;

  SaveSettingUseCase(this._repository);

  @override
  Future<Either<AppFailure, void>> call(SaveSettingParams params) {
    if (params.value is bool) {
      return _repository.saveBool(params.key, params.value as bool);
    } else if (params.value is String) {
      return _repository.saveString(params.key, params.value as String);
    }
    return Future.value(left(CacheFailure('Unsupported type')));
  }
}
