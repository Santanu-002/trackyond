import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/setup_company/domain/entities/company_entity.dart';

abstract class ICompanyRepository {
  Future<Either<AppFailure, CompanyEntity>> setupCompany({
    required String companyName,
    required String ownerName,
    required String phone,
    required int teamSize,
  });
}
