import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/common/models/attendance/attendance_model.dart';
import 'package:trackyond/core/common/models/member/member_profile_model.dart';
import 'package:trackyond/core/common/entities/member/team_member_status_entity.dart';

part 'team_member_status_model.freezed.dart';
part 'team_member_status_model.g.dart';

@freezed
sealed class TeamMemberStatusModel with _$TeamMemberStatusModel implements TeamMemberStatusEntity {
  const factory TeamMemberStatusModel({
    required MemberProfileModel profile,
    AttendanceModel? todayAttendance,
  }) = _TeamMemberStatusModel;

  const TeamMemberStatusModel._();

  factory TeamMemberStatusModel.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberStatusModelFromJson(json);

  @override
  bool get isWorking => todayAttendance?.status == AttendanceStatus.working;

  @override
  AttendanceStatus get status =>
      todayAttendance?.status ?? AttendanceStatus.notStarted;

  @override
  DateTime? get startAt => todayAttendance?.startAt;
}
