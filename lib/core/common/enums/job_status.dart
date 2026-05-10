enum JobStatus {
  pending('pending'),
  assigned('assigned'),
  inProgress('inProgress'),
  completed('completed'),
  cancelled('cancelled');

  final String value;
  const JobStatus(this.value);

  static JobStatus fromString(String? status) {
    if (status == null) return JobStatus.pending;
    
    return switch (status.toLowerCase()) {
      'pending' => JobStatus.pending,
      'assigned' => JobStatus.assigned,
      'inprogress' || 'in_progress' => JobStatus.inProgress,
      'completed' => JobStatus.completed,
      'cancelled' => JobStatus.cancelled,
      _ => JobStatus.pending,
    };
  }

  String toJson() => value;
}
