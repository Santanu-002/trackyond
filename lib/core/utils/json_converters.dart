import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';

/// Converter for [DateTime] to/from ISO 8601 strings.
/// Ensures [toLocal] on parse and [toUtc] on serialize.
class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json).toLocal();

  @override
  String toJson(DateTime object) => object.toUtc().toIso8601String();
}

/// Nullable version of [DateTimeConverter].
class DateTimeNullableConverter implements JsonConverter<DateTime?, String?> {
  const DateTimeNullableConverter();

  @override
  DateTime? fromJson(String? json) =>
      json == null ? null : DateTime.parse(json).toLocal();

  @override
  String? toJson(DateTime? object) => object?.toUtc().toIso8601String();
}

/// Converter for [AttendanceStatus] to/from string values.
class AttendanceStatusConverter
    implements JsonConverter<AttendanceStatus, String?> {
  const AttendanceStatusConverter();

  @override
  AttendanceStatus fromJson(String? json) => AttendanceStatus.fromString(json);

  @override
  String? toJson(AttendanceStatus object) => object.value;
}

/// Nullable version of [AttendanceStatusConverter].
class AttendanceStatusNullableConverter
    implements JsonConverter<AttendanceStatus?, String?> {
  const AttendanceStatusNullableConverter();

  @override
  AttendanceStatus? fromJson(String? json) =>
      json == null ? null : AttendanceStatus.fromString(json);

  @override
  String? toJson(AttendanceStatus? object) => object?.value;
}


