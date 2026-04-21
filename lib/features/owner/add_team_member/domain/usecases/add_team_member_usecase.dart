import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/enums/gender.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/owner/add_team_member/domain/repositories/i_team_repository.dart';

class AddTeamMemberUseCase implements BaseUseCase<Unit, AddTeamMemberParams> {
  final ITeamRepository _repository;

  AddTeamMemberUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> call(AddTeamMemberParams params) async {
    return await _repository.addTeamMember(
      name: params.name,
      phone: params.phone,
      imagePath: params.imagePath,
      gender: params.gender,
    );
  }
}

class AddTeamMemberParams {
  final String name;
  final String phone;
  final String? imagePath;
  final Gender? gender;

  AddTeamMemberParams({
    required this.name,
    required this.phone,
    this.imagePath,
    this.gender,
  });
}
