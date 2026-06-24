// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enqueue_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EnqueueTask _$EnqueueTaskFromJson(Map<String, dynamic> json) => _EnqueueTask(
  action: json['action'] as String,
  data: json['data'] as Map<String, dynamic>,
  requestId: json['requestId'] as String,
);

Map<String, dynamic> _$EnqueueTaskToJson(_EnqueueTask instance) =>
    <String, dynamic>{
      'action': instance.action,
      'data': instance.data,
      'requestId': instance.requestId,
    };
