// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobModel _$JobModelFromJson(Map<String, dynamic> json) => _JobModel(
  jobId: json['jobId'] as String,
  title: json['title'] as String,
  customerName: json['customerName'] as String,
  customerPhone: json['customerPhone'] as String,
  customerAddress: json['customerAddress'] as String?,
  workerAccountUid: json['workerAccountUid'] as String?,
  status: json['status'] as String,
  requirePhotoOnStart: json['requirePhotoOnStart'] as bool,
  requirePhotoOnComplete: json['requirePhotoOnComplete'] as bool,
  captureLocation: json['captureLocation'] as bool,
  createdAt: json['createdAt'] as String,
  assignedAt: json['assignedAt'] as String?,
);

Map<String, dynamic> _$JobModelToJson(_JobModel instance) => <String, dynamic>{
  'jobId': instance.jobId,
  'title': instance.title,
  'customerName': instance.customerName,
  'customerPhone': instance.customerPhone,
  'customerAddress': instance.customerAddress,
  'workerAccountUid': instance.workerAccountUid,
  'status': instance.status,
  'requirePhotoOnStart': instance.requirePhotoOnStart,
  'requirePhotoOnComplete': instance.requirePhotoOnComplete,
  'captureLocation': instance.captureLocation,
  'createdAt': instance.createdAt,
  'assignedAt': instance.assignedAt,
};
