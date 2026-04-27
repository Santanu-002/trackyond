import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/enums/gender.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/owner/add_team_member/domain/repositories/i_team_repository.dart';

class AddTeamMemberUseCase implements BaseUseCase<MemberProfile, AddTeamMemberParams> {
  final ITeamRepository _repository;

  AddTeamMemberUseCase(this._repository);

  @override
  Future<Either<AppFailure, MemberProfile>> call(AddTeamMemberParams params) async {
    return await _repository.addTeamMember(
      name: params.name,
      phone: params.phone,
      companyUid: params.companyUid,
      designation: params.designation,
      imagePath: params.imagePath,
      gender: params.gender,
    );
  }
}

class AddTeamMemberParams {
  final String name;
  final String phone;
  final String companyUid;
  final String designation;
  final String? imagePath;
  final Gender? gender;

  AddTeamMemberParams({
    required this.name,
    required this.phone,
    required this.companyUid,
    required this.designation,
    this.imagePath,
    this.gender,
  });
}
