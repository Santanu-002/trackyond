import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/features/owner/team_status/data/models/team_member_status_model.dart';
import 'package:trackyond/features/owner/team_status/data/models/team_status_stats_model.dart';
import 'package:trackyond/features/owner/team_status/data/models/team_status_options_model.dart';
import 'package:trackyond/features/owner/team_status/data/models/team_status_pagination_model.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/team_status_entity.dart';

part 'team_status_model.freezed.dart';
part 'team_status_model.g.dart';

@freezed
sealed class TeamStatusModel with _$TeamStatusModel {
  const factory TeamStatusModel({
    required List<TeamMemberStatusModel> members,
    required TeamStatusStatsModel stats,
    required TeamStatusOptionsModel options,
    required TeamStatusPaginationModel pagination,
  }) = _TeamStatusModel;

  const TeamStatusModel._();

  factory TeamStatusModel.fromJson(Map<String, dynamic> json) =>
      _$TeamStatusModelFromJson(json);

  TeamStatusEntity toEntity() => TeamStatusEntity(
        members: members.map((e) => e.toEntity()).toList(),
        stats: stats.toEntity(),
        options: options.toEntity(),
        pagination: pagination.toEntity(),
      );
}
