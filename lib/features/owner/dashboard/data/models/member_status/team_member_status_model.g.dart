// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_member_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamMemberStatusModel _$TeamMemberStatusModelFromJson(
  Map<String, dynamic> json,
) => _TeamMemberStatusModel(
  accountUid: json['accountUid'] as String,
  userUid: json['userUid'] as String? ?? '',
  name: json['name'] as String,
  designation: json['designation'] as String?,
  phone: json['phone'] as String?,
  image: json['image'] as String?,
  status: const AttendanceStatusConverter().fromJson(json['status'] as String?),
  startAt: const DateTimeNullableConverter().fromJson(
    json['startAt'] as String?,
  ),
  currentLocation: json['currentLocation'] as String?,
);

Map<String, dynamic> _$TeamMemberStatusModelToJson(
  _TeamMemberStatusModel instance,
) => <String, dynamic>{
  'accountUid': instance.accountUid,
  'userUid': instance.userUid,
  'name': instance.name,
  'designation': instance.designation,
  'phone': instance.phone,
  'image': instance.image,
  'status': const AttendanceStatusConverter().toJson(instance.status),
  'startAt': const DateTimeNullableConverter().toJson(instance.startAt),
  'currentLocation': instance.currentLocation,
};
