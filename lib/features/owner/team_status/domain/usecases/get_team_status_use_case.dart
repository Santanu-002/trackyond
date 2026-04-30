import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/team_status_entity.dart';
import 'package:trackyond/features/owner/team_status/domain/repositories/i_team_status_repository.dart';

class GetTeamStatusUseCase implements BaseUseCase<TeamStatusEntity, GetTeamStatusParams> {
  final ITeamStatusRepository _repository;

  GetTeamStatusUseCase(this._repository);

  @override
  Future<Either<AppFailure, TeamStatusEntity>> call(GetTeamStatusParams params) async {
    return await _repository.getTeamStatus(
      statusFilter: params.statusFilter,
      order: params.order,
      limit: params.limit,
    );
  }
}

class GetTeamStatusParams {
  final String? statusFilter;
  final String? order;
  final int? limit;

  GetTeamStatusParams({this.statusFilter, this.order, this.limit = 50});
}
