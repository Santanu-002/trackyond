import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/common/widgets/text_field/app_text_field.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/job_actions_bar.dart';

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
            if (actions.isEmpty) return const SizedBox.shrink();
            return AppUIConstants.widgets.verticalBox$8;
          }),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Obx(() {
                  final isFocused = controller.hasFocus.value;
                  return Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isFocused
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                        width: isFocused ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: controller.messageController,
                            focusNode: controller.focusNode,
                            hintText: 'Type a message...',
                            textStyle: context.textTheme.bodyMedium,
                            hintStyle: context.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                            ),
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                            maxLines: 5,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            filled: false,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            AppIcons.common.attachment,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          onPressed: controller.sendMockPhoto,
                        ),
                      ],
                    ),
                  );
                }),
              ),
              AppUIConstants.widgets.horizontalBox$8,
              AppButton.icon(
                icon: Icon(
                  AppIcons.common.send,
                  size: 22,
                ),
                onPressed: controller.sendMessage,
                size: 48,
                borderRadius: 100,
                color: colorScheme.primary,
                iconColor: colorScheme.onPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
