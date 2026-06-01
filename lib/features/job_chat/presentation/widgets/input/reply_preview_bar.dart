import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/job_activity_type.dart';
import 'package:trackyond/core/common/enums/job_chat_message_type.dart';
import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/reply_image_thumbnail.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';

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
      } else if (replyMsg.type == JobChatMessageType.activity) {
        final metaWorkerName = replyMsg.metadata?['workerName'] as String?;
        if (metaWorkerName != null && metaWorkerName.isNotEmpty) {
          senderName = metaWorkerName;
        } else {
          senderName = controller.getSenderName(replyMsg);
          if (senderName == 'System') {
            final activityType =
                JobActivityType.fromString(replyMsg.metadata?['activityType']);
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

      // Check if it has an image or video
      final mediaContents = replyMsg.content
          .where((c) =>
              c.type == JobChatMessageContentType.image ||
              c.type == JobChatMessageContentType.video)
          .toList();
      final firstMedia = mediaContents.firstOrNull;
      String? imageUrl;
      String? blurHash;
      if (firstMedia != null) {
        final path = firstMedia.content ?? '';
        imageUrl = path.startsWith('http') ? path : ApiEndpoints.common.download(path);
        
        if (firstMedia.type == JobChatMessageContentType.video) {
          final dynamic videoMeta = firstMedia.metadata?['videoMetadata'];
          blurHash = (videoMeta is Map ? videoMeta['thumbnailBlurHash'] : null) ?? firstMedia.metadata?['thumbnailBlurHash'] as String?;
        } else {
          final dynamic imageMeta = firstMedia.metadata?['imageMetadata'];
          blurHash = (imageMeta is Map ? imageMeta['blurHash'] : null) ?? firstMedia.metadata?['blurHash'] as String?;
        }
      }

      final isActivity = replyMsg.type == JobChatMessageType.activity;

      Widget contentWidget;
      Widget? leadingImage;

      if (imageUrl != null) {
        leadingImage = Padding(
          padding: EdgeInsets.only(right: AppUIConstants.spacing.space$8),
          child: ReplyImageThumbnail(
            imageUrl: imageUrl,
            blurHash: blurHash,
            remainingCount:
                mediaContents.length > 1 ? (mediaContents.length - 1) : 0,
            size: 40.0,
            borderRadius: AppUIConstants.radius.radius$4,
            isVideo: firstMedia?.type == JobChatMessageContentType.video,
          ),
        );
      }

      if (isActivity) {
        final activityType =
            JobActivityType.fromString(replyMsg.metadata?['activityType']);

        final activityTitle = activityType.title;
        final activityIcon = activityType.icon;

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
                .firstWhereOrNull((c) => c.type == JobChatMessageContentType.text)
                ?.content ??
            '';
        String displayBody = textContent;
        if (imageUrl != null && textContent.isEmpty) {
          displayBody = firstMedia?.type == JobChatMessageContentType.video ? 'Video' : 'Photo';
        }

        if (firstMedia?.type == JobChatMessageContentType.video) {
          contentWidget = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.videocam_outlined,
                size: 14,
                color: colorScheme.primary,
              ),
              AppUIConstants.widgets.horizontalBox$4,
              Flexible(
                child: Text(
                  displayBody,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          );
        } else if (firstMedia?.type == JobChatMessageContentType.image) {
          contentWidget = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.photo_outlined,
                size: 14,
                color: colorScheme.primary,
              ),
              AppUIConstants.widgets.horizontalBox$4,
              Flexible(
                child: Text(
                  displayBody,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          );
        } else {
          contentWidget = Text(
            displayBody,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          );
        }
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
