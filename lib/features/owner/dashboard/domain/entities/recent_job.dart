class RecentJob {
  final String title;
  final String location;
  final double budget;
  final String status;
  final bool isOngoing;

  const RecentJob({
    required this.title,
    required this.location,
    required this.budget,
    required this.status,
    this.isOngoing = true,
  });
}
