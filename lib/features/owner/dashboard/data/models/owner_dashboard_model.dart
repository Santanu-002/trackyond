import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/dashboard_stats.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/owner_dashboard_data.dart';
import 'package:trackyond/core/common/models/job_model.dart';
import 'package:trackyond/core/common/models/member/team_member_status_model.dart';

part 'owner_dashboard_model.freezed.dart';
part 'owner_dashboard_model.g.dart';

@freezed
sealed class OwnerDashboardModel with _$OwnerDashboardModel {
  const factory OwnerDashboardModel({
    required List<TeamMemberStatusModel> teamMembersStatus,
    required JobCountsModel jobCounts,
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

@freezed
sealed class JobCountsModel with _$JobCountsModel {
  const factory JobCountsModel({
    @Default(0) int pending,
    @Default(0) int inProgress,
    @Default(0) int completed,
    @Default(0) int cancelled,
  }) = _JobCountsModel;

  const JobCountsModel._();

  factory JobCountsModel.fromJson(Map<String, dynamic> json) =>
      _$JobCountsModelFromJson(json);

  DashboardStats toEntity() => DashboardStats(
        pending: pending,
        inProgress: inProgress,
        completed: completed,
        cancelled: cancelled,
      );
}
