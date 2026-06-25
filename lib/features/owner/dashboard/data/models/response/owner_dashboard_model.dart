import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/models/job/job_model.dart';
import 'package:trackyond/core/common/models/job_summary/job_summary_stats_model.dart';
import 'package:trackyond/core/common/models/member/team_member_status_model.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/owner_dashboard_data.dart';

part 'owner_dashboard_model.freezed.dart';
part 'owner_dashboard_model.g.dart';

@freezed
sealed class OwnerDashboardModel with _$OwnerDashboardModel implements OwnerDashboardData {
  const factory OwnerDashboardModel({
    required List<TeamMemberStatusModel> teamMembersStatus,
    required OwnerDashboardModelStats jobCounts,
    required List<JobModel> recentJobs,
    @Default(0) int unreadNotificationCount,
  }) = _OwnerDashboardModel;

  const OwnerDashboardModel._();

  factory OwnerDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerDashboardModelFromJson(json);

  @override
  List<Object?> get props => [teamMembersStatus, jobCounts, recentJobs, unreadNotificationCount];

  @override
  bool? get stringify => true;
}

@freezed
sealed class OwnerDashboardModelStats with _$OwnerDashboardModelStats implements JobCountsEntity {
  const factory OwnerDashboardModelStats({
    required JobSummaryStatsModel todayStats,
    required JobSummaryStatsModel overallStats,
  }) = _OwnerDashboardModelStats;

  const OwnerDashboardModelStats._();

  factory OwnerDashboardModelStats.fromJson(Map<String, dynamic> json) =>
      _$OwnerDashboardModelStatsFromJson(json);

  @override
  List<Object?> get props => [todayStats, overallStats];

  @override
  bool? get stringify => true;
}
