import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/enums/gender.dart';
import 'package:trackyond/core/exception/app_failures.dart';

abstract class ITeamRepository {
  Future<Either<AppFailure, Unit>> addTeamMember({
    required String name,
    required String phone,
    String? imagePath,
    Gender? gender,
  });

  Future<Either<AppFailure, List<MemberProfile>>> getTeamMembers();

  Future<Either<AppFailure, Unit>> saveOnboardingProgress({
    required bool completed,
  });
}
