import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/add_team_member/domain/repositories/i_team_repository.dart';

class GetTeamMembersUseCase
    implements BaseUseCase<List<MemberProfile>, NoParams> {
  final ITeamRepository _repository;

  GetTeamMembersUseCase(this._repository);

  @override
  Future<Either<AppFailure, List<MemberProfile>>> call(NoParams params) async {
    return await _repository.getTeamMembers();
  }
}
