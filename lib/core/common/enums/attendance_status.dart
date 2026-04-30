enum AttendanceStatus {
  notStarted('not started'),
  working('working');

  final String value;
  const AttendanceStatus(this.value);

  static AttendanceStatus fromString(String? status) {
    if (status == 'ended') return AttendanceStatus.notStarted;
    return AttendanceStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => AttendanceStatus.notStarted,
    );
  }
}
