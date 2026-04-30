// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_status_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamStatusResultModel _$TeamStatusResultModelFromJson(
  Map<String, dynamic> json,
) => _TeamStatusResultModel(
  members: (json['members'] as List<dynamic>)
      .map((e) => TeamMemberStatusModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  stats: TeamStatusStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TeamStatusResultModelToJson(
  _TeamStatusResultModel instance,
) => <String, dynamic>{'members': instance.members, 'stats': instance.stats};
