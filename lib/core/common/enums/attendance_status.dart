enum AttendanceStatus {
  notStarted('not started'),
  working('working'),
  ended('ended');

  final String value;
  const AttendanceStatus(this.value);

  static AttendanceStatus fromString(String? status) {
    if (status == null) return AttendanceStatus.notStarted;
    final lowerStatus = status.toLowerCase().replaceFirst('_', ' ');
    return AttendanceStatus.values.firstWhere(
      (e) => e.value == lowerStatus,
      orElse: () => AttendanceStatus.notStarted,
    );
  }
}

