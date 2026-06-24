// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QueueResponse _$QueueResponseFromJson(Map<String, dynamic> json) =>
    _QueueResponse(
      action: json['action'] as String,
      success: json['success'] as bool,
      error: json['error'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      requestId: json['requestId'] as String?,
    );

Map<String, dynamic> _$QueueResponseToJson(_QueueResponse instance) =>
    <String, dynamic>{
      'action': instance.action,
      'success': instance.success,
      'error': instance.error,
      'data': instance.data,
      'requestId': instance.requestId,
    };
