import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/services/settings/settings_pref_service.dart';
import 'package:trackyond/features/owner/settings/domain/repositories/i_owner_settings_repository.dart';

class OwnerSettingsRepositoryImpl implements IOwnerSettingsRepository {
  final SettingsPrefService _prefService;

  OwnerSettingsRepositoryImpl(this._prefService);

  static final _keys = _OwnerSettingsKeys();

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
  Future<Either<AppFailure, void>> saveBool(String key, bool value) async {
    try {
      await _prefService.setBool(key, value);
      return right(null);
    } catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, void>> saveString(String key, String value) async {
    try {
      await _prefService.setString(key, value);
      return right(null);
    } catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, String?>> getDashboardStatsFilter() {
    return getString(_keys.dashboardStatsFilter);
  }

  @override
  Future<Either<AppFailure, void>> saveDashboardStatsFilter(String value) {
    return saveString(_keys.dashboardStatsFilter, value);
  }
}

class _OwnerSettingsKeys {
  final dashboardStatsFilter = 'owner_dashboard_stats_filter';
}
