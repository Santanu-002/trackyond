import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/company/company_entity.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/add_team_member/domain/repositories/i_team_repository.dart';

/// Fetches company info for the Add Team Member flow.
/// Checks [UserService] first; falls back to a network call if not found.
class GetTeamCompanyUseCase implements BaseUseCase<CompanyEntity, NoParams> {
  final ITeamRepository _repository;

  GetTeamCompanyUseCase(this._repository);

  @override
  Future<Either<AppFailure, CompanyEntity>> call(NoParams params) async {
    return await _repository.getCompany();
  }
}
