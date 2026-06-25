import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/services/settings/settings_pref_service.dart';
import 'package:trackyond/features/auth/domain/repositories/i_settings_repository.dart';
import 'package:trackyond/core/exception/app_failures.dart';

class SettingsRepositoryImpl implements ISettingsRepository {
  final SettingsPrefService _prefService;

  SettingsRepositoryImpl(this._prefService);

  @override
  Future<Either<AppFailure, bool?>> getBool(String key) async {
    try {
      return right(_prefService.getBool(key));
    } catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, String?>> getString(String key) async {
    try {
      return right(_prefService.getString(key));
    } catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> saveBool(String key, bool value) async {
    try {
      await _prefService.setBool(key, value);
      return right(unit);
    } catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> saveString(String key, String value) async {
    try {
      await _prefService.setString(key, value);
      return right(unit);
    } catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }
}

class OwnerSettingsRepositoryImpl extends SettingsRepositoryImpl implements IOwnerSettingsRepository {
  OwnerSettingsRepositoryImpl(super.prefService);
}

class WorkerSettingsRepositoryImpl extends SettingsRepositoryImpl implements IWorkerSettingsRepository {
  WorkerSettingsRepositoryImpl(super.prefService);
}
