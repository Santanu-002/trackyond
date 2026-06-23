import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/job_action.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/actions/job_action_button.dart';

import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_action_controller.dart';

class JobActionsBar extends GetView<JobChatController> {
  const JobActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final actionController = Get.find<JobChatActionController>();

    return Obx(() {
      if (controller.replyingToMessage.value != null) {
        return const SizedBox.shrink();
      }
      if (controller.errorMessage.value != null) {
        return Row(
          children: [
            Icon(
              AppIcons.status.warn,
              color: context.theme.colorScheme.error,
              size: 20,
            ),
            AppUIConstants.widgets.horizontalBox$8,
            Text(
              AppStrings.jobChat.somethingWentWrong,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.theme.colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            AppButton.ghost(
              onPressed: controller.fetchMessages,
              height: 32,
              width: null,
              color: context.theme.colorScheme.error,
              child: Text(
                AppStrings.jobChat.retry,
                style: TextStyle(
                  color: context.theme.colorScheme.error,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      }

      final actions = actionController.availableActions;
      if (actions.isEmpty) return const SizedBox.shrink();

      final List<String> mainActions = [];
      final List<String> secondaryActions = [];

      for (final actionString in actions) {
        final jobAction = JobAction.fromString(actionString);
        if (jobAction == null) continue;
        if (_isMainAction(jobAction)) {
          mainActions.add(actionString);
        } else {
          secondaryActions.add(actionString);
        }
      }

      // Group secondary actions into pairs for the 2x2 grid, leaving the last odd child full width.
      final List<List<String>> secondaryChunks = [];
      for (int i = 0; i < secondaryActions.length; i += 2) {
        if (i + 1 < secondaryActions.length) {
          secondaryChunks.add([secondaryActions[i], secondaryActions[i + 1]]);
        } else {
          secondaryChunks.add([secondaryActions[i]]);
        }
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (secondaryActions.isNotEmpty) ...[
            ...List.generate(secondaryChunks.length, (rowIndex) {
              final chunk = secondaryChunks[rowIndex];
              final isLastRow = rowIndex == secondaryChunks.length - 1;

              Widget rowChild;
              if (chunk.length == 2) {
                rowChild = Row(
                  children: [
                    Expanded(
                      child: JobActionButton(
                        actionString: chunk[0],
                        isMain: false,
                      ),
                    ),
                    AppUIConstants.widgets.horizontalBox$8,
                    Expanded(
                      child: JobActionButton(
                        actionString: chunk[1],
                        isMain: false,
                      ),
                    ),
                  ],
                );
              } else {
                rowChild = JobActionButton(
                  actionString: chunk[0],
                  isMain: false,
                );
              }

              return Padding(
                padding: EdgeInsets.only(
                  bottom: isLastRow ? 0 : AppUIConstants.spacing.space$8,
                ),
                child: rowChild,
              );
            }),
          ],
          if (secondaryActions.isNotEmpty && mainActions.isNotEmpty)
            AppUIConstants.widgets.verticalBox$8,
          if (mainActions.isNotEmpty) ...[
            ...List.generate(mainActions.length, (index) {
              final actionString = mainActions[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == mainActions.length - 1 ? 0 : AppUIConstants.spacing.space$8,
                ),
                child: JobActionButton(
                  actionString: actionString,
                  isMain: true,
                ),
              );
            }),
          ],
        ],
      );
    });
  }

  bool _isMainAction(JobAction action) {
    return action == JobAction.reached ||
        action == JobAction.startJob ||
        action == JobAction.startJobWithCapturePhoto ||
        action == JobAction.completeJob ||
        action == JobAction.completeJobWithCapturePhoto ||
        action == JobAction.cancelJob ||
        action == JobAction.reopenJob;
  }
}
