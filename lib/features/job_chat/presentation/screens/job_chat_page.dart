import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/message_bubble.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/message_input.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/attachment_menu.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/swipe_to_reply.dart';
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

    return Obx(() {
      final isSelectionMode = controller.isSelectionMode.value;

      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) {
            if (controller.isSelectionMode.value) {
              controller.exitSelectionMode();
            } else {
              controller.onBack();
            }
          }
        },
        child: AppScaffold(
          useScrollView: false,
          padding: EdgeInsets.zero,
          titleSpacing: 0,
          centerTitle: false,
          leading: isSelectionMode
              ? IconButton(
                  icon: Icon(AppIcons.common.close),
                  onPressed: controller.exitSelectionMode,
                )
              : null,
          onBackPressed: isSelectionMode ? controller.exitSelectionMode : controller.onBack,
          titleWidget: isSelectionMode
              ? Text(
                  '${controller.selectedMessageUids.length} ${AppStrings.jobChat.selected}',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Column(
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
          actions: isSelectionMode
              ? [
                  IconButton(
                    icon: Icon(AppIcons.common.copy),
                    onPressed: controller.copySelectedMessagesText,
                  ),
                ]
              : [
                  IconButton(
                    icon: Icon(AppIcons.common.menu),
                    onPressed: () {
                      // TODO: Implement options
                    },
                  ),
                ],
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value && controller.messages.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final items = controller.flattenedItems;

                      return Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          NotificationListener<ScrollNotification>(
                            onNotification: (notification) {
                              if (notification is ScrollUpdateNotification) {
                                controller.onScrollInteraction();
                              }
                              return false;
                            },
                            child: ScrollablePositionedList.builder(
                              itemScrollController: controller.itemScrollController,
                              itemPositionsListener: controller.itemPositionsListener,
                              initialScrollIndex: 0,
                              reverse: true,
                              padding: EdgeInsets.only(
                                top: AppUIConstants.spacing.space$8,
                                bottom: 0,
                              ),
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
                                    if (msgA.authorType == 'system' || msgB.authorType == 'system') return false;
                                    return msgA.senderId == msgB.senderId;
                                  }
                                  return false;
                                }

                                final bool hasSameSenderAbove = isSameSender(nextItem, item);
                                final bool hasSameSenderBelow = isSameSender(item, prevItem);

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
                                    bottomPadding = AppUIConstants.spacing.space$2;
                                  } else if (prevItem is ChatMessageBubbleItem || prevItem is ChatActivityBubble) {
                                    bottomPadding = AppUIConstants.spacing.space$8;
                                  } else {
                                    bottomPadding = AppUIConstants.spacing.space$16;
                                  }
                                }

                                return Padding(
                                  padding: EdgeInsets.only(bottom: bottomPadding),
                                  child: switch (item) {
                                    ChatDateHeader(:final date) => DateChip(
                                      date: date,
                                      margin: index == items.length - 1
                                          ? EdgeInsets.only(
                                              top: AppUIConstants.spacing.space$4,
                                              bottom: AppUIConstants.spacing.space$8,
                                            )
                                          : null,
                                    ),
                                    ChatTimeHeaderItem(:final time) => TimeChip(time: time),
                                    ChatHeaderMessage(:final message) => Padding(
                                      padding: EdgeInsets.symmetric(horizontal: AppUIConstants.spacing.space$16),
                                      child: TimelineEntry(message: message),
                                    ),
                                    ChatActivityBubble(:final message) => SwipeToReply(
                                      messageUid: message.uid,
                                      onReply: () => controller.setReplyingTo(message),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: AppUIConstants.spacing.space$16),
                                        child: MessageBubble(
                                          message: message,
                                          hasSameSenderAbove: hasSameSenderAbove,
                                          hasSameSenderBelow: hasSameSenderBelow,
                                        ),
                                      ),
                                    ),
                                    ChatMessageBubbleItem(:final message) => SwipeToReply(
                                      messageUid: message.uid,
                                      onReply: () => controller.setReplyingTo(message),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: AppUIConstants.spacing.space$16),
                                        child: MessageBubble(
                                          message: message,
                                          hasSameSenderAbove: hasSameSenderAbove,
                                          hasSameSenderBelow: hasSameSenderBelow,
                                        ),
                                      ),
                                    ),
                                  },
                                );
                              },
                            ),
                          ),
                          Obx(() {
                            final date = controller.floatingDate.value;
                            final isVisible = controller.isFloatingDateVisible.value;
                            
                            if (date == null) return const SizedBox.shrink();

                            return AnimatedPositioned(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              top: isVisible ? AppUIConstants.spacing.space$4 : -50.0,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: isVisible ? 1.0 : 0.0,
                                child: DateChip(
                                  date: date,
                                  margin: EdgeInsets.zero,
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    }),
                  ),
                  const MessageInput(),
                ],
              ),
              Obx(() {
                final isOpen = controller.showAttachmentMenu.value;

                return Positioned(
                  left: AppUIConstants.spacing.space$16,
                  right: AppUIConstants.spacing.space$16,
                  child: CompositedTransformFollower(
                    link: controller.layerLink,
                    showWhenUnlinked: false,
                    targetAnchor: Alignment.topCenter,
                    followerAnchor: Alignment.bottomCenter,
                    offset: Offset(0, -AppUIConstants.spacing.space$4),
                    child: IgnorePointer(
                      ignoring: !isOpen,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isOpen ? 1.0 : 0.0,
                        curve: Curves.easeInOut,
                        child: AnimatedScale(
                          alignment: Alignment.bottomCenter,
                          duration: const Duration(milliseconds: 250),
                          scale: isOpen ? 1.0 : 0.85,
                          curve: Curves.easeOutBack,
                          child: const AttachmentMenu(),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      );
    });
  }
}
