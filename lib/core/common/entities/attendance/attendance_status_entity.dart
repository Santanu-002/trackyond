import 'package:trackyond/core/common/entities/attendance/attendance_entity.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';

class AttendanceStatusEntity {
  final AttendanceStatus status;
  final AttendanceEntity? attendance;

  AttendanceStatusEntity({
    required this.status,
    this.attendance,
  });
}
