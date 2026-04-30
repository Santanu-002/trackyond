// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceStatusModel _$AttendanceStatusModelFromJson(
  Map<String, dynamic> json,
) => _AttendanceStatusModel(
  status: json['status'] as String,
  attendance: json['attendance'] == null
      ? null
      : AttendanceModel.fromJson(json['attendance'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AttendanceStatusModelToJson(
  _AttendanceStatusModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'attendance': instance.attendance,
};
