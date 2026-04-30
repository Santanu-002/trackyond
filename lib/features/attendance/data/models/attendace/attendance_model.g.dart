// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceModel _$AttendanceModelFromJson(Map<String, dynamic> json) =>
    _AttendanceModel(
      id: (json['id'] as num).toInt(),
      accountUid: json['accountUid'] as String,
      userUid: json['userUid'] as String,
      companyUid: json['companyUid'] as String,
      status: json['status'] as String,
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: json['endAt'] == null
          ? null
          : DateTime.parse(json['endAt'] as String),
      startLatitude: (json['startLatitude'] as num).toDouble(),
      startLongitude: (json['startLongitude'] as num).toDouble(),
      endLatitude: (json['endLatitude'] as num?)?.toDouble(),
      endLongitude: (json['endLongitude'] as num?)?.toDouble(),
      workHours: (json['workHours'] as num?)?.toDouble(),
      startAddress: json['startAddress'] as String?,
      endAddress: json['endAddress'] as String?,
    );

Map<String, dynamic> _$AttendanceModelToJson(_AttendanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountUid': instance.accountUid,
      'userUid': instance.userUid,
      'companyUid': instance.companyUid,
      'status': instance.status,
      'startAt': instance.startAt.toIso8601String(),
      'endAt': instance.endAt?.toIso8601String(),
      'startLatitude': instance.startLatitude,
      'startLongitude': instance.startLongitude,
      'endLatitude': instance.endLatitude,
      'endLongitude': instance.endLongitude,
      'workHours': instance.workHours,
      'startAddress': instance.startAddress,
      'endAddress': instance.endAddress,
    };
