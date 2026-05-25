import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/job_action.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
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
          final actionString = actions[index];
          final jobAction = JobAction.fromString(actionString);
          
          if (jobAction == null) return const SizedBox.shrink();

          final isPrimary = jobAction == JobAction.reached ||
                            jobAction == JobAction.startJob ||
                            jobAction == JobAction.startJobWithCapturePhoto ||
                            jobAction == JobAction.completeJob ||
                            jobAction == JobAction.completeJobWithCapturePhoto;

          Color getActionColor(JobAction action) {
             if (action == JobAction.completeJob || action == JobAction.completeJobWithCapturePhoto) {
               return context.theme.colorScheme.completed;
             }
             if (action == JobAction.cancelJob) {
               return context.theme.colorScheme.error;
             }
             if (action == JobAction.takeBreak || action == JobAction.breakOut) {
               return context.theme.colorScheme.pending;
             }
             return context.theme.colorScheme.primary;
          }

          final baseColor = getActionColor(jobAction);

          final contentColor = isPrimary
              ? context.theme.colorScheme.onPrimary
              : baseColor;

          Widget actionWidget = Obx(() {
            final isThisActionLoading =
                controller.isActionLoading.value &&
                controller.loadingActionLabel.value == actionString;
            final message = controller.actionLoadingMessage.value;

            final progress = controller.uploadProgress.value;

            final isUploading = isThisActionLoading &&
                (message == 'Uploading photo...' || progress > 0);

            final buttonChild = isThisActionLoading
                ? (isUploading
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppUIConstants.spacing.space$16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                                    // ignore: avoid_redundant_argument_values
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
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  AppUIConstants.widgets.verticalBox$4,
                                  LinearProgressIndicator(
                                    value: progress > 0 ? progress : null,
                                    backgroundColor: contentColor.withValues(alpha: 0.2),
                                    valueColor: AlwaysStoppedAnimation<Color>(contentColor),
                                    minHeight: 4,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              ),
                            ),
                            AppUIConstants.widgets.horizontalBox$16,
                            IconButton(
                              onPressed: controller.cancelCurrentAction,
                              icon: Icon(
                                Icons.close_rounded,
                                color: contentColor,
                                size: 24,
                              ),
                              splashRadius: 20,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: AppUIConstants.spacing.space$12,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: contentColor,
                            ),
                          ),
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
                      ))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getIconForAction(jobAction),
                        color: contentColor,
                        size: 24,
                      ),
                      AppUIConstants.widgets.horizontalBox$4,
                      Text(
                        jobAction.label,
                        style: context.textTheme.labelLarge?.copyWith(
                          color: contentColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  );

            return isPrimary
                ? AppButton.filled(
                    key: ValueKey('action_${jobAction.value}'),
                    shape: AppButtonShape.roundEdge,
                    width: double.infinity,
                    height: 56,
                    color: baseColor,
                    onPressed: isAnyActionLoading
                        ? null
                        : () => controller.executeAction(actionString),
                    child: buttonChild,
                  )
                : AppButton.outlined(
                    key: ValueKey('action_${jobAction.value}'),
                    shape: AppButtonShape.roundEdge,
                    width: double.infinity,
                    height: 56,
                    color: baseColor,
                    onPressed: isAnyActionLoading
                        ? null
                        : () => controller.executeAction(actionString),
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

  IconData _getIconForAction(JobAction jobAction) {
    return switch (jobAction) {
      JobAction.reached => AppIcons.jobs.reached,
      JobAction.startJob || JobAction.startJobWithCapturePhoto => AppIcons.common.play,
      JobAction.completeJob || JobAction.completeJobWithCapturePhoto => AppIcons.status.success,
      JobAction.takeBreak => AppIcons.jobs.coffee,
      JobAction.breakOut => AppIcons.common.play,
      JobAction.sendLocation => AppIcons.jobs.myLocation,
      JobAction.cancelJob => AppIcons.dashboard.cancelled,
      JobAction.reopenJob => AppIcons.common.refresh,
      JobAction.askLocation => AppIcons.jobs.locationSearching,
      JobAction.askStatus => AppIcons.jobs.statusQuestion,
      JobAction.statusWithProofs => AppIcons.jobs.cameraOutlined,
    };
  }
}
