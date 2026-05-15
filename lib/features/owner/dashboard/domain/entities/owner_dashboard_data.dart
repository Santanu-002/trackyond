import 'package:equatable/equatable.dart';
import 'package:trackyond/core/common/entities/job/job_summary_stats.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/entities/member/team_member_status_entity.dart';

class OwnerDashboardData extends Equatable {
  final List<TeamMemberStatusEntity> teamMembersStatus;
  final JobCountsEntity jobCounts;
  final List<JobEntity> recentJobs;
  final int unreadNotificationCount;

  const OwnerDashboardData({
    required this.teamMembersStatus,
    required this.jobCounts,
    required this.recentJobs,
    this.unreadNotificationCount = 0,
  });

  @override
  List<Object?> get props => [
    teamMembersStatus,
    jobCounts,
    recentJobs,
    unreadNotificationCount,
  ];
}

class JobCountsEntity extends Equatable {
  final JobSummaryStats todayStats;
  final JobSummaryStats overallStats;

  const JobCountsEntity({
    required this.todayStats,
    required this.overallStats,
  });

  @override
  List<Object?> get props => [todayStats, overallStats];
}
