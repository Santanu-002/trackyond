// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OwnerDashboardModel _$OwnerDashboardModelFromJson(Map<String, dynamic> json) =>
    _OwnerDashboardModel(
      teamMembersStatus: (json['teamMembersStatus'] as List<dynamic>)
          .map((e) => TeamMemberStatusModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      jobCounts: OwnerDashboardModelStats.fromJson(
        json['jobCounts'] as Map<String, dynamic>,
      ),
      recentJobs: (json['recentJobs'] as List<dynamic>)
          .map((e) => JobModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      unreadNotificationCount:
          (json['unreadNotificationCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$OwnerDashboardModelToJson(
  _OwnerDashboardModel instance,
) => <String, dynamic>{
  'teamMembersStatus': instance.teamMembersStatus,
  'jobCounts': instance.jobCounts,
  'recentJobs': instance.recentJobs,
  'unreadNotificationCount': instance.unreadNotificationCount,
};

_OwnerDashboardModelStats _$OwnerDashboardModelStatsFromJson(
  Map<String, dynamic> json,
) => _OwnerDashboardModelStats(
  todayStats: JobSummaryStatsModel.fromJson(
    json['todayStats'] as Map<String, dynamic>,
  ),
  overallStats: JobSummaryStatsModel.fromJson(
    json['overallStats'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$OwnerDashboardModelStatsToJson(
  _OwnerDashboardModelStats instance,
) => <String, dynamic>{
  'todayStats': instance.todayStats,
  'overallStats': instance.overallStats,
};
