import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/job_action.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';

class JobActionsBar extends GetView<JobChatController> {
  const JobActionsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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

      final actions = controller.availableActions;
      if (actions.isEmpty) return const SizedBox.shrink();

      final isLoading = controller.isActionLoading.value;
      final isAnyActionLoading = isLoading;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(actions.length, (index) {
          final action = actions[index];
          final isPrimary =
              action == JobAction.reached.label ||
              action == JobAction.startJob.label ||
              action == JobAction.completeJob.label ||
              action == JobAction.resume.label;

          final contentColor = isPrimary
              ? context.theme.colorScheme.onPrimary
              : context.theme.colorScheme.primary;

          Widget actionWidget = Obx(() {
            final isThisActionLoading =
                controller.isActionLoading.value &&
                controller.loadingActionLabel.value == action;
            final message = controller.actionLoadingMessage.value;

            final buttonChild = isThisActionLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: contentColor,
                        ),
                      ),
                      AppUIConstants.widgets.horizontalBox$12,
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                              final isEntering =
                                  child.key ==
                                  ValueKey(
                                    controller.actionLoadingMessage.value,
                                  );

                              return SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: isEntering
                                          ? const Offset(0, -0.3)
                                          : const Offset(0, 0.3),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOut,
                                      ),
                                    ),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                        child: Text(
                          message ?? AppStrings.common.loading,
                          key: ValueKey(message),
                          style: context.textTheme.labelLarge?.copyWith(
                            color: contentColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getIconForAction(action),
                        color: contentColor,
                        size: 24,
                      ),
                      AppUIConstants.widgets.horizontalBox$4,
                      Text(
                        action,
                        style: context.textTheme.labelLarge?.copyWith(
                          color: contentColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  );

            return isPrimary
                ? AppButton.filled(
                    key: ValueKey('action_$action'),
                    shape: AppButtonShape.roundEdge,
                    width: double.infinity,
                    height: 56,
                    onPressed: isAnyActionLoading
                        ? null
                        : () => controller.executeAction(action),
                    child: buttonChild,
                  )
                : AppButton.outlined(
                    key: ValueKey('action_$action'),
                    shape: AppButtonShape.roundEdge,
                    width: double.infinity,
                    height: 56,
                    onPressed: isAnyActionLoading
                        ? null
                        : () => controller.executeAction(action),
                    child: buttonChild,
                  );
          });

          if (index < actions.length - 1) {
            return Column(
              children: [
                actionWidget,
                AppUIConstants.widgets.verticalBox$8,
              ],
            );
          }
          return actionWidget;
        }),
      );
    });
  }

  IconData _getIconForAction(String action) {
    if (action == JobAction.reached.label) return AppIcons.jobs.reached;
    if (action == JobAction.startJob.label) return AppIcons.common.play;
    if (action == JobAction.completeJob.label) return AppIcons.status.success;
    if (action == JobAction.resume.label) return AppIcons.common.play;
    if (action == JobAction.takeBreak.label) return AppIcons.jobs.coffee;
    if (action == JobAction.sendLocation.label) return AppIcons.jobs.myLocation;

    // Owner/Admin specific actions
    return switch (action) {
      'Cancel Job' => AppIcons.dashboard.cancelled,
      'Reopen Job' => AppIcons.common.refresh,
      'Ask Location' => AppIcons.jobs.locationSearching,
      'Ask Status' => AppIcons.jobs.statusQuestion,
      'Status with Proofs' => AppIcons.jobs.cameraOutlined,
      _ => Icons.star_border_rounded,
    };
  }
}
