// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SendMessageModel _$SendMessageModelFromJson(Map<String, dynamic> json) =>
    _SendMessageModel(
      localUid: SendMessageModel._readLocalUid(json, 'localUid') as String?,
      jobId: json['jobId'] as String,
      senderUid: json['senderUid'] as String?,
      type:
          $enumDecodeNullable(
            _$JobChatMessageTypeEnumMap,
            json['type'],
            unknownValue: JobChatMessageType.message,
          ) ??
          JobChatMessageType.message,
      metadata: json['metadata'] as Map<String, dynamic>?,
      actionPerformed: json['actionPerformed'] as String?,
      createdByAuthorAt: const DateTimeConverter().fromJson(
        json['createdByAuthorAt'] as String,
      ),
      content: (json['content'] as List<dynamic>)
          .map(
            (e) =>
                JobChatMessageContentModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$SendMessageModelToJson(_SendMessageModel instance) =>
    <String, dynamic>{
      'localUid': instance.localUid,
      'jobId': instance.jobId,
      'senderUid': instance.senderUid,
      'type': instance.type.toJson(),
      'metadata': instance.metadata,
      'actionPerformed': instance.actionPerformed,
      'createdByAuthorAt': const DateTimeConverter().toJson(
        instance.createdByAuthorAt,
      ),
      'content': instance.content.map((e) => e.toJson()).toList(),
    };

const _$JobChatMessageTypeEnumMap = {
  JobChatMessageType.message: 'message',
  JobChatMessageType.activity: 'activity',
};
