import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';

abstract interface class IWorkerSettingsRepository {
  Future<Either<AppFailure, void>> saveBool(String key, bool value);
  Future<Either<AppFailure, bool?>> getBool(String key);
  Future<Either<AppFailure, void>> saveString(String key, String value);
  Future<Either<AppFailure, String?>> getString(String key);

  Future<Either<AppFailure, String?>> getDashboardStatsFilter();
  Future<Either<AppFailure, void>> saveDashboardStatsFilter(String value);
}
