import 'package:trackyond/core/common/enums/attendance_status.dart';

class TeamMemberStatus {
  final String accountUid;
  final String userUid;
  final String name;
  final String? designation;
  final String phone;
  final String? image;
  final AttendanceStatus status;
  final DateTime? startAt;
  final String? currentLocation;

  bool get isWorking => status == AttendanceStatus.working;

  TeamMemberStatus({
    required this.accountUid,
    required this.userUid,
    required this.name,
    this.designation,
    required this.phone,
    this.image,
    required this.status,
    this.startAt,
    this.currentLocation,
  });
}
