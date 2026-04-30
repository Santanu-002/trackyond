import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/owner/add_team_member/domain/repositories/i_team_repository.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/team_status_result.dart';

import 'package:trackyond/features/owner/dashboard/domain/entities/team_status_query_options.dart';

class GetTeamStatusUseCase implements BaseUseCase<TeamStatusResult, GetTeamStatusParams> {
  final ITeamRepository _repository;

  GetTeamStatusUseCase(this._repository);

  @override
  Future<Either<AppFailure, TeamStatusResult>> call(GetTeamStatusParams params) {
    return _repository.getTeamStatus(
      options: params.options,
    );
  }
}

class GetTeamStatusParams {
  final TeamStatusQueryOptions? options;

  GetTeamStatusParams({
    this.options,
  });
}
