class AttendanceEntity {
  final int id;
  final String accountUid;
  final String userUid;
  final String companyUid;
  final String status;
  final DateTime startAt;
  final DateTime? endAt;
  final double startLatitude;
  final double startLongitude;
  final double? endLatitude;
  final double? endLongitude;
  final double? workHours;
  final String? startAddress;
  final String? endAddress;

  const AttendanceEntity({
    required this.id,
    required this.accountUid,
    required this.userUid,
    required this.companyUid,
    required this.status,
    required this.startAt,
    this.endAt,
    required this.startLatitude,
    required this.startLongitude,
    this.endLatitude,
    this.endLongitude,
    this.workHours,
    this.startAddress,
    this.endAddress,
  });
}
