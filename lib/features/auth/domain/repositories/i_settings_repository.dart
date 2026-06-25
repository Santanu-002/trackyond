import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';

abstract interface class ISettingsRepository {
  Future<Either<AppFailure, Unit>> saveBool(String key, bool value);
  Future<Either<AppFailure, bool?>> getBool(String key);
  Future<Either<AppFailure, Unit>> saveString(String key, String value);
  Future<Either<AppFailure, String?>> getString(String key);
}

abstract interface class IOwnerSettingsRepository implements ISettingsRepository {
  // Add owner specific settings here if any
}

abstract interface class IWorkerSettingsRepository implements ISettingsRepository {
  // Add worker specific settings here if any
}
