// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamStatusModel _$TeamStatusModelFromJson(Map<String, dynamic> json) =>
    _TeamStatusModel(
      members: (json['members'] as List<dynamic>)
          .map((e) => TeamMemberStatusModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      stats: TeamStatusStatsModel.fromJson(
        json['stats'] as Map<String, dynamic>,
      ),
      options: TeamStatusOptionsModel.fromJson(
        json['options'] as Map<String, dynamic>,
      ),
      pagination: TeamStatusPaginationModel.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$TeamStatusModelToJson(_TeamStatusModel instance) =>
    <String, dynamic>{
      'members': instance.members,
      'stats': instance.stats,
      'options': instance.options,
      'pagination': instance.pagination,
    };
