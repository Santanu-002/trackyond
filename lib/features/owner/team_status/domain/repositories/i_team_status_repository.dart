import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/team_status_entity.dart';

abstract interface class ITeamStatusRepository {
  Future<Either<AppFailure, TeamStatusEntity>> getTeamStatus({
    String? statusFilter,
    String? order,
    int? limit,
  });
}
