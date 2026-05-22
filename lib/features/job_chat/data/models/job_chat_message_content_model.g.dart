// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_chat_message_content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobChatMessageContentModel _$JobChatMessageContentModelFromJson(
  Map<String, dynamic> json,
) => _JobChatMessageContentModel(
  id: (json['id'] as num).toInt(),
  type: json['type'] as String,
  content: json['content'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
  actionPerformed: json['actionPerformed'] as String?,
);

Map<String, dynamic> _$JobChatMessageContentModelToJson(
  _JobChatMessageContentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'content': instance.content,
  'metadata': instance.metadata,
  'actionPerformed': instance.actionPerformed,
};
