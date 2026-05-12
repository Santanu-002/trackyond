class DashboardStats {
  final int pending;
  final int inProgress;
  final int completed;
  final int cancelled;

  DashboardStats({
    required this.pending,
    required this.inProgress,
    required this.completed,
    required this.cancelled,
  });

  DashboardStats copyWith({
    int? pending,
    int? inProgress,
    int? completed,
    int? cancelled,
  }) {
    return DashboardStats(
      pending: pending ?? this.pending,
      inProgress: inProgress ?? this.inProgress,
      completed: completed ?? this.completed,
      cancelled: cancelled ?? this.cancelled,
    );
  }
}
