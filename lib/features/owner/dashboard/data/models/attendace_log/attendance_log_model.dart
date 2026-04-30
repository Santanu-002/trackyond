import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/utils/json_converters.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/attendance_log.dart';

part 'attendance_log_model.freezed.dart';
part 'attendance_log_model.g.dart';

@freezed
sealed class AttendanceLogModel with _$AttendanceLogModel {
  const factory AttendanceLogModel({
    required String logUid,
    required String accountUid,
    required String userUid,
    required String name,
    required String status,
    @DateTimeConverter() required DateTime startAt,
    @DateTimeNullableConverter() DateTime? endAt,
    String? startLocation,
    String? endLocation,
  }) = _AttendanceLogModel;

  const AttendanceLogModel._();

  factory AttendanceLogModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceLogModelFromJson(json);

  AttendanceLog toEntity() => AttendanceLog(
    logUid: logUid,
    accountUid: accountUid,
    userUid: userUid,
    name: name,
    status: status,
    startAt: startAt,
    endAt: endAt,
    startLocation: startLocation ?? '',
    endLocation: endLocation ?? '',
  );
}
