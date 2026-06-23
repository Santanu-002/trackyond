// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_query_options_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageQueryOptionsModel _$MessageQueryOptionsModelFromJson(
  Map<String, dynamic> json,
) => _MessageQueryOptionsModel(
  limit: (json['limit'] as num?)?.toInt(),
  offset: (json['offset'] as num?)?.toInt(),
  searchQuery: json['search'] as String?,
  messageType: json['type'] as String?,
);

Map<String, dynamic> _$MessageQueryOptionsModelToJson(
  _MessageQueryOptionsModel instance,
) => <String, dynamic>{
  'limit': instance.limit,
  'offset': instance.offset,
  'search': instance.searchQuery,
  'type': instance.messageType,
};
