import 'package:trackyond/core/common/events/app_event.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';

sealed class ChatEvent extends AppEvent {
  const ChatEvent();
}

class ChatMessageReceivedEvent extends ChatEvent {
  final JobChatMessageEntity message;
  final JobEntity? job;
  const ChatMessageReceivedEvent(this.message, {this.job});
}

class ChatMessageDeletedEvent extends ChatEvent {
  final String jobId;
  final List<String> messageUids;

  const ChatMessageDeletedEvent({
    required this.jobId,
    required this.messageUids,
  });
}

class ChatMessageSeenEvent extends ChatEvent {
  final String jobId;
  const ChatMessageSeenEvent(this.jobId);
}

class ChatMessageDeliveredEvent extends ChatEvent {
  final String jobId;
  final List<String> messageUids;
  final DateTime deliveredAt;

  const ChatMessageDeliveredEvent({
    required this.jobId,
    required this.messageUids,
    required this.deliveredAt,
  });
}

class ChatMessageReadEvent extends ChatEvent {
  final String jobId;
  final List<String> messageUids;
  final DateTime seenAt;

  const ChatMessageReadEvent({
    required this.jobId,
    required this.messageUids,
    required this.seenAt,
  });
}

