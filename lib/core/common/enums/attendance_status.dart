enum AttendanceStatus {
  notStarted('not started'),
  working('working'),
  ended('ended');

  final String value;
  const AttendanceStatus(this.value);

  static AttendanceStatus fromString(String? status) {
    return AttendanceStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => AttendanceStatus.notStarted,
    );
  }
}
