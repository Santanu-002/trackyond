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
      startAt: const DateTimeConverter().fromJson(json['startAt'] as String),
      endAt: const DateTimeNullableConverter().fromJson(
        json['endAt'] as String?,
      ),
      startLatitude: (json['startLatitude'] as num?)?.toDouble(),
      startLongitude: (json['startLongitude'] as num?)?.toDouble(),
      endLatitude: (json['endLatitude'] as num?)?.toDouble(),
      endLongitude: (json['endLongitude'] as num?)?.toDouble(),
      workHours: (json['workHours'] as num?)?.toDouble(),
      startAddress: json['startAddress'] as String?,
      endAddress: json['endAddress'] as String?,
      status: json['status'] as String,
    );

Map<String, dynamic> _$AttendanceModelToJson(_AttendanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountUid': instance.accountUid,
      'userUid': instance.userUid,
      'companyUid': instance.companyUid,
      'startAt': const DateTimeConverter().toJson(instance.startAt),
      'endAt': const DateTimeNullableConverter().toJson(instance.endAt),
      'startLatitude': instance.startLatitude,
      'startLongitude': instance.startLongitude,
      'endLatitude': instance.endLatitude,
      'endLongitude': instance.endLongitude,
      'workHours': instance.workHours,
      'startAddress': instance.startAddress,
      'endAddress': instance.endAddress,
      'status': instance.status,
    };
