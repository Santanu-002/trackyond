import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';

class SendMessageResult {
  final JobChatMessageEntity message;
  final List<String> allowedActions;

  SendMessageResult({
    required this.message,
    required this.allowedActions,
  });
}
