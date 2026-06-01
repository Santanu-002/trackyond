enum JobChatMessageType {
  message('message'),
  activity('activity');

  final String value;
  const JobChatMessageType(this.value);

  static JobChatMessageType fromString(String? val) {
    if (val == null) return JobChatMessageType.message;
    return JobChatMessageType.values.firstWhere(
      (e) => e.value == val.toLowerCase(),
      orElse: () => JobChatMessageType.message,
    );
  }

  String toJson() => value;
}
