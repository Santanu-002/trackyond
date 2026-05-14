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
    required JobSummaryStatsModel jobCounts,
    required List<JobModel> recentJobs,
  }) = _OwnerDashboardModel;

  const OwnerDashboardModel._();

  factory OwnerDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$OwnerDashboardModelFromJson(json);

  OwnerDashboardData toEntity() => OwnerDashboardData(
    teamMembersStatus: teamMembersStatus.map((e) => e.toEntity()).toList(),
    jobCounts: jobCounts.toEntity(),
    recentJobs: recentJobs.map((e) => e.toEntity()).toList(),
  );
}
