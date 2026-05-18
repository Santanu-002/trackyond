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
      contents: (json['contents'] as List<dynamic>)
          .map(
            (e) =>
                JobChatMessageContentModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      createdByAuthorAt: DateTime.parse(json['createdByAuthorAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      seenAt: json['seenAt'] == null
          ? null
          : DateTime.parse(json['seenAt'] as String),
      deliveredAt: json['deliveredAt'] == null
          ? null
          : DateTime.parse(json['deliveredAt'] as String),
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
  'contents': instance.contents,
  'createdByAuthorAt': instance.createdByAuthorAt.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'seenAt': instance.seenAt?.toIso8601String(),
  'deliveredAt': instance.deliveredAt?.toIso8601String(),
  'status': instance.status,
  'isMe': instance.isMe,
  'active': instance.active,
  'deleted': instance.deleted,
};
