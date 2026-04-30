import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/features/owner/dashboard/data/models/member_status/team_member_status_model.dart';
import 'package:trackyond/features/owner/dashboard/data/models/team_stats/team_status_stats_model.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/team_status_result.dart';

part 'team_status_result_model.freezed.dart';
part 'team_status_result_model.g.dart';

@freezed
sealed class TeamStatusResultModel with _$TeamStatusResultModel {
  const factory TeamStatusResultModel({
    required List<TeamMemberStatusModel> members,
    required TeamStatusStatsModel stats,
  }) = _TeamStatusResultModel;

  const TeamStatusResultModel._();

  factory TeamStatusResultModel.fromJson(Map<String, dynamic> json) =>
      _$TeamStatusResultModelFromJson(json);

  TeamStatusResult toEntity() => TeamStatusResult(
        members: members.map((e) => e.toEntity()).toList(),
        stats: stats.toEntity(),
      );
}
