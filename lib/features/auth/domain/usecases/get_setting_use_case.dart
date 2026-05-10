import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/auth/domain/repositories/i_settings_repository.dart';

class GetSettingParams {
  final String key;
  final Type type;

  GetSettingParams({required this.key, required this.type});
}

class GetSettingUseCase implements BaseUseCase<dynamic, GetSettingParams> {
  final ISettingsRepository _repository;

  GetSettingUseCase(this._repository);

  @override
  Future<Either<AppFailure, dynamic>> call(GetSettingParams params) {
    if (params.type == bool) {
      return _repository.getBool(params.key);
    } else if (params.type == String) {
      return _repository.getString(params.key);
    }
    return Future.value(left(CacheFailure('Unsupported type')));
  }
}
