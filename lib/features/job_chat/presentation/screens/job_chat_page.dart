import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/message_bubble.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/message_input.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/chips/timeline_entry.dart';
import 'package:trackyond/features/job_chat/domain/entities/chat_item.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/chips/date_chip.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/chips/time_chip.dart';

class JobChatPage extends GetView<JobChatController> {
  const JobChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.textTheme;

    return AppScaffold(
      useScrollView: false,
      padding: EdgeInsets.zero,
      titleSpacing: 0,
      centerTitle: false,
      onBackPressed: controller.onBack,
      titleWidget: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.job.jobTitle,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AppStrings.jobChat.jobSubtitle(
                controller.job.jobId,
                controller.job.status.label(context),
              ),
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(AppIcons.common.menu),
          onPressed: () {
            // TODO: Implement options
          },
        ),
      ],
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.messages.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final items = controller.flattenedItems;

              return ScrollablePositionedList.builder(
                itemScrollController: controller.itemScrollController,
                itemPositionsListener: controller.itemPositionsListener,
                initialScrollIndex: 0,
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: AppUIConstants.spacing.space$16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final prevItem = index > 0 ? items[index - 1] : null;
                  final nextItem = index + 1 < items.length ? items[index + 1] : null;

                  bool isSameSender(ChatItem? a, ChatItem? b) {
                    if (a == null || b == null) return false;
                    JobChatMessageEntity? getMsg(ChatItem i) {
                      if (i is ChatMessageBubbleItem) return i.message;
                      if (i is ChatActivityBubble) return i.message;
                      return null;
                    }
                    final msgA = getMsg(a);
                    final msgB = getMsg(b);
                    if (msgA != null && msgB != null) {
                      // Activity messages from system don't count towards grouping
                      if (msgA.authorType == 'system' || msgB.authorType == 'system') return false;
                      return msgA.senderId == msgB.senderId;
                    }
                    return false;
                  }

                  // In a reversed list:
                  // nextItem (index + 1) is chronologically older (above)
                  // prevItem (index - 1) is chronologically newer (below)
                  final bool hasSameSenderAbove = isSameSender(nextItem, item);
                  final bool hasSameSenderBelow = isSameSender(item, prevItem);

                  // Determine bottom padding based on item relationship (which is spacing towards index - 1, visually below)
                  double bottomPadding = AppUIConstants.spacing.space$4;

                  if (item is ChatTimeHeaderItem) {
                    bottomPadding = AppUIConstants.spacing.space$2;
                  } else if (item is ChatHeaderMessage) {
                    if (prevItem is ChatHeaderMessage) {
                      bottomPadding = 0;
                    } else {
                      bottomPadding = AppUIConstants.spacing.space$12;
                    }
                  } else if (item is ChatMessageBubbleItem || item is ChatActivityBubble) {
                    if (hasSameSenderBelow) {
                      bottomPadding = AppUIConstants.spacing.space$2; // Tighter grouping for same sender
                    } else if (prevItem is ChatMessageBubbleItem || prevItem is ChatActivityBubble) {
                      bottomPadding = AppUIConstants.spacing.space$8; // Normal spacing between different senders
                    } else {
                      bottomPadding = AppUIConstants.spacing.space$16;
                    }
                  }

                  return Padding(
                    padding: EdgeInsets.only(bottom: bottomPadding),
                    child: switch (item) {
                      ChatDateHeader(:final date) => DateChip(date: date),
                      ChatTimeHeaderItem(:final time) => TimeChip(time: time),
                      ChatHeaderMessage(:final message) => TimelineEntry(message: message),
                      ChatActivityBubble(:final message) => MessageBubble(
                        message: message,
                        hasSameSenderAbove: hasSameSenderAbove,
                        hasSameSenderBelow: hasSameSenderBelow,
                      ),
                      ChatMessageBubbleItem(:final message) => MessageBubble(
                        message: message,
                        hasSameSenderAbove: hasSameSenderAbove,
                        hasSameSenderBelow: hasSameSenderBelow,
                      ),
                    },
                  );
                },
              );
            }),
          ),
          const MessageInput(),
        ],
      ),
    );
  }
}
