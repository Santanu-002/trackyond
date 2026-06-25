import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/services/settings/settings_pref_service.dart';
import 'package:trackyond/features/worker/settings/domain/repositories/i_worker_settings_repository.dart';

class WorkerSettingsRepositoryImpl implements IWorkerSettingsRepository {
  final SettingsPrefService _prefService;

  WorkerSettingsRepositoryImpl(this._prefService);

  static final _keys = _WorkerSettingsKeys();

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

  @override
  Future<Either<AppFailure, String?>> getDashboardStatsFilter() {
    return getString(_keys.dashboardStatsFilter);
  }

  @override
  Future<Either<AppFailure, Unit>> saveDashboardStatsFilter(String value) {
    return saveString(_keys.dashboardStatsFilter, value);
  }
}

class _WorkerSettingsKeys {
  final dashboardStatsFilter = 'worker_dashboard_stats_filter';
}
