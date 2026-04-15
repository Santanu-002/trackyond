// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkerProfile _$WorkerProfileFromJson(Map<String, dynamic> json) =>
    _WorkerProfile(
      uid: json['uid'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      designation: json['designation'] as String,
      gender: json['gender'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$WorkerProfileToJson(_WorkerProfile instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'phone': instance.phone,
      'designation': instance.designation,
      'gender': instance.gender,
      'image': instance.image,
    };
