// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_status_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamStatusStatsModel _$TeamStatusStatsModelFromJson(
  Map<String, dynamic> json,
) => _TeamStatusStatsModel(
  total: (json['total'] as num).toInt(),
  working: (json['working'] as num).toInt(),
  notStarted: (json['notStarted'] as num).toInt(),
);

Map<String, dynamic> _$TeamStatusStatsModelToJson(
  _TeamStatusStatsModel instance,
) => <String, dynamic>{
  'total': instance.total,
  'working': instance.working,
  'notStarted': instance.notStarted,
};
