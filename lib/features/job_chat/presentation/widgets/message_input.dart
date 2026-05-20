import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/job_actions_bar.dart';

class MessageInput extends GetView<JobChatController> {
  const MessageInput({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppUIConstants.spacing.space$16,
        AppUIConstants.spacing.space$8,
        AppUIConstants.spacing.space$8,
        AppUIConstants.spacing.space$16 + context.mediaQueryPadding.bottom,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: AppUIConstants.shadows.sm,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const JobActionsBar(),
          Obx(() {
            final actions = controller.availableActions;
            if (actions.isEmpty) return const SizedBox.shrink();
            return AppUIConstants.widgets.verticalBox$8;
          }),
          Row(
            children: [
              IconButton(
                icon: Icon(AppIcons.common.camera, color: colorScheme.primary),
                onPressed: controller.sendMockPhoto,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppUIConstants.spacing.space$16,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$24),
                  ),
                  child: TextField(
                    controller: controller.messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                      hintStyle: context.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    onSubmitted: (_) => controller.sendMessage(),
                  ),
                ),
              ),
              AppUIConstants.widgets.horizontalBox$8,
              IconButton(
                icon: Icon(Icons.send_rounded, color: colorScheme.primary),
                onPressed: controller.sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
