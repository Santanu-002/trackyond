import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/add_team_member/data/datasources/team_remote_data_source.dart';
import 'package:trackyond/features/owner/add_team_member/domain/repositories/i_team_repository.dart';

class TeamRepositoryImpl implements ITeamRepository {
  final TeamRemoteDataSource _remoteDataSource;

  TeamRepositoryImpl({required TeamRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<AppFailure, Unit>> addTeamMember({
    required String name,
    required String phone,
  }) async {
    try {
      final ApiResponse<dynamic> response = await _remoteDataSource.addTeamMember(
        name: name,
        phone: phone,
      );

      return response.when(
        success: (success, message, data) => right(unit),
        error: (success, message, data, statusCode) =>
            left(ServerFailure(message)),
      );
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
