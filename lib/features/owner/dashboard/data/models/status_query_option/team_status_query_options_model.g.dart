// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_status_query_options_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamStatusQueryOptionsModel _$TeamStatusQueryOptionsModelFromJson(
  Map<String, dynamic> json,
) => _TeamStatusQueryOptionsModel(
  status: const AttendanceStatusNullableConverter().fromJson(
    json['status_filter'] as String?,
  ),
  order: json['order'] as String?,
  limit: (json['limit'] as num?)?.toInt(),
);

Map<String, dynamic> _$TeamStatusQueryOptionsModelToJson(
  _TeamStatusQueryOptionsModel instance,
) => <String, dynamic>{
  'status_filter': ?const AttendanceStatusNullableConverter().toJson(
    instance.status,
  ),
  'order': instance.order,
  'limit': instance.limit,
};
