// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_chat_message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobChatMessageModel _$JobChatMessageModelFromJson(
  Map<String, dynamic> json,
) => _JobChatMessageModel(
  uid: JobChatMessageModel._readUid(json, 'uid') as String,
  serverUid: JobChatMessageModel._readServerUid(json, 'serverUid') as String?,
  jobId: json['jobId'] as String,
  senderUid: json['senderUid'] as String?,
  content: (json['content'] as List<dynamic>)
      .map(
        (e) => JobChatMessageContentModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
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
  createdAt: const DateTimeNullableConverter().fromJson(
    json['createdAt'] as String?,
  ),
  updatedAt: const DateTimeNullableConverter().fromJson(
    json['updatedAt'] as String?,
  ),
  seenAt: const DateTimeNullableConverter().fromJson(json['seenAt'] as String?),
  deliveredAt: const DateTimeNullableConverter().fromJson(
    json['deliveredAt'] as String?,
  ),
  active: json['active'] as bool? ?? true,
  deleted: json['deleted'] as bool? ?? false,
  deletedByUid: json['deletedByUid'] as String?,
  deletedByUserType: json['deletedByUserType'] as String?,
  deletedFor:
      (json['deletedFor'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  deletedAt: const DateTimeNullableConverter().fromJson(
    json['deletedAt'] as String?,
  ),
  deletedByUserAt: const DateTimeNullableConverter().fromJson(
    json['deletedByUserAt'] as String?,
  ),
);

Map<String, dynamic> _$JobChatMessageModelToJson(
  _JobChatMessageModel instance,
) => <String, dynamic>{
  'serverUid': instance.serverUid,
  'jobId': instance.jobId,
  'senderUid': instance.senderUid,
  'content': instance.content.map((e) => e.toJson()).toList(),
  'type': instance.type.toJson(),
  'metadata': instance.metadata,
  'actionPerformed': instance.actionPerformed,
  'createdByAuthorAt': const DateTimeConverter().toJson(
    instance.createdByAuthorAt,
  ),
  'deletedByUid': instance.deletedByUid,
  'deletedByUserType': instance.deletedByUserType,
  'deletedFor': instance.deletedFor,
  'deletedAt': const DateTimeNullableConverter().toJson(instance.deletedAt),
  'deletedByUserAt': const DateTimeNullableConverter().toJson(
    instance.deletedByUserAt,
  ),
};

const _$JobChatMessageTypeEnumMap = {
  JobChatMessageType.message: 'message',
  JobChatMessageType.activity: 'activity',
};
