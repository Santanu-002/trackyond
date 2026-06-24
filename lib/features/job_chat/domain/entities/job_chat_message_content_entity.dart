import 'package:equatable/equatable.dart';
import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';

class JobChatMessageContentEntity extends Equatable {
  final JobChatMessageContentType type;
  final String? content;
  final dynamic metadata;

  const JobChatMessageContentEntity({
    required this.type,
    this.content,
    this.metadata,
  });

  @override
  List<Object?> get props => [type, content, metadata];
}
