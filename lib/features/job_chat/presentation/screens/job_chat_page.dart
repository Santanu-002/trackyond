import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_selection_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_attachment_controller.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/types/message_bubble.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/composer/message_input.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/attachment/attachment_menu.dart';
import 'package:trackyond/core/common/enums/job_chat_message_status.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/interaction/swipe_to_reply.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/chips/timeline_entry.dart';
import 'package:trackyond/features/job_chat/domain/entities/chat_item.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/chips/date_chip.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/chips/time_chip.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/skeleton/chat_skeleton_list.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/scroll/scroll_to_bottom_button.dart';

class JobChatPage extends GetView<JobChatController> {
  const JobChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.textTheme;
    final selectionController = Get.find<JobChatSelectionController>();
    final attachmentController = Get.find<JobChatAttachmentController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          if (selectionController.isSelectionMode.value) {
            selectionController.exitSelectionMode();
          } else {
            controller.onBack();
          }
        }
      },
      child: Obx(() {
        final isSelectionMode = selectionController.isSelectionMode.value;

        return AppScaffold(
          useScrollView: false,
          padding: EdgeInsets.zero,
          titleSpacing: 0,
          centerTitle: false,
          leading: isSelectionMode
              ? IconButton(
                  icon: Icon(AppIcons.common.close),
                  onPressed: selectionController.exitSelectionMode,
                )
              : null,
          onBackPressed: isSelectionMode ? selectionController.exitSelectionMode : controller.onBack,
          titleWidget: isSelectionMode
              ? Text(
                  '${selectionController.selectedMessageUids.length} ${AppStrings.jobChat.selected}',
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
                  if (selectionController.canCopySelected)
                    IconButton(
                      icon: Icon(AppIcons.common.copy),
                      onPressed: selectionController.copySelectedMessagesText,
                    ),
                  if (selectionController.canDeleteSelected)
                    IconButton(
                      icon: Icon(AppIcons.common.delete),
                      onPressed: () => selectionController.deleteSelectedMessages(context),
                    ),
                ]
              : [
                  IconButton(
                    icon: Icon(CupertinoIcons.ellipsis_vertical),
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
                        return const ChatSkeletonList();
                      }

                      final items = controller.flattenedItems;
                      if (items.isEmpty) {
                        return const SizedBox.expand();
                      }

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
                              initialScrollIndex: controller.initialScrollIndex,
                              initialAlignment: controller.initialScrollAlignment,
                              reverse: true,
                              padding: EdgeInsets.only(
                                top: items.isNotEmpty && items.last is ChatDateHeader
                                    ? 0
                                    : AppUIConstants.spacing.space$8,
                                bottom: 0,
                              ),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                if (index < 0 || index >= items.length) {
                                  return const SizedBox.shrink();
                                }
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
                                    if (msgA.senderUid == 'system' || msgB.senderUid == 'system') return false;
                                    return msgA.senderUid == msgB.senderUid;
                                  }
                                  return false;
                                }

                                final bool hasSameSenderAbove = isSameSender(nextItem, item);
                                final bool hasSameSenderBelow = isSameSender(item, prevItem);

                                double bottomPadding = AppUIConstants.spacing.space$4;

                                if (item is ChatTimeHeaderItem) {
                                  bottomPadding = AppUIConstants.spacing.space$8;
                                } else if (item is ChatDateHeader) {
                                  bottomPadding = 0;
                                } else if (item is ChatHeaderMessage) {
                                  if (prevItem is ChatHeaderMessage) {
                                    bottomPadding = 0;
                                  } else {
                                    bottomPadding = AppUIConstants.spacing.space$12;
                                  }
                                } else if (item is ChatMessageBubbleItem || item is ChatActivityBubble) {
                                  if (hasSameSenderBelow) {
                                    bottomPadding = AppUIConstants.spacing.space$2;
                                  } else if (prevItem is ChatMessageBubbleItem ||
                                      prevItem is ChatActivityBubble ||
                                      prevItem is ChatTimeHeaderItem) {
                                    bottomPadding = AppUIConstants.spacing.space$8;
                                  } else {
                                    bottomPadding = AppUIConstants.spacing.space$16;
                                  }
                                } else if (item is ChatUnreadDividerItem) {
                                  bottomPadding = 0;
                                }

                                return Padding(
                                  padding: EdgeInsets.only(bottom: bottomPadding),
                                  child: switch (item) {
                                    ChatUnreadDividerItem() => Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: AppUIConstants.spacing.space$8,
                                        horizontal: AppUIConstants.spacing.space$24,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Divider(
                                              color: context.theme.colorScheme.error.withValues(alpha: 0.3),
                                              thickness: 1,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: AppUIConstants.spacing.space$12),
                                            child: Text(
                                              AppStrings.jobChat.newMessages,
                                              style: context.textTheme.labelMedium?.copyWith(
                                                color: context.theme.colorScheme.error,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Divider(
                                              color: context.theme.colorScheme.error.withValues(alpha: 0.3),
                                              thickness: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ChatDateHeader(:final date) => DateChip(
                                      date: date,
                                      margin: index == items.length - 1
                                          ? EdgeInsets.only(
                                              top: AppUIConstants.spacing.space$4,
                                              bottom: AppUIConstants.spacing.space$16,
                                            )
                                          : EdgeInsets.only(
                                              top: 0,
                                              bottom: AppUIConstants.spacing.space$16,
                                            ),
                                    ),
                                    ChatTimeHeaderItem(:final time) => TimeChip(time: time),
                                    ChatHeaderMessage(:final message) => Padding(
                                      padding: EdgeInsets.symmetric(horizontal: AppUIConstants.spacing.space$16),
                                      child: TimelineEntry(message: message),
                                    ),
                                    ChatActivityBubble(:final message) => SwipeToReply(
                                      messageUid: message.uid,
                                      isSwipeEnabled: message.status != JobChatMessageStatus.pending,
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
                                      isSwipeEnabled: message.status != JobChatMessageStatus.pending,
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
                          Positioned(
                            bottom: AppUIConstants.spacing.space$16,
                            right: AppUIConstants.spacing.space$16,
                            child: Obx(() {
                              return ScrollToBottomButton(
                                visible: !controller.isNearBottom.value,
                                unreadCount: controller.unreadCount,
                                onTap: () => controller.scrollToLast(animate: true),
                              );
                            }),
                          ),
                        ],
                      );
                    }),
                  ),
                  const MessageInput(),
                ],
              ),
              Obx(() {
                final isOpen = attachmentController.showAttachmentMenu.value;

                return Positioned(
                  left: AppUIConstants.spacing.space$16,
                  right: AppUIConstants.spacing.space$16,
                  child: CompositedTransformFollower(
                    link: attachmentController.layerLink,
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
        );
      }),
    );
  }
}
