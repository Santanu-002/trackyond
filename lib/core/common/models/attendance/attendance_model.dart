import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/entities/attendance/attendance_entity.dart';

import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/common/utils/json_converters.dart';

part 'attendance_model.freezed.dart';
part 'attendance_model.g.dart';

@freezed
sealed class AttendanceModel with _$AttendanceModel {
  const factory AttendanceModel({
    required int id,
    required String accountUid,
    required String userUid,
    required String companyUid,
    @DateTimeConverter() required DateTime startAt,
    @DateTimeNullableConverter() DateTime? endAt,
    double? startLatitude,
    double? startLongitude,
    double? endLatitude,
    double? endLongitude,
    double? workHours,
    String? startAddress,
    String? endAddress,
    required String status,
  }) = _AttendanceModel;

  const AttendanceModel._();

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);

  AttendanceEntity toEntity() => AttendanceEntity(
    id: id,
    status: AttendanceStatus.fromString(status),
    startAt: startAt,
    endAt: endAt,
    workHours: workHours,
    startAddress: startAddress,
    endAddress: endAddress,
  );
}
