// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceLogModel _$AttendanceLogModelFromJson(Map<String, dynamic> json) =>
    _AttendanceLogModel(
      logUid: json['logUid'] as String,
      accountUid: json['accountUid'] as String,
      userUid: json['userUid'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      startAt: const DateTimeConverter().fromJson(json['startAt'] as String),
      endAt: const DateTimeNullableConverter().fromJson(
        json['endAt'] as String?,
      ),
      startLocation: json['startLocation'] as String?,
      endLocation: json['endLocation'] as String?,
    );

Map<String, dynamic> _$AttendanceLogModelToJson(_AttendanceLogModel instance) =>
    <String, dynamic>{
      'logUid': instance.logUid,
      'accountUid': instance.accountUid,
      'userUid': instance.userUid,
      'name': instance.name,
      'status': instance.status,
      'startAt': const DateTimeConverter().toJson(instance.startAt),
      'endAt': const DateTimeNullableConverter().toJson(instance.endAt),
      'startLocation': instance.startLocation,
      'endLocation': instance.endLocation,
    };
