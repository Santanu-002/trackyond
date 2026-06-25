import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/models/attendance/attendance_status_model.dart';
import 'package:trackyond/core/common/models/job/job_model.dart';
import 'package:trackyond/core/common/models/job_summary/job_summary_stats_model.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/owner_dashboard_data.dart';
import 'package:trackyond/features/worker/dashboard/domain/entities/dashboard/worker_dashboard_data.dart';

part 'worker_dashboard_model.freezed.dart';
part 'worker_dashboard_model.g.dart';

@freezed
sealed class WorkerDashboardModel with _$WorkerDashboardModel implements WorkerDashboardData {
  const factory WorkerDashboardModel({
    required AttendanceStatusModel attendanceStatus,
    required List<JobModel> recentJobs,
    required WorkerDashboardModelStats jobCounts,
    @Default(0) int unreadNotificationCount,
  }) = _WorkerDashboardModel;

  const WorkerDashboardModel._();

  factory WorkerDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$WorkerDashboardModelFromJson(json);

  @override
  List<Object?> get props => [attendanceStatus, recentJobs, jobCounts, unreadNotificationCount];

  @override
  bool? get stringify => true;
}

@freezed
sealed class WorkerDashboardModelStats with _$WorkerDashboardModelStats implements JobCountsEntity {
  const factory WorkerDashboardModelStats({
    required JobSummaryStatsModel todayStats,
    required JobSummaryStatsModel overallStats,
  }) = _WorkerDashboardModelStats;

  const WorkerDashboardModelStats._();

  factory WorkerDashboardModelStats.fromJson(Map<String, dynamic> json) =>
      _$WorkerDashboardModelStatsFromJson(json);

  @override
  List<Object?> get props => [todayStats, overallStats];

  @override
  bool? get stringify => true;
}
