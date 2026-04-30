import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/company/company_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/enums/gender.dart';
import 'package:trackyond/core/exception/app_failures.dart';

abstract interface class ITeamRepository {
  Future<Either<AppFailure, MemberProfile>> addTeamMember({
    required String name,
    required String phone,
    required String companyUid,
    required String designation,
    String? imagePath,
    Gender? gender,
  });

  Future<Either<AppFailure, List<MemberProfile>>> getTeamMembers();

  Future<Either<AppFailure, CompanyEntity>> getCompany();

  Future<Either<AppFailure, Unit>> saveOnboardingProgress({
    required bool completed,
  });
}
