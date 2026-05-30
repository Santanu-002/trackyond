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
      senderUid: json['senderUid'] as String?,
      content: (json['content'] as List<dynamic>)
          .map(
            (e) =>
                JobChatMessageContentModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      type: json['type'] as String? ?? 'message',
      metadata: json['metadata'] as Map<String, dynamic>?,
      actionPerformed: json['actionPerformed'] as String?,
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
      active: json['active'] as bool? ?? true,
      deleted: json['deleted'] as bool? ?? false,
    );

Map<String, dynamic> _$JobChatMessageModelToJson(
  _JobChatMessageModel instance,
) => <String, dynamic>{
  'uid': instance.uid,
  'localId': instance.localId,
  'jobId': instance.jobId,
  'senderUid': instance.senderUid,
  'content': instance.content,
  'type': instance.type,
  'metadata': instance.metadata,
  'actionPerformed': instance.actionPerformed,
  'createdByAuthorAt': const DateTimeConverter().toJson(
    instance.createdByAuthorAt,
  ),
  'createdAt': const DateTimeNullableConverter().toJson(instance.createdAt),
  'updatedAt': const DateTimeNullableConverter().toJson(instance.updatedAt),
  'seenAt': const DateTimeNullableConverter().toJson(instance.seenAt),
  'deliveredAt': const DateTimeNullableConverter().toJson(instance.deliveredAt),
  'active': instance.active,
  'deleted': instance.deleted,
};
