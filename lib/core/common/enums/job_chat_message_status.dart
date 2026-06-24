enum JobChatMessageStatus {
  pending('pending'),
  sent('sent'),
  delivered('delivered'),
  seen('seen');

  final String value;
  const JobChatMessageStatus(this.value);

  static JobChatMessageStatus fromString(String? val) {
    if (val == null) return JobChatMessageStatus.sent;
    return JobChatMessageStatus.values.firstWhere(
      (e) => e.value == val.toLowerCase(),
      orElse: () => JobChatMessageStatus.sent,
    );
  }

  String toJson() => value;
}
