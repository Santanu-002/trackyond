// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_chat_message_content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobChatMessageContentModel _$JobChatMessageContentModelFromJson(
  Map<String, dynamic> json,
) => _JobChatMessageContentModel(
  type: $enumDecode(
    _$JobChatMessageContentTypeEnumMap,
    json['type'],
    unknownValue: JobChatMessageContentType.unknown,
  ),
  content: json['content'] as String?,
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$JobChatMessageContentModelToJson(
  _JobChatMessageContentModel instance,
) => <String, dynamic>{
  'type': instance.type.toJson(),
  'content': instance.content,
  'metadata': instance.metadata,
};

const _$JobChatMessageContentTypeEnumMap = {
  JobChatMessageContentType.text: 'text',
  JobChatMessageContentType.image: 'image',
  JobChatMessageContentType.video: 'video',
  JobChatMessageContentType.document: 'document',
  JobChatMessageContentType.pdf: 'pdf',
  JobChatMessageContentType.reply: 'reply',
  JobChatMessageContentType.activity: 'activity',
  JobChatMessageContentType.header: 'header',
  JobChatMessageContentType.unknown: 'unknown',
};
