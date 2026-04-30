import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/company/company_entity.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/auth/domain/repositories/i_auth_repository.dart';

class GetCompanyUseCase implements BaseUseCase<CompanyEntity?, NoParams> {
  final IAuthRepository _repository;

  GetCompanyUseCase(this._repository);

  @override
  Future<Either<AppFailure, CompanyEntity?>> call(NoParams params) async {
    return await _repository.getCompany();
  }
}
