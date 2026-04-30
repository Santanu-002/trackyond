import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/owner/add_team_member/domain/repositories/i_team_repository.dart';

class MarkExEmployeeUseCaseParams {
  final String uid;

  MarkExEmployeeUseCaseParams({required this.uid});
}

class MarkExEmployeeUseCase implements BaseUseCase<Unit, MarkExEmployeeUseCaseParams> {
  final ITeamRepository repository;

  MarkExEmployeeUseCase(this.repository);

  @override
  Future<Either<AppFailure, Unit>> call(MarkExEmployeeUseCaseParams params) async {
    return await repository.markAsExEmployee(uid: params.uid);
  }
}
