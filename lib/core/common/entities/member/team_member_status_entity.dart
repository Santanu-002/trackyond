import 'package:trackyond/core/common/entities/attendance/attendance_entity.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';

class TeamMemberStatusEntity {
  final MemberProfile profile;
  final AttendanceEntity? todayAttendance;

  const TeamMemberStatusEntity({
    required this.profile,
    this.todayAttendance,
  });

  bool get isWorking => todayAttendance?.status == AttendanceStatus.working;

  AttendanceStatus get status =>
      todayAttendance?.status ?? AttendanceStatus.notStarted;

  DateTime? get startAt => todayAttendance?.startAt;
}
