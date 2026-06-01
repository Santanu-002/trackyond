import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';

class SendMessageResult {
  final JobChatMessageEntity message;
  final List<JobChatMessageEntity> messages;
  final List<String> allowedActions;
  final JobEntity? job;

  SendMessageResult({
    required this.message,
    required this.messages,
    required this.allowedActions,
    this.job,
  });
}
