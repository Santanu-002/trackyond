import 'package:trackyond/core/common/events/app_event.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';

sealed class ChatEvent extends AppEvent {
  const ChatEvent();
}

class ChatMessageReceivedEvent extends ChatEvent {
  final JobChatMessageEntity message;
  const ChatMessageReceivedEvent(this.message);
}
