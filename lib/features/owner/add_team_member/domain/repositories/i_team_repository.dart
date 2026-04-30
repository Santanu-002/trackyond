import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/company/company_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/enums/gender.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/team_status_query_options.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/team_status_result.dart';


import 'package:trackyond/features/owner/dashboard/domain/entities/attendance_logs_result.dart';

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

  Future<Either<AppFailure, TeamStatusResult>> getTeamStatus({
    TeamStatusQueryOptions? options,
  });

  Future<Either<AppFailure, Unit>> saveOnboardingProgress({
    required bool completed,
  });

  Future<Either<AppFailure, AttendanceLogsResult>> getMemberAttendanceLogs({
    required String uid,
    DateTime? fromDate,
    DateTime? toDate,
    String? status,
    String? search,
    int? limit,
    int? offset,
    String? sortBy,
    String? sortOrder,
  });

  Future<Either<AppFailure, MemberProfile>> editMemberProfile({
    required MemberProfile profile,
  });

  Future<Either<AppFailure, Unit>> markAsExEmployee({
    required String uid,
  });
  Future<Either<AppFailure, String>> exportMemberAttendanceLogs({
    required String uid,
    required String format,
    DateTime? fromDate,
    DateTime? toDate,
    String? status,
    String? search,
  });
}
