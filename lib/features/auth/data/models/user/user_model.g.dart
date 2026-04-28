// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  uid: json['uid'] as String,
  phone: json['phone'] as String,
  role: UserRole.fromString(json['role']),
  isNewUser: json['isNewUser'] as bool,
  primaryAccountUid: json['primaryAccountUid'] as String?,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'phone': instance.phone,
      'role': _$UserRoleEnumMap[instance.role]!,
      'isNewUser': instance.isNewUser,
      'primaryAccountUid': instance.primaryAccountUid,
    };

const _$UserRoleEnumMap = {UserRole.owner: 'owner', UserRole.worker: 'worker'};
