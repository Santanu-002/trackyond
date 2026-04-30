import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/owner/add_team_member/domain/repositories/i_team_repository.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/attendance_logs_result.dart';

class GetMemberAttendanceLogsUseCaseParams {
  final String uid;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? status;
  final String? search;
  final int? limit;
  final int? offset;
  final String? sortBy;
  final String? sortOrder;

  GetMemberAttendanceLogsUseCaseParams({
    required this.uid,
    this.fromDate,
    this.toDate,
    this.status,
    this.search,
    this.limit,
    this.offset,
    this.sortBy,
    this.sortOrder,
  });
}

class GetMemberAttendanceLogsUseCase
    implements BaseUseCase<AttendanceLogsResult, GetMemberAttendanceLogsUseCaseParams> {
  final ITeamRepository repository;

  GetMemberAttendanceLogsUseCase(this.repository);

  @override
  Future<Either<AppFailure, AttendanceLogsResult>> call(
      GetMemberAttendanceLogsUseCaseParams params) async {
    return await repository.getMemberAttendanceLogs(
      uid: params.uid,
      fromDate: params.fromDate,
      toDate: params.toDate,
      status: params.status,
      search: params.search,
      limit: params.limit,
      offset: params.offset,
      sortBy: params.sortBy,
      sortOrder: params.sortOrder,
    );
  }
}
