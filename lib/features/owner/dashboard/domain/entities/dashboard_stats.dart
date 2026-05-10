class DashboardStats {
  final int pending;
  final int inProgress;
  final int completed;

  DashboardStats({
    required this.pending,
    required this.inProgress,
    required this.completed,
  });

  DashboardStats copyWith({
    int? pending,
    int? inProgress,
    int? completed,
  }) {
    return DashboardStats(
      pending: pending ?? this.pending,
      inProgress: inProgress ?? this.inProgress,
      completed: completed ?? this.completed,
    );
  }
}
