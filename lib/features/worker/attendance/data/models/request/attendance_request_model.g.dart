// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceRequestModel _$AttendanceRequestModelFromJson(
  Map<String, dynamic> json,
) => _AttendanceRequestModel(
  profileUid: json['profileUid'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  address: json['address'] as String?,
);

Map<String, dynamic> _$AttendanceRequestModelToJson(
  _AttendanceRequestModel instance,
) => <String, dynamic>{
  'profileUid': instance.profileUid,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'address': instance.address,
};
