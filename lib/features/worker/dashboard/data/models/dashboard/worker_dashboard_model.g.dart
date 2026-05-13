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
  stats: WorkerDashboardModelStats.fromJson(
    json['stats'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$WorkerDashboardModelToJson(
  _WorkerDashboardModel instance,
) => <String, dynamic>{
  'attendanceStatus': instance.attendanceStatus,
  'recentJobs': instance.recentJobs,
  'stats': instance.stats,
};

_WorkerDashboardModelStats _$WorkerDashboardModelStatsFromJson(
  Map<String, dynamic> json,
) => _WorkerDashboardModelStats(
  today: JobSummaryStatsModel.fromJson(json['today'] as Map<String, dynamic>),
  overall: JobSummaryStatsModel.fromJson(
    json['overall'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$WorkerDashboardModelStatsToJson(
  _WorkerDashboardModelStats instance,
) => <String, dynamic>{'today': instance.today, 'overall': instance.overall};
