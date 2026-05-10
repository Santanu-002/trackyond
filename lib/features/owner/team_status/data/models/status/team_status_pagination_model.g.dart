// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_status_pagination_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamStatusPaginationModel _$TeamStatusPaginationModelFromJson(
  Map<String, dynamic> json,
) => _TeamStatusPaginationModel(
  limit: (json['limit'] as num).toInt(),
  totalItems: (json['totalItems'] as num).toInt(),
);

Map<String, dynamic> _$TeamStatusPaginationModelToJson(
  _TeamStatusPaginationModel instance,
) => <String, dynamic>{
  'limit': instance.limit,
  'totalItems': instance.totalItems,
};
