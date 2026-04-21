import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';

abstract class ITeamRepository {
  Future<Either<AppFailure, Unit>> addTeamMember({
    required String name,
    required String phone,
  });
}
