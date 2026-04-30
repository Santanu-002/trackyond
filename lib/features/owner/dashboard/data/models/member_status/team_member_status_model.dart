import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/common/utils/json_converters.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/team_member_status.dart';

part 'team_member_status_model.freezed.dart';
part 'team_member_status_model.g.dart';

@freezed
sealed class TeamMemberStatusModel with _$TeamMemberStatusModel {
  const factory TeamMemberStatusModel({
    required String accountUid,
    @Default('') String userUid,
    required String name,
    String? designation,
    String? phone,
    String? image,
    @AttendanceStatusConverter() required AttendanceStatus status,
    @DateTimeNullableConverter() DateTime? startAt,
    String? currentLocation,
  }) = _TeamMemberStatusModel;

  const TeamMemberStatusModel._();

  factory TeamMemberStatusModel.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberStatusModelFromJson(json);

  TeamMemberStatus toEntity() => TeamMemberStatus(
    accountUid: accountUid,
    userUid: userUid,
    name: name,
    designation: designation,
    phone: phone ?? '',
    image: image,
    status: status,
    startAt: startAt,
    currentLocation: currentLocation,
  );
}

