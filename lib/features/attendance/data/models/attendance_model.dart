import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/features/attendance/domain/entities/attendance_entity.dart';

part 'attendance_model.freezed.dart';
part 'attendance_model.g.dart';

@freezed
sealed class AttendanceModel with _$AttendanceModel {
  const factory AttendanceModel({
    required int id,
    required String status,
    required DateTime startAt,
    DateTime? endAt,
    double? workHours,
    String? address,
  }) = _AttendanceModel;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);

  const AttendanceModel._();

  AttendanceEntity toEntity() => AttendanceEntity(
    id: id,
    status: status,
    startAt: startAt,
    endAt: endAt,
    workHours: workHours,
    address: address,
  );
}
