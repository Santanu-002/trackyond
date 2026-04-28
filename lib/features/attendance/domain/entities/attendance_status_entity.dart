import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/features/attendance/domain/entities/attendance_entity.dart';

class AttendanceStatusEntity {
  final AttendanceStatus status;
  final AttendanceEntity? attendance;

  AttendanceStatusEntity({
    required this.status,
    this.attendance,
  });
}
