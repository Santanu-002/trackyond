enum JobStatus { completed, inProgress, pending, upcoming }

class JobItem {
  final String id;
  final String title;
  final String subtitle;
  final DateTime startTime;
  final DateTime endTime;
  final JobStatus status;

  const JobItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.startTime,
    required this.endTime,
    required this.status,
  });
}
