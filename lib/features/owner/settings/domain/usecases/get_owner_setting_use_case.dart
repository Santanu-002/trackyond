import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/owner/settings/domain/repositories/i_owner_settings_repository.dart';

class GetOwnerSettingParams {
  final String key;
  final Type type;

  GetOwnerSettingParams({required this.key, required this.type});
}

class GetOwnerSettingUseCase implements BaseUseCase<dynamic, GetOwnerSettingParams> {
  final IOwnerSettingsRepository _repository;

  GetOwnerSettingUseCase(this._repository);

  @override
  Future<Either<AppFailure, dynamic>> call(GetOwnerSettingParams params) {
    if (params.type == bool) {
      return _repository.getBool(params.key);
    } else if (params.type == String) {
      return _repository.getString(params.key);
    }
    return Future.value(left(CacheFailure('Unsupported type')));
  }
}
