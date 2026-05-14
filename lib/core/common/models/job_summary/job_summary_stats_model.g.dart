// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_summary_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobSummaryStatsModel _$JobSummaryStatsModelFromJson(
  Map<String, dynamic> json,
) => _JobSummaryStatsModel(
  pending: (json['pending'] as num?)?.toInt() ?? 0,
  inProgress: (json['inProgress'] as num?)?.toInt() ?? 0,
  completed: (json['completed'] as num?)?.toInt() ?? 0,
  cancelled: (json['cancelled'] as num?)?.toInt() ?? 0,
  completedToday: (json['completedToday'] as num?)?.toInt() ?? 0,
  totalAssigned: (json['totalAssigned'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$JobSummaryStatsModelToJson(
  _JobSummaryStatsModel instance,
) => <String, dynamic>{
  'pending': instance.pending,
  'inProgress': instance.inProgress,
  'completed': instance.completed,
  'cancelled': instance.cancelled,
  'completedToday': instance.completedToday,
  'totalAssigned': instance.totalAssigned,
};
