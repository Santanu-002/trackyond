import 'package:equatable/equatable.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/attendance_log.dart';

class AttendanceLogsResult extends Equatable {
  final List<AttendanceLog> logs;
  final int totalCount;

  const AttendanceLogsResult({
    required this.logs,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [logs, totalCount];
}
