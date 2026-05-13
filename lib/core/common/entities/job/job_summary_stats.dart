import 'package:equatable/equatable.dart';

class JobSummaryStats extends Equatable {
  final int pending;
  final int inProgress;
  final int completed;
  final int cancelled;
  
  // Worker specific
  final int completedToday;
  final int totalAssigned;

  const JobSummaryStats({
    this.pending = 0,
    this.inProgress = 0,
    this.completed = 0,
    this.cancelled = 0,
    this.completedToday = 0,
    this.totalAssigned = 0,
  });

  JobSummaryStats copyWith({
    int? pending,
    int? inProgress,
    int? completed,
    int? cancelled,
    int? completedToday,
    int? totalAssigned,
  }) {
    return JobSummaryStats(
      pending: pending ?? this.pending,
      inProgress: inProgress ?? this.inProgress,
      completed: completed ?? this.completed,
      cancelled: cancelled ?? this.cancelled,
      completedToday: completedToday ?? this.completedToday,
      totalAssigned: totalAssigned ?? this.totalAssigned,
    );
  }

  @override
  List<Object?> get props => [
        pending,
        inProgress,
        completed,
        cancelled,
        completedToday,
        totalAssigned,
      ];
}
