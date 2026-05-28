import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/job_activity_type.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/reply_image_thumbnail.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';

class ReplyPreviewBar extends GetView<JobChatController> {
  const ReplyPreviewBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final colorScheme = context.theme.colorScheme;
      final textTheme = context.textTheme;
      final replyMsg = controller.replyingToMessage.value;
      if (replyMsg == null) return const SizedBox.shrink();

      final isMe = replyMsg.isMe;
      String senderName;
      if (isMe) {
        senderName = 'You';
      } else if (replyMsg.type == 'activity') {
        final metaWorkerName = replyMsg.metadata?['workerName'] as String?;
        if (metaWorkerName != null && metaWorkerName.isNotEmpty) {
          senderName = metaWorkerName;
        } else {
          senderName = controller.getSenderName(replyMsg);
          if (senderName == 'System') {
            final activityType =
                JobActivityType.fromString(replyMsg.metadata?['activity_type']);
            final isOwnerAction =
                activityType == JobActivityType.askLocation ||
                activityType == JobActivityType.askStatus ||
                activityType == JobActivityType.askStatusProofs ||
                activityType == JobActivityType.cancelJob ||
                activityType == JobActivityType.reopenJob ||
                activityType == JobActivityType.jobCreated;
            senderName = isOwnerAction
                ? (controller.job.createdByName ?? 'Admin')
                : (controller.job.workerName ?? 'Worker');
          }
        }
      } else {
        senderName = controller.getSenderName(replyMsg);
        if (senderName.toLowerCase() == 'user') {
          // Fallback if local fallback returned 'user' or 'User'
          senderName = controller.job.workerName ?? 'Worker';
        }
      }

      // Check if it has an image
      String? imageUrl;
      String? blurHash;
      final imageContents =
          replyMsg.content.where((c) => c.type == 'image').toList();
      final firstImage = imageContents.firstOrNull;
      if (firstImage != null) {
        imageUrl = firstImage.metadata?['url'] as String?;
        blurHash = firstImage.metadata?['blurHash'] as String?;
      }

      final isActivity = replyMsg.type == 'activity';

      Widget contentWidget;
      Widget? leadingImage;

      if (imageUrl != null) {
        leadingImage = Padding(
          padding: EdgeInsets.only(right: AppUIConstants.spacing.space$8),
          child: ReplyImageThumbnail(
            imageUrl: imageUrl,
            blurHash: blurHash,
            remainingCount:
                imageContents.length > 1 ? (imageContents.length - 1) : 0,
            size: 40.0,
            borderRadius: AppUIConstants.radius.radius$4,
          ),
        );
      }

      if (isActivity) {
        final activityType =
            JobActivityType.fromString(replyMsg.metadata?['activity_type']);

        String activityTitle;
        IconData activityIcon;
        switch (activityType) {
          case JobActivityType.jobCreated:
            activityTitle = AppStrings.jobChat.activityJobAssigned;
            activityIcon = AppIcons.jobs.work;
            break;
          case JobActivityType.reachedLocation:
            activityTitle = AppStrings.jobChat.activityReachedSite;
            activityIcon = AppIcons.jobs.checkIn;
            break;
          case JobActivityType.startedJob:
            activityTitle = AppStrings.jobChat.activityJobStarted;
            activityIcon = AppIcons.common.play;
            break;
          case JobActivityType.completedJob:
            activityTitle = AppStrings.jobChat.activityJobCompleted;
            activityIcon = AppIcons.status.success;
            break;
          case JobActivityType.takeBreak:
            activityTitle = AppStrings.jobChat.activityOnBreak;
            activityIcon = AppIcons.jobs.coffee;
            break;
          case JobActivityType.breakOut:
            activityTitle = AppStrings.jobChat.activityBreakEnded;
            activityIcon = AppIcons.common.play;
            break;
          case JobActivityType.sendLocation:
            activityTitle = AppStrings.jobChat.activityLocationShared;
            activityIcon = AppIcons.jobs.myLocation;
            break;
          case JobActivityType.askLocation:
            activityTitle = AppStrings.jobChat.activityLocationRequested;
            activityIcon = AppIcons.jobs.locationSearching;
            break;
          case JobActivityType.askStatus:
            activityTitle = AppStrings.jobChat.activityStatusRequested;
            activityIcon = AppIcons.jobs.statusQuestion;
            break;
          case JobActivityType.askStatusProofs:
            activityTitle = AppStrings.jobChat.activityStatusProofsRequested;
            activityIcon = AppIcons.jobs.cameraOutlined;
            break;
          case JobActivityType.cancelJob:
            activityTitle = AppStrings.jobChat.activityJobCancelled;
            activityIcon = AppIcons.dashboard.cancelled;
            break;
          case JobActivityType.reopenJob:
            activityTitle = AppStrings.jobChat.activityJobReopened;
            activityIcon = AppIcons.common.refresh;
            break;
          default:
            activityTitle = AppStrings.jobChat.activityUpdate;
            activityIcon = Icons.info_outline;
        }

        contentWidget = Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6.0),
              // fine-tuned icon container padding
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(activityIcon, size: 16, color: colorScheme.primary),
            ),
            AppUIConstants.widgets.horizontalBox$8,
            Expanded(
              child: Text(
                activityTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        );
      } else {
        final textContent =
            replyMsg.content
                .firstWhereOrNull((c) => c.type == 'text')
                ?.content ??
            '';
        contentWidget = Text(
          imageUrl != null && textContent.isEmpty ? 'Photo' : textContent,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        );
      }

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => controller.scrollToMessage(replyMsg.uid),
        child: Container(
          margin: EdgeInsets.only(bottom: AppUIConstants.spacing.space$8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              AppUIConstants.radius.radius$12,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.08),
                border: Border(
                  left: BorderSide(color: colorScheme.primary, width: 4),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: AppUIConstants.spacing.space$8,
                vertical: AppUIConstants.spacing.space$8,
              ),
              child: Row(
                children: [
                  ?leadingImage,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          senderName,
                          style: textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        // sub-pixel nudge between name and content
                        contentWidget,
                      ],
                    ),
                  ),
                  AppUIConstants.widgets.horizontalBox$8,
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: controller.cancelReply,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
