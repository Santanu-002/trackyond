import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/models/attendance/attendance_status_model.dart';
import 'package:trackyond/core/common/models/job/job_model.dart';
import 'package:trackyond/core/common/models/job_summary/job_summary_stats_model.dart';
import 'package:trackyond/features/worker/dashboard/domain/entities/dashboard/worker_dashboard_data.dart';

part 'worker_dashboard_model.freezed.dart';
part 'worker_dashboard_model.g.dart';

@freezed
sealed class WorkerDashboardModel with _$WorkerDashboardModel {
  const factory WorkerDashboardModel({
    required AttendanceStatusModel attendanceStatus,
    required List<JobModel> recentJobs,
    required WorkerDashboardModelStats stats,
  }) = _WorkerDashboardModel;

  const WorkerDashboardModel._();

  factory WorkerDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$WorkerDashboardModelFromJson(json);

  WorkerDashboardData toEntity() => WorkerDashboardData(
    attendanceStatus: attendanceStatus.toEntity(),
    recentJobs: recentJobs.map((e) => e.toEntity()).toList(),
    todayStats: stats.today.toEntity(),
    overallStats: stats.overall.toEntity(),
  );
}

@freezed
sealed class WorkerDashboardModelStats with _$WorkerDashboardModelStats {
  const factory WorkerDashboardModelStats({
    required JobSummaryStatsModel today,
    required JobSummaryStatsModel overall,
  }) = _WorkerDashboardModelStats;

  factory WorkerDashboardModelStats.fromJson(Map<String, dynamic> json) =>
      _$WorkerDashboardModelStatsFromJson(json);
}
