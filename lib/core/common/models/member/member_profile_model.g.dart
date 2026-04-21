// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemberProfileModel _$MemberProfileModelFromJson(Map<String, dynamic> json) =>
    _MemberProfileModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      designation: json['designation'] as String,
      gender: json['gender'] as String?,
      image: json['image'] as String?,
      companyUid: json['companyUid'] as String?,
      createdBy: json['createdBy'] as String?,
    );

Map<String, dynamic> _$MemberProfileModelToJson(_MemberProfileModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'phone': instance.phone,
      'designation': instance.designation,
      'gender': instance.gender,
      'image': instance.image,
      'companyUid': instance.companyUid,
      'createdBy': instance.createdBy,
    };
