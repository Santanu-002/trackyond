import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';

sealed class ChatItem {
  const ChatItem();

  const factory ChatItem.header({required JobChatMessageEntity message}) =
      ChatHeaderMessage;

  const factory ChatItem.dateHeader({required DateTime date}) = ChatDateHeader;

  const factory ChatItem.timeHeader({required DateTime time}) =
      ChatTimeHeaderItem;

  const factory ChatItem.activityBubble({
    required JobChatMessageEntity message,
    @Default(false) bool hasSameSenderAbove,
    @Default(false) bool hasSameSenderBelow,
  }) = ChatActivityBubble;

  const factory ChatItem.messageBubble({
    required JobChatMessageEntity message,
    @Default(false) bool hasSameSenderAbove,
    @Default(false) bool hasSameSenderBelow,
  }) = ChatMessageBubbleItem;

  const factory ChatItem.unreadDivider() = ChatUnreadDividerItem;
}

class ChatHeaderMessage extends ChatItem {
  final JobChatMessageEntity message;

  const ChatHeaderMessage({required this.message});
}

class ChatDateHeader extends ChatItem {
  final DateTime date;

  const ChatDateHeader({required this.date});
}

class ChatTimeHeaderItem extends ChatItem {
  final DateTime time;

  const ChatTimeHeaderItem({required this.time});
}

class ChatActivityBubble extends ChatItem {
  final JobChatMessageEntity message;
  final bool hasSameSenderAbove;
  final bool hasSameSenderBelow;

  const ChatActivityBubble({
    required this.message,
    this.hasSameSenderAbove = false,
    this.hasSameSenderBelow = false,
  });
}

class ChatMessageBubbleItem extends ChatItem {
  final JobChatMessageEntity message;
  final bool hasSameSenderAbove;
  final bool hasSameSenderBelow;

  const ChatMessageBubbleItem({
    required this.message,
    this.hasSameSenderAbove = false,
    this.hasSameSenderBelow = false,
  });
}

class ChatUnreadDividerItem extends ChatItem {
  const ChatUnreadDividerItem();
}

