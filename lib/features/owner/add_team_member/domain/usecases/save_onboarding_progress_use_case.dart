import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/owner/add_team_member/domain/repositories/i_team_repository.dart';

class SaveOnboardingProgressUseCase implements BaseUseCase<Unit, SaveOnboardingProgressParams> {
  final ITeamRepository _repository;

  SaveOnboardingProgressUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> call(SaveOnboardingProgressParams params) async {
    return await _repository.saveOnboardingProgress(completed: params.completed);
  }
}

class SaveOnboardingProgressParams {
  final bool completed;

  SaveOnboardingProgressParams({required this.completed});
}
