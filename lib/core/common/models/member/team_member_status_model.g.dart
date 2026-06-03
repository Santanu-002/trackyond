// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_member_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamMemberStatusModel _$TeamMemberStatusModelFromJson(
  Map<String, dynamic> json,
) => _TeamMemberStatusModel(
  profile: MemberProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
  todayAttendance: json['todayAttendance'] == null
      ? null
      : AttendanceModel.fromJson(
          json['todayAttendance'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$TeamMemberStatusModelToJson(
  _TeamMemberStatusModel instance,
) => <String, dynamic>{
  'profile': instance.profile.toJson(),
  'todayAttendance': instance.todayAttendance?.toJson(),
};
