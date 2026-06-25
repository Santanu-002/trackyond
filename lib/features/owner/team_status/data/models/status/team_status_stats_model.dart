import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/status/team_status_stats_entity.dart';

part 'team_status_stats_model.freezed.dart';
part 'team_status_stats_model.g.dart';

@freezed
sealed class TeamStatusStatsModel with _$TeamStatusStatsModel implements TeamStatusStatsEntity {
  const factory TeamStatusStatsModel({
    required int total,
    required int working,
    required int notStarted,
  }) = _TeamStatusStatsModel;

  const TeamStatusStatsModel._();

  factory TeamStatusStatsModel.fromJson(Map<String, dynamic> json) =>
      _$TeamStatusStatsModelFromJson(json);
}

