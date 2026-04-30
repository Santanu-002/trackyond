import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_request_model.freezed.dart';
part 'attendance_request_model.g.dart';

@freezed
sealed class AttendanceRequestModel with _$AttendanceRequestModel {
  const factory AttendanceRequestModel({
    required String accountUid,
    required double latitude,
    required double longitude,
    String? address,
  }) = _AttendanceRequestModel;

  factory AttendanceRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRequestModelFromJson(json);
}
