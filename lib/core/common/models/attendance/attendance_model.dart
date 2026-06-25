import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/entities/attendance/attendance_entity.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/utils/json_converters.dart';

part 'attendance_model.freezed.dart';
part 'attendance_model.g.dart';

@freezed
sealed class AttendanceModel with _$AttendanceModel implements AttendanceEntity {
  const factory AttendanceModel({
    required int id,
    required String profileUid,
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
    @AttendanceStatusConverter() required AttendanceStatus status,
  }) = _AttendanceModel;

  const AttendanceModel._();

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);

  @override
  List<Object?> get props => [
        id,
        status,
        startAt,
        endAt,
        workHours,
        startAddress,
        endAddress,
      ];

  @override
  bool? get stringify => true;
}
