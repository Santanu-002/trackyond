import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/company/company_entity.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/setup_company/domain/repositories/i_company_repository.dart';

class SaveCompanyUseCase implements BaseUseCase<Unit, SaveCompanyParams> {
  final ICompanyRepository _repository;

  SaveCompanyUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> call(SaveCompanyParams params) async {
    return await _repository.saveCompany(company: params.company);
  }
}

class SaveCompanyParams {
  final CompanyEntity company;

  SaveCompanyParams({required this.company});
}
