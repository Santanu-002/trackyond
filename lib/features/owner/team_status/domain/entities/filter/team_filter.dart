import 'package:trackyond/core/common/enums/attendance_status.dart';

class TeamFilterEntity {
  final String label;
  final AttendanceStatus? status;

  const TeamFilterEntity({required this.label, this.status});
}
