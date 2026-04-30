import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/owner/add_team_member/domain/repositories/i_team_repository.dart';

class ExportMemberAttendanceLogsUseCaseParams {
  final String uid;
  final String format; // 'csv' or 'pdf'
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? status;
  final String? search;

  ExportMemberAttendanceLogsUseCaseParams({
    required this.uid,
    required this.format,
    this.fromDate,
    this.toDate,
    this.status,
    this.search,
  });
}

class ExportMemberAttendanceLogsUseCase
    implements BaseUseCase<String, ExportMemberAttendanceLogsUseCaseParams> {
  final ITeamRepository repository;

  ExportMemberAttendanceLogsUseCase(this.repository);

  @override
  Future<Either<AppFailure, String>> call(
      ExportMemberAttendanceLogsUseCaseParams params) async {
    return await repository.exportMemberAttendanceLogs(
      uid: params.uid,
      format: params.format,
      fromDate: params.fromDate,
      toDate: params.toDate,
      status: params.status,
      search: params.search,
    );
  }
}
