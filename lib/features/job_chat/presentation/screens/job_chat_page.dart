import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/message_bubble.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/message_input.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/timeline_entry.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_type.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/date_chip.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/time_chip.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';

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
                padding: EdgeInsets.symmetric(horizontal: AppUIConstants.spacing.space$16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];

                  if (item is DateTime) {
                    return DateChip(date: item);
                  }

                  if (item is ChatTimeHeader) {
                    return TimeChip(time: item.timestamp);
                  }

                  if (item is JobChatMessageEntity) {
                    final isSystem = item.authorType == 'system' ||
                        item.contents.any((c) {
                          final type = JobChatMessageType.fromString(c.type);
                          if (type == JobChatMessageType.activity &&
                              c.metadata?['activity_type'] == 'reached_location') {
                            return false;
                          }
                          return type == JobChatMessageType.activity ||
                              type == JobChatMessageType.header;
                        });

                    if (isSystem) {
                      return TimelineEntry(message: item);
                    }
                    return Padding(
                      padding: EdgeInsets.only(bottom: AppUIConstants.spacing.space$4),
                      child: MessageBubble(message: item),
                    );
                  }

                  return const SizedBox.shrink();
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
