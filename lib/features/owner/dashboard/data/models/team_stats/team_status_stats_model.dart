import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/team_status_stats.dart';

part 'team_status_stats_model.freezed.dart';
part 'team_status_stats_model.g.dart';

@freezed
abstract class TeamStatusStatsModel with _$TeamStatusStatsModel {
  const TeamStatusStatsModel._();

  const factory TeamStatusStatsModel({
    required int total,
    required int working,
    required int notStarted,
  }) = _TeamStatusStatsModel;

  factory TeamStatusStatsModel.fromJson(Map<String, dynamic> json) =>
      _$TeamStatusStatsModelFromJson(json);

  TeamStatusStats toEntity() => TeamStatusStats(
        total: total,
        working: working,
        notStarted: notStarted,
      );
}
