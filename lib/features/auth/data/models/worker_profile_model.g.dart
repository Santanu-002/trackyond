// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkerProfileModel _$WorkerProfileModelFromJson(Map<String, dynamic> json) =>
    _WorkerProfileModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      designation: json['designation'] as String,
      gender: json['gender'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$WorkerProfileModelToJson(_WorkerProfileModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'phone': instance.phone,
      'designation': instance.designation,
      'gender': instance.gender,
      'image': instance.image,
    };
