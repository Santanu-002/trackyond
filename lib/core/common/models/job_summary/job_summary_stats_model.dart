import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/entities/job/job_summary_stats.dart';

part 'job_summary_stats_model.freezed.dart';
part 'job_summary_stats_model.g.dart';

@freezed
sealed class JobSummaryStatsModel with _$JobSummaryStatsModel implements JobSummaryStats {
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

  @override
  List<Object?> get props => [
        pending,
        inProgress,
        completed,
        cancelled,
        completedToday,
        totalAssigned,
      ];

  @override
  bool? get stringify => true;

  @override
  JobSummaryStats copyWithEntity({
    int? pending,
    int? inProgress,
    int? completed,
    int? cancelled,
    int? completedToday,
    int? totalAssigned,
  }) {
    return copyWith(
      pending: pending ?? this.pending,
      inProgress: inProgress ?? this.inProgress,
      completed: completed ?? this.completed,
      cancelled: cancelled ?? this.cancelled,
      completedToday: completedToday ?? this.completedToday,
      totalAssigned: totalAssigned ?? this.totalAssigned,
    );
  }
}
