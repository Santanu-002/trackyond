import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/settings/domain/repositories/i_owner_settings_repository.dart';

class SaveOwnerSettingParams {
  final String key;
  final dynamic value;

  SaveOwnerSettingParams({required this.key, required this.value});
}

class SaveOwnerSettingUseCase
    implements BaseUseCase<Unit, SaveOwnerSettingParams> {
  final IOwnerSettingsRepository _repository;

  SaveOwnerSettingUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> call(SaveOwnerSettingParams params) {
    if (params.value is bool) {
      return _repository.saveBool(params.key, params.value as bool);
    } else if (params.value is String) {
      return _repository.saveString(params.key, params.value as String);
    }
    return Future.value(left(CacheFailure('Unsupported type')));
  }
}
