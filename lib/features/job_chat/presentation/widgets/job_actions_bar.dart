import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';

class JobActionsBar extends GetView<JobChatController> {
  const JobActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final actions = controller.availableActions;
      if (actions.isEmpty) return const SizedBox.shrink();

      return Container(
        padding: EdgeInsets.symmetric(vertical: AppUIConstants.spacing.space$8),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: context.theme.colorScheme.outlineVariant,
              width: 0.5,
            ),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppUIConstants.spacing.space$16,
            ),
            child: Row(
              children: actions.map((action) {
                return Padding(
                  padding: EdgeInsets.only(right: AppUIConstants.spacing.space$8),
                  child: AppButton.outlined(
                    text: action,
                    onPressed: () => controller.executeAction(action),
                    height: 32,
                    width: null,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    });
  }
}
