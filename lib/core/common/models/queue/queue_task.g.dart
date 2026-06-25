// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QueueTask _$QueueTaskFromJson(Map<String, dynamic> json) => _QueueTask(
  id: json['id'] as String,
  type: $enumDecode(_$QueueTaskTypeEnumMap, json['type']),
  priority: const QueuePriorityConverter().fromJson(
    (json['priority'] as num).toInt(),
  ),
  payload: json['payload'],
  status: $enumDecode(_$QueueTaskStatusEnumMap, json['status']),
  createdAt: const MillisecondsDateTimeConverter().fromJson(
    (json['createdAt'] as num).toInt(),
  ),
  updatedAt: const MillisecondsDateTimeConverter().fromJson(
    (json['updatedAt'] as num).toInt(),
  ),
);

Map<String, dynamic> _$QueueTaskToJson(
  _QueueTask instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$QueueTaskTypeEnumMap[instance.type]!,
  'priority': const QueuePriorityConverter().toJson(instance.priority),
  'payload': instance.payload,
  'status': _$QueueTaskStatusEnumMap[instance.status]!,
  'createdAt': const MillisecondsDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': const MillisecondsDateTimeConverter().toJson(instance.updatedAt),
};

const _$QueueTaskTypeEnumMap = {
  QueueTaskType.uploadMedia: 'uploadMedia',
  QueueTaskType.sendMessage: 'sendMessage',
  QueueTaskType.seenMessages: 'seenMessages',
  QueueTaskType.deliveredMessages: 'deliveredMessages',
  QueueTaskType.deleteMessages: 'deleteMessages',
  QueueTaskType.updateJobStatus: 'updateJobStatus',
  QueueTaskType.none: 'none',
};

const _$QueueTaskStatusEnumMap = {
  QueueTaskStatus.pending: 'pending',
  QueueTaskStatus.processing: 'processing',
  QueueTaskStatus.success: 'success',
  QueueTaskStatus.failed: 'failed',
};
