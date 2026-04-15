// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OwnerProfile _$OwnerProfileFromJson(Map<String, dynamic> json) =>
    _OwnerProfile(
      uid: json['uid'] as String,
      phone: json['phone'] as String,
      isNewUser: json['isNewUser'] as bool,
    );

Map<String, dynamic> _$OwnerProfileToJson(_OwnerProfile instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'phone': instance.phone,
      'isNewUser': instance.isNewUser,
    };
