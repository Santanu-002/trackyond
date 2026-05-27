import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/job_actions_bar.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/reply_preview_bar.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/chat_input_field.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/chat_send_button.dart';

class MessageInput extends GetView<JobChatController> {
  const MessageInput({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppUIConstants.spacing.space$16,
        AppUIConstants.spacing.space$8,
        AppUIConstants.spacing.space$16,
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
            final isReplying = controller.replyingToMessage.value != null;
            if (actions.isEmpty || isReplying) return const SizedBox.shrink();
            return AppUIConstants.widgets.verticalBox$8;
          }),
          Obx(() {
            if (controller.replyingToMessage.value == null) {
              return const SizedBox.shrink();
            }
            return const ReplyPreviewBar();
          }),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: ChatInputField(
                  controller: controller.messageController,
                  focusNode: controller.focusNode,
                  hintText: 'Type a message...',
                  suffix: IconButton(
                    icon: Icon(
                      AppIcons.common.attachment,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    onPressed: controller.sendMockPhoto,
                  ),
                ),
              ),
              AppUIConstants.widgets.horizontalBox$8,
              Obx(() {
                final isSending = controller.isMessageSending.value;
                return ChatSendButton(
                  onPressed: controller.sendMessage,
                  isLoading: isSending,
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
