import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/company/company_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/setup_company/domain/entities/setup_company_result_entity.dart';

abstract class ICompanyRepository {
  Future<Either<AppFailure, SetupCompanyResultEntity>> setupCompany({
    required String companyName,
    required String ownerName,
    required String phone,
    required int teamSize,
  });

  /// Updates the user's details (isNewUser flag and profile).
  Future<Either<AppFailure, Unit>> updateUserDetails({
    required MemberProfile profile,
    required bool isNewUser,
  });

  /// Persists company details globally.
  Future<Either<AppFailure, Unit>> saveCompany({
    required CompanyEntity company,
    });
}
