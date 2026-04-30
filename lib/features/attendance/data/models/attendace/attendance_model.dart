import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/features/attendance/domain/entities/attendance_entity.dart';

part 'attendance_model.freezed.dart';
part 'attendance_model.g.dart';

@freezed
sealed class AttendanceModel with _$AttendanceModel {
  const factory AttendanceModel({
    required int id,
    required String accountUid,
    required String userUid,
    required String companyUid,
    required String status,
    required DateTime startAt,
    DateTime? endAt,
    required double startLatitude,
    required double startLongitude,
    double? endLatitude,
    double? endLongitude,
    double? workHours,
    String? startAddress,
    String? endAddress,
  }) = _AttendanceModel;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);

  const AttendanceModel._();

  AttendanceEntity toEntity() => AttendanceEntity(
        id: id,
        accountUid: accountUid,
        userUid: userUid,
        companyUid: companyUid,
        status: status,
        startAt: startAt,
        endAt: endAt,
        startLatitude: startLatitude,
        startLongitude: startLongitude,
        endLatitude: endLatitude,
        endLongitude: endLongitude,
        workHours: workHours,
        startAddress: startAddress,
        endAddress: endAddress,
      );
}
