import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/job_action.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';

class JobActionButton extends GetView<JobChatController> {
  final String actionString;
  final bool isMain;

  const JobActionButton({
    super.key,
    required this.actionString,
    required this.isMain,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final jobAction = JobAction.fromString(actionString);
    if (jobAction == null) return const SizedBox.shrink();

    final isPrimary = jobAction == JobAction.reached ||
                      jobAction == JobAction.startJob ||
                      jobAction == JobAction.startJobWithCapturePhoto ||
                      jobAction == JobAction.completeJob ||
                      jobAction == JobAction.completeJobWithCapturePhoto ||
                      jobAction == JobAction.cancelJob;

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
    final contentColor = isPrimary ? colorScheme.onPrimary : baseColor;
    final isAnyActionLoading = controller.isActionLoading.value;

    return Obx(() {
      final isThisActionLoading =
          controller.isActionLoading.value &&
          controller.loadingActionLabel.value == actionString;
      final message = controller.actionLoadingMessage.value;
      final progress = controller.uploadProgress.value;
      final isUploading = isThisActionLoading &&
          (message == 'Uploading photo...' || progress > 0);

      Widget buttonChild;
      if (isThisActionLoading) {
        if (isUploading) {
          buttonChild = Padding(
            padding: EdgeInsets.symmetric(horizontal: isMain ? AppUIConstants.spacing.space$16 : 4.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message ?? AppStrings.common.loading,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.labelLarge?.copyWith(
                          color: contentColor,
                          fontSize: isMain ? 14 : 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      LinearProgressIndicator(
                        value: progress > 0 ? progress : null,
                        backgroundColor: contentColor.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(contentColor),
                        minHeight: 2,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4), // tight spacer for cancel button
                IconButton(
                  onPressed: controller.cancelCurrentAction,
                  icon: Icon(
                    Icons.close_rounded,
                    color: contentColor,
                    size: isMain ? 20 : 14,
                  ),
                  splashRadius: 16,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          );
        } else {
          buttonChild = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: isMain ? 20 : 14,
                width: isMain ? 20 : 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: contentColor,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  message ?? AppStrings.common.loading,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: contentColor,
                    fontSize: isMain ? 15 : 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        }
      } else {
        buttonChild = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIconForAction(jobAction),
              color: contentColor,
              size: isMain ? 22 : 16,
            ),
            const SizedBox(width: 4), // tight icon-label gap
            Flexible(
              child: Text(
                jobAction.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelLarge?.copyWith(
                  color: contentColor,
                  fontSize: isMain ? 15 : 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      }

      return isPrimary
          ? AppButton.filled(
              key: ValueKey('action_${jobAction.value}'),
              shape: AppButtonShape.roundEdge,
              width: double.infinity,
              height: isMain ? 48 : 40,
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
              height: isMain ? 48 : 40,
              color: baseColor,
              onPressed: isAnyActionLoading
                  ? null
                  : () => controller.executeAction(actionString),
              child: buttonChild,
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
