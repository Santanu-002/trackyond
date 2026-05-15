import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/models/job/job_model.dart';
import 'package:trackyond/core/common/models/job_summary/job_summary_stats_model.dart';
import 'package:trackyond/core/common/models/member/team_member_status_model.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/owner_dashboard_data.dart';

part 'owner_dashboard_model.freezed.dart';
part 'owner_dashboard_model.g.dart';

@freezed
sealed class OwnerDashboardModel with _$OwnerDashboardModel {
  const factory OwnerDashboardModel({
    required List<TeamMemberStatusModel> teamMembersStatus,
    required OwnerDashboardModelStats jobCounts,
    required List<JobModel> recentJobs,
    @Default(0) int unreadNotificationCount,
  }) = _OwnerDashboardModel;

  const OwnerDashboardModel._();

  factory OwnerDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerDashboardModelFromJson(json);

  OwnerDashboardData toEntity() => OwnerDashboardData(
    teamMembersStatus: teamMembersStatus.map((e) => e.toEntity()).toList(),
    jobCounts: jobCounts.toEntity(),
    recentJobs: recentJobs.map((e) => e.toEntity()).toList(),
    unreadNotificationCount: unreadNotificationCount,
  );
}

@freezed
sealed class OwnerDashboardModelStats with _$OwnerDashboardModelStats {
  const factory OwnerDashboardModelStats({
    required JobSummaryStatsModel todayStats,
    required JobSummaryStatsModel overallStats,
  }) = _OwnerDashboardModelStats;

  const OwnerDashboardModelStats._();

  factory OwnerDashboardModelStats.fromJson(Map<String, dynamic> json) =>
      _$OwnerDashboardModelStatsFromJson(json);

  JobCountsEntity toEntity() => JobCountsEntity(
    todayStats: todayStats.toEntity(),
    overallStats: overallStats.toEntity(),
  );
}
