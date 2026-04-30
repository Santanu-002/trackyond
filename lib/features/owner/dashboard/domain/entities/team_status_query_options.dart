import 'package:trackyond/core/common/enums/attendance_status.dart';

class TeamStatusQueryOptions {
  final AttendanceStatus? status;
  final String order; // asc | desc
  final int? limit;

  const TeamStatusQueryOptions({
    this.status,
    this.order = 'desc',
    this.limit,
  });
}
