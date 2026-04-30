import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/owner/add_team_member/domain/repositories/i_team_repository.dart';

class EditMemberProfileUseCaseParams {
  final MemberProfile profile;

  EditMemberProfileUseCaseParams({required this.profile});
}

class EditMemberProfileUseCase
    implements BaseUseCase<MemberProfile, EditMemberProfileUseCaseParams> {
  final ITeamRepository repository;

  EditMemberProfileUseCase(this.repository);

  @override
  Future<Either<AppFailure, MemberProfile>> call(
      EditMemberProfileUseCaseParams params) async {
    return await repository.editMemberProfile(profile: params.profile);
  }
}
