enum JobChatMessageContentType {
  text('text'),
  image('image'),
  video('video'),
  document('document'),
  pdf('pdf'),
  reply('reply'),
  activity('activity'),
  header('header'),
  unknown('unknown');

  final String value;
  const JobChatMessageContentType(this.value);

  static JobChatMessageContentType fromString(String? val) {
    if (val == null) return JobChatMessageContentType.unknown;
    return JobChatMessageContentType.values.firstWhere(
      (e) => e.value == val.toLowerCase(),
      orElse: () => JobChatMessageContentType.unknown,
    );
  }

  String toJson() => value;
}
