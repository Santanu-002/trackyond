import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/setup_company/domain/entities/setup_company_result_entity.dart';
import 'package:trackyond/features/owner/setup_company/domain/repositories/i_company_repository.dart';

class SetupCompanyUseCase
    implements BaseUseCase<SetupCompanyResultEntity, SetupCompanyParams> {
  final ICompanyRepository _repository;

  SetupCompanyUseCase(this._repository);

  @override
  Future<Either<AppFailure, SetupCompanyResultEntity>> call(
    SetupCompanyParams params,
  ) async {
    return await _repository.setupCompany(
      companyName: params.companyName,
      ownerName: params.ownerName,
      ownerUid: params.ownerUid,
      phone: params.phone,
      teamSize: params.teamSize,
    );
  }
}

class SetupCompanyParams {
  final String companyName;
  final String ownerName;
  final String ownerUid;
  final String phone;
  final int teamSize;

  SetupCompanyParams({
    required this.companyName,
    required this.ownerName,
    required this.ownerUid,
    required this.phone,
    required this.teamSize,
  });
}
