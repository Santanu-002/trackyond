import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/company/company_entity.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/owner/add_team_member/domain/repositories/i_team_repository.dart';

class GetCompanyUseCase implements BaseUseCase<CompanyEntity, NoParams> {
  final ITeamRepository _repository;

  GetCompanyUseCase(this._repository);

  @override
  Future<Either<AppFailure, CompanyEntity>> call(NoParams params) async {
    return await _repository.getCompany();
  }
}
