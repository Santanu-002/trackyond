enum JobChatMessageType {
  text('text'),
  image('image'),
  video('video'),
  document('document'),
  pdf('pdf'),
  activity('activity'),
  header('header'),
  reply('reply');

  final String value;
  const JobChatMessageType(this.value);

  static JobChatMessageType fromString(String? value) {
    return JobChatMessageType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => JobChatMessageType.text,
    );
  }
}
