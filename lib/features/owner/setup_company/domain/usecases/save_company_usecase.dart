import 'package:trackyond/core/common/entities/company/company_entity.dart';
import 'package:trackyond/features/owner/setup_company/domain/repositories/i_company_repository.dart';

class SaveCompanyUseCase {
  final ICompanyRepository _repository;

  SaveCompanyUseCase(this._repository);

  Future<void> execute({
    required CompanyEntity company,
    required String phone,
    required int teamSize,
  }) {
    return _repository.saveCompany(
      company: company,
      phone: phone,
      teamSize: teamSize,
    );
  }
}
