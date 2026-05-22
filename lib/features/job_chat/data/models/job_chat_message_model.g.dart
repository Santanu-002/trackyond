// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobChatMessageModel _$JobChatMessageModelFromJson(Map<String, dynamic> json) =>
    _JobChatMessageModel(
      uid: json['uid'] as String,
      localId: json['localId'] as String?,
      jobId: json['jobId'] as String,
      authorType: json['authorType'] as String? ?? 'user',
      createdByUid: json['createdByUid'] as String?,
      createdByProfileUid: json['createdByProfileUid'] as String?,
      senderName: json['senderName'] as String?,
      senderId: json['senderId'] as String?,
      content: (json['content'] as List<dynamic>)
          .map(
            (e) =>
                JobChatMessageContentModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      type: json['type'] as String? ?? 'message',
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdByAuthorAt: const DateTimeConverter().fromJson(
        json['createdByAuthorAt'] as String,
      ),
      createdAt: const DateTimeNullableConverter().fromJson(
        json['createdAt'] as String?,
      ),
      updatedAt: const DateTimeNullableConverter().fromJson(
        json['updatedAt'] as String?,
      ),
      seenAt: const DateTimeNullableConverter().fromJson(
        json['seenAt'] as String?,
      ),
      deliveredAt: const DateTimeNullableConverter().fromJson(
        json['deliveredAt'] as String?,
      ),
      status: json['status'] as String? ?? 'sent',
      isMe: json['isMe'] as bool? ?? false,
      active: json['active'] as bool? ?? true,
      deleted: json['deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$JobChatMessageModelToJson(
  _JobChatMessageModel instance,
) => <String, dynamic>{
  'uid': instance.uid,
  'localId': instance.localId,
  'jobId': instance.jobId,
  'authorType': instance.authorType,
  'createdByUid': instance.createdByUid,
  'createdByProfileUid': instance.createdByProfileUid,
  'senderName': instance.senderName,
  'senderId': instance.senderId,
  'content': instance.content,
  'type': instance.type,
  'metadata': instance.metadata,
  'createdByAuthorAt': const DateTimeConverter().toJson(
    instance.createdByAuthorAt,
  ),
  'createdAt': const DateTimeNullableConverter().toJson(instance.createdAt),
  'updatedAt': const DateTimeNullableConverter().toJson(instance.updatedAt),
  'seenAt': const DateTimeNullableConverter().toJson(instance.seenAt),
  'deliveredAt': const DateTimeNullableConverter().toJson(instance.deliveredAt),
  'status': instance.status,
  'isMe': instance.isMe,
  'active': instance.active,
  'deleted': instance.deleted,
};
