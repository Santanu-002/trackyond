// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_filter_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationFilterRequestModel _$NotificationFilterRequestModelFromJson(
  Map<String, dynamic> json,
) => _NotificationFilterRequestModel(
  limit: (json['limit'] as num).toInt(),
  offset: (json['offset'] as num).toInt(),
  isRead: json['is_read'] as bool?,
  isNewestFirst: json['is_newest_first'] as bool,
);

Map<String, dynamic> _$NotificationFilterRequestModelToJson(
  _NotificationFilterRequestModel instance,
) => <String, dynamic>{
  'limit': instance.limit,
  'offset': instance.offset,
  'is_read': instance.isRead,
  'is_newest_first': instance.isNewestFirst,
};
