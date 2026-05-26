enum JobChatMessageType {
  text('text'),
  image('image'),
  video('video'),
  docs('docs'),
  activity('activity'),
  header('header'),
  referReply('refer/reply');

  final String value;
  const JobChatMessageType(this.value);

  static JobChatMessageType fromString(String? value) {
    return JobChatMessageType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => JobChatMessageType.text,
    );
  }
}
