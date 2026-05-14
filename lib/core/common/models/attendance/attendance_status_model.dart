import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/entities/attendance/attendance_status_entity.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/common/models/attendance/attendance_model.dart';
import 'package:trackyond/core/utils/json_converters.dart';

part 'attendance_status_model.freezed.dart';
part 'attendance_status_model.g.dart';

@freezed
sealed class AttendanceStatusModel with _$AttendanceStatusModel {
  const factory AttendanceStatusModel({
    @AttendanceStatusConverter() required AttendanceStatus status,
    AttendanceModel? attendance,
  }) = _AttendanceStatusModel;

  const AttendanceStatusModel._();

  factory AttendanceStatusModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceStatusModelFromJson(json);

  AttendanceStatusEntity toEntity() => AttendanceStatusEntity(
    status: status,
    attendance: attendance?.toEntity(),
  );
}
