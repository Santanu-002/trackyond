import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/entities/job/job_summary_stats.dart';

part 'job_summary_stats_model.freezed.dart';
part 'job_summary_stats_model.g.dart';

@freezed
sealed class JobSummaryStatsModel with _$JobSummaryStatsModel {
  const factory JobSummaryStatsModel({
    @Default(0) int pending,
    @Default(0) int inProgress,
    @Default(0) int completed,
    @Default(0) int cancelled,
    @Default(0) int completedToday,
    @Default(0) int totalAssigned,
  }) = _JobSummaryStatsModel;

  const JobSummaryStatsModel._();

  factory JobSummaryStatsModel.fromJson(Map<String, dynamic> json) =>
      _$JobSummaryStatsModelFromJson(json);

  JobSummaryStats toEntity() => JobSummaryStats(
        pending: pending,
        inProgress: inProgress,
        completed: completed,
        cancelled: cancelled,
        completedToday: completedToday,
        totalAssigned: totalAssigned,
      );
}
