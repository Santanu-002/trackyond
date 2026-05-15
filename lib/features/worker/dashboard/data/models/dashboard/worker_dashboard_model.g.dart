// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkerDashboardModel _$WorkerDashboardModelFromJson(
  Map<String, dynamic> json,
) => _WorkerDashboardModel(
  attendanceStatus: AttendanceStatusModel.fromJson(
    json['attendanceStatus'] as Map<String, dynamic>,
  ),
  recentJobs: (json['recentJobs'] as List<dynamic>)
      .map((e) => JobModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  jobCounts: WorkerDashboardModelStats.fromJson(
    json['jobCounts'] as Map<String, dynamic>,
  ),
  unreadNotificationCount:
      (json['unreadNotificationCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$WorkerDashboardModelToJson(
  _WorkerDashboardModel instance,
) => <String, dynamic>{
  'attendanceStatus': instance.attendanceStatus,
  'recentJobs': instance.recentJobs,
  'jobCounts': instance.jobCounts,
  'unreadNotificationCount': instance.unreadNotificationCount,
};

_WorkerDashboardModelStats _$WorkerDashboardModelStatsFromJson(
  Map<String, dynamic> json,
) => _WorkerDashboardModelStats(
  todayStats: JobSummaryStatsModel.fromJson(
    json['todayStats'] as Map<String, dynamic>,
  ),
  overallStats: JobSummaryStatsModel.fromJson(
    json['overallStats'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$WorkerDashboardModelStatsToJson(
  _WorkerDashboardModelStats instance,
) => <String, dynamic>{
  'todayStats': instance.todayStats,
  'overallStats': instance.overallStats,
};
