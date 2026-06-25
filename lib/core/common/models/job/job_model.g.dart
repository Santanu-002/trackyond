// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobModel _$JobModelFromJson(Map<String, dynamic> json) => _JobModel(
  jobId: json['jobId'] as String,
  jobTitle: json['jobTitle'] as String,
  customerName: json['customerName'] as String,
  customerPhone: json['customerPhone'] as String,
  customerAddress: json['customerAddress'] as String?,
  workerProfileUid: json['workerProfileUid'] as String,
  workerName: json['workerName'] as String?,
  workerImage: json['workerImage'] as String?,
  createdByProfileUid: json['createdByProfileUid'] as String?,
  createdByName: json['createdByName'] as String?,
  status: _jobStatusFromJson(json['status'] as String),
  requirePhotoOnStart: json['requirePhotoOnStart'] as bool,
  requirePhotoOnComplete: json['requirePhotoOnComplete'] as bool,
  captureLocation: json['captureLocation'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  assignedAt: json['assignedAt'] == null
      ? null
      : DateTime.parse(json['assignedAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  allowedActions: (json['allowedActions'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  lastMessage: json['lastMessage'] as String?,
  lastMessageAt: json['lastMessageAt'] == null
      ? null
      : DateTime.parse(json['lastMessageAt'] as String),
  lastActivityType: json['lastActivityType'] as String?,
  lastActivityMessage: json['lastActivityMessage'] as String?,
  lastActivityAt: json['lastActivityAt'] == null
      ? null
      : DateTime.parse(json['lastActivityAt'] as String),
);

Map<String, dynamic> _$JobModelToJson(_JobModel instance) => <String, dynamic>{
  'jobId': instance.jobId,
  'jobTitle': instance.jobTitle,
  'customerName': instance.customerName,
  'customerPhone': instance.customerPhone,
  'customerAddress': instance.customerAddress,
  'workerProfileUid': instance.workerProfileUid,
  'workerName': instance.workerName,
  'workerImage': instance.workerImage,
  'createdByProfileUid': instance.createdByProfileUid,
  'createdByName': instance.createdByName,
  'status': _jobStatusToJson(instance.status),
  'requirePhotoOnStart': instance.requirePhotoOnStart,
  'requirePhotoOnComplete': instance.requirePhotoOnComplete,
  'captureLocation': instance.captureLocation,
  'createdAt': instance.createdAt.toIso8601String(),
  'assignedAt': instance.assignedAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'allowedActions': instance.allowedActions,
  'lastMessage': instance.lastMessage,
  'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
  'lastActivityType': instance.lastActivityType,
  'lastActivityMessage': instance.lastActivityMessage,
  'lastActivityAt': instance.lastActivityAt?.toIso8601String(),
};
