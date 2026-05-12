import 'package:equatable/equatable.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/dashboard_stats.dart';
import 'package:trackyond/core/common/entities/job_entity.dart';
import 'package:trackyond/core/common/entities/member/team_member_status_entity.dart';

class OwnerDashboardData extends Equatable {
  final List<TeamMemberStatusEntity> teamMembersStatus;
  final DashboardStats jobCounts;
  final List<JobEntity> recentJobs;

  const OwnerDashboardData({
    required this.teamMembersStatus,
    required this.jobCounts,
    required this.recentJobs,
  });

  @override
  List<Object?> get props => [teamMembersStatus, jobCounts, recentJobs];
}
