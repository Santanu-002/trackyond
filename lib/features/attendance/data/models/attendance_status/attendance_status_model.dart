import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/features/attendance/data/models/attendace/attendance_model.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/features/attendance/domain/entities/attendance_status_entity.dart';

part 'attendance_status_model.freezed.dart';
part 'attendance_status_model.g.dart';

@freezed
sealed class AttendanceStatusModel with _$AttendanceStatusModel {
  const factory AttendanceStatusModel({
    required String status,
    AttendanceModel? attendance,
  }) = _AttendanceStatusModel;

  factory AttendanceStatusModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceStatusModelFromJson(json);

  const AttendanceStatusModel._();

  AttendanceStatusEntity toEntity() => AttendanceStatusEntity(
        status: AttendanceStatus.fromString(status),
        attendance: attendance?.toEntity(),
      );
}
