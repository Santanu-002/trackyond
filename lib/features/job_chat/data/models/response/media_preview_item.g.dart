// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_preview_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaPreviewItem _$MediaPreviewItemFromJson(Map<String, dynamic> json) =>
    _MediaPreviewItem(
      path: json['path'] as String,
      type: $enumDecode(_$JobChatMessageContentTypeEnumMap, json['type']),
      metadata: ChatMessageMetadataModel.fromJson(
        json['metadata'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$MediaPreviewItemToJson(_MediaPreviewItem instance) =>
    <String, dynamic>{
      'path': instance.path,
      'type': instance.type.toJson(),
      'metadata': instance.metadata.toJson(),
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
