import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/add_team_member/domain/repositories/i_team_repository.dart';

class AddTeamMemberUseCase {
  final ITeamRepository _repository;

  AddTeamMemberUseCase(this._repository);

  Future<Either<AppFailure, Unit>> execute({
    required String name,
    required String phone,
  }) {
    return _repository.addTeamMember(
      name: name,
      phone: phone,
    );
  }
}
