// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    _NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      dataPayload: json['dataPayload'] as String?,
      status: json['status'] as String,
      isRead: json['read'] as bool,
      isSeen: json['seen'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$NotificationModelToJson(_NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'dataPayload': instance.dataPayload,
      'status': instance.status,
      'read': instance.isRead,
      'seen': instance.isSeen,
      'createdAt': instance.createdAt.toIso8601String(),
    };
