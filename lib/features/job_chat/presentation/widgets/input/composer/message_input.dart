import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_action_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_attachment_controller.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/actions/job_actions_bar.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/reply/reply_preview_bar.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/composer/chat_input_field.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/composer/chat_send_button.dart';


class MessageInput extends GetView<JobChatController> {
  const MessageInput({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final actionController = Get.find<JobChatActionController>();
    final attachmentController = Get.find<JobChatAttachmentController>();

    return CompositedTransformTarget(
      link: attachmentController.layerLink,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          AppUIConstants.spacing.space$16,
          AppUIConstants.spacing.space$8,
          AppUIConstants.spacing.space$16,
          AppUIConstants.spacing.space$8 + context.mediaQueryPadding.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const JobActionsBar(),
            Obx(() {
              final actions = actionController.availableActions;
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
                    backgroundColor: context.theme.scaffoldBackgroundColor,
                    suffix: Obx(() {
                      final isOpen = attachmentController.showAttachmentMenu.value;
                      return IconButton(
                        icon: Icon(
                          AppIcons.common.attachment,
                          color: isOpen ? colorScheme.secondary : colorScheme.primary,
                          size: 20,
                        ),
                        onPressed: attachmentController.toggleAttachmentMenu,
                      );
                    }),
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
      ),
    );
  }
}
