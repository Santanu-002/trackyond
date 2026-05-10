import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/team_status/data/datasources/team_status_datasource.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/status/team_status_entity.dart';
import 'package:trackyond/features/owner/team_status/domain/repositories/i_team_status_repository.dart';

class TeamStatusRepositoryImpl implements ITeamStatusRepository {
  final ITeamStatusDataSource _dataSource;

  TeamStatusRepositoryImpl(this._dataSource);

  @override
  Future<Either<AppFailure, TeamStatusEntity>> getTeamStatus({
    String? statusFilter,
    String? order,
    int? limit,
  }) async {
    final response = await _dataSource.getTeamStatus(
      statusFilter: statusFilter,
      order: order,
      limit: limit,
    );

    return response.when(
      success: (_, _, model) {
        if (model != null) return Right(model.toEntity());
        return Left(ServerFailure('No data received'));
      },
      error: (_, message, _, _) => Left(ServerFailure(message)),
    );
  }
}

