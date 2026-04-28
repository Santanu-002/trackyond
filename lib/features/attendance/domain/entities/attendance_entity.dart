class AttendanceEntity {
  final int id;
  final String status;
  final DateTime startAt;
  final DateTime? endAt;
  final double? workHours;
  final String? address;

  const AttendanceEntity({
    required this.id,
    required this.status,
    required this.startAt,
    this.endAt,
    this.workHours,
    this.address,
  });
}
