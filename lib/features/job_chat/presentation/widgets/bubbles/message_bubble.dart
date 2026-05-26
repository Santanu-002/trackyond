import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';
import 'package:trackyond/core/common/widgets/image/app_image.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/activity_message_card.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/bubble_time_and_status.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/chat_bubble_layout.dart';

class MessageBubble extends StatelessWidget {
  final JobChatMessageEntity message;
  final bool hasSameSenderAbove;
  final bool hasSameSenderBelow;

  const MessageBubble({
    super.key,
    required this.message,
    this.hasSameSenderAbove = false,
    this.hasSameSenderBelow = false,
  });

  @override
  Widget build(BuildContext context) {
    final activityContentIndex = message.content.indexWhere(
      (c) => c.type == 'activity',
    );

    final isActivityMessage = message.type == 'activity';

    if (isActivityMessage || activityContentIndex != -1) {
      final content = isActivityMessage
          ? message.content.firstWhere(
              (c) => c.type == 'text',
              orElse: () => message.content.first,
            )
          : message.content[activityContentIndex];
      return ActivityMessageCard(
        message: message,
        content: content,
        hasSameSenderAbove: hasSameSenderAbove,
        hasSameSenderBelow: hasSameSenderBelow,
      );
    }

    final isMe = message.isMe;
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.textTheme;

    final chatController = Get.find<JobChatController>();
    final senderName = chatController.getSenderName(message);
    final senderImage = chatController.getSenderImage(message);

    final double softRadius = AppUIConstants.radius.radius$16;
    final double hardRadius = 2.0; // Slightly rounded hard edge

    final double topLeftRadius = (!isMe && hasSameSenderAbove)
        ? hardRadius
        : softRadius;
    final double bottomLeftRadius = (!isMe && hasSameSenderBelow)
        ? hardRadius
        : softRadius;
    final double topRightRadius = (isMe && hasSameSenderAbove)
        ? hardRadius
        : softRadius;
    final double bottomRightRadius = (isMe && hasSameSenderBelow)
        ? hardRadius
        : softRadius;

    final bubbleContent = Builder(
      builder: (context) {
        final validContents =
            message.content
                .where(
                  (c) =>
                      c.type == 'text' ||
                      c.type == 'image' ||
                      c.type == 'activity',
                )
                .toList()
              ..sort((a, b) {
                if (a.type == 'image' && b.type != 'image') return -1;
                if (a.type != 'image' && b.type == 'image') return 1;
                return 0;
              });
        final List<Widget> children = [];

        final replyContent = message.content.firstWhereOrNull(
          (c) => c.type == 'refer/reply',
        );

        if (replyContent != null) {
          final metadata = replyContent.metadata ?? {};
          final replyToUid = metadata['messageUid'] as String? ?? '';
          final replySenderId = metadata['senderId'] as String? ?? '';
          final replySenderName = metadata['senderName'] as String? ?? '';
          final replyType = metadata['type'] as String? ?? 'message';
          final replyImageUrl = metadata['imageUrl'] as String?;

          final replyToMe = replySenderId == chatController.currentUserId;
          final displayName = replyToMe ? 'You' : replySenderName;

          Widget replyBodyWidget;
          if (replyType == 'activity') {
            final activityType = metadata['activityType'] as String? ?? '';
            String activityTitle = 'Activity Update';
            IconData activityIcon = Icons.info_outline;

            switch (activityType) {
              case 'job_created':
                activityTitle = AppStrings.jobChat.activityJobAssigned;
                activityIcon = AppIcons.jobs.work;
                break;
              case 'reached_location':
                activityTitle = AppStrings.jobChat.activityReachedSite;
                activityIcon = AppIcons.jobs.checkIn;
                break;
              case 'started_job':
                activityTitle = AppStrings.jobChat.activityJobStarted;
                activityIcon = AppIcons.common.play;
                break;
              case 'completed_job':
                activityTitle = AppStrings.jobChat.activityJobCompleted;
                activityIcon = AppIcons.status.success;
                break;
              case 'take_break':
                activityTitle = AppStrings.jobChat.activityOnBreak;
                activityIcon = AppIcons.jobs.coffee;
                break;
              case 'break_out':
                activityTitle = AppStrings.jobChat.activityBreakEnded;
                activityIcon = AppIcons.common.play;
                break;
              case 'send_location':
                activityTitle = AppStrings.jobChat.activityLocationShared;
                activityIcon = AppIcons.jobs.myLocation;
                break;
              case 'ask_location':
                activityTitle = AppStrings.jobChat.activityLocationRequested;
                activityIcon = AppIcons.jobs.locationSearching;
                break;
              case 'ask_status':
                activityTitle = AppStrings.jobChat.activityStatusRequested;
                activityIcon = AppIcons.jobs.statusQuestion;
                break;
              case 'ask_status_proofs':
                activityTitle =
                    AppStrings.jobChat.activityStatusProofsRequested;
                activityIcon = AppIcons.jobs.cameraOutlined;
                break;
              case 'cancel_job':
                activityTitle = AppStrings.jobChat.activityJobCancelled;
                activityIcon = AppIcons.dashboard.cancelled;
                break;
              case 'reopen_job':
                activityTitle = AppStrings.jobChat.activityJobReopened;
                activityIcon = AppIcons.common.refresh;
                break;
            }
            replyBodyWidget = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  activityIcon,
                  size: 14,
                  color: isMe
                      ? colorScheme.onPrimary.withValues(alpha: 0.7)
                      : colorScheme.primary,
                ),
                AppUIConstants.widgets.horizontalBox$4,
                Flexible(
                  child: Text(
                    activityTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: isMe
                          ? colorScheme.onPrimary.withValues(alpha: 0.8)
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            );
          } else if (replyImageUrl != null) {
            replyBodyWidget = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.photo,
                  size: 14,
                  color: isMe
                      ? colorScheme.onPrimary.withValues(alpha: 0.7)
                      : colorScheme.primary,
                ),
                AppUIConstants.widgets.horizontalBox$4,
                Text(
                  'Photo',
                  style: textTheme.bodySmall?.copyWith(
                    color: isMe
                        ? colorScheme.onPrimary.withValues(alpha: 0.8)
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            );
          } else {
            replyBodyWidget = Text(
              replyContent.content ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall?.copyWith(
                color: isMe
                    ? colorScheme.onPrimary.withValues(alpha: 0.8)
                    : colorScheme.onSurfaceVariant,
              ),
            );
          }

          children.add(
            Padding(
              padding: const EdgeInsets.all(4),
              child: GestureDetector(
                onTap: () => chatController.scrollToMessage(replyToUid),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isMe
                          ? colorScheme.onPrimary.withValues(alpha: 0.15)
                          : colorScheme.primary.withValues(alpha: 0.08),
                      border: Border(
                        left: BorderSide(
                          color: isMe
                              ? colorScheme.onPrimary
                              : colorScheme.primary,
                          width: 4,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (replyImageUrl != null) ...[
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: AppImage(
                                imageUrl: replyImageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          AppUIConstants.widgets.horizontalBox$8,
                        ],
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                displayName,
                                style: textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isMe
                                      ? colorScheme.onPrimary
                                      : colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 2), // sub-pixel nudge
                              replyBodyWidget,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        for (int i = 0; i < validContents.length; i++) {
          final content = validContents[i];
          final isLast = i == validContents.length - 1;

          if (content.type == 'image') {
            final url = content.metadata?['url'] ?? '';
            final fileMetadata =
                content.metadata?['fileMetadata'] as Map<String, dynamic>?;
            final imageMetadata =
                fileMetadata?['imageMetadata'] as Map<String, dynamic>?;
            final width =
                (imageMetadata?['width'] ?? content.metadata?['width']) as num?;
            final height =
                (imageMetadata?['height'] ?? content.metadata?['height'])
                    as num?;

            Widget imgWidget = AppImage(
              imageUrl: url,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 200,
                height: 150,
                color: colorScheme.surfaceDim,
                child: Center(
                  child: CircularProgressIndicator(
                    color: isMe ? colorScheme.onPrimary : colorScheme.primary,
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 200,
                height: 150,
                color: colorScheme.surfaceDim,
                child: const Center(child: Icon(Icons.error_outline)),
              ),
            );

            if (width != null && height != null && height > 0) {
              double calculatedAspectRatio = width / height;
              if (calculatedAspectRatio < 0.8) {
                calculatedAspectRatio = 0.8;
              }
              imgWidget = SizedBox(
                width: 240,
                child: AspectRatio(
                  aspectRatio: calculatedAspectRatio,
                  child: imgWidget,
                ),
              );
            } else {
              imgWidget = SizedBox(width: 200, height: 150, child: imgWidget);
            }

            final double topPad = (i == 0 && replyContent == null) ? 6.0 : 4.0;
            final double bottomPad = isLast ? 6.0 : 4.0;
            children.add(
              Padding(
                padding: EdgeInsets.fromLTRB(6.0, topPad, 6.0, bottomPad),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppUIConstants.radius.radius$8,
                  ),
                  child: imgWidget,
                ),
              ),
            );
          } else {
            final textWidget = RichText(
              text: TextSpan(
                children: chatController.parseMentionsToSpans(
                  content.content ?? '',
                  textTheme.bodyMedium?.copyWith(
                    color: isMe ? colorScheme.onPrimary : colorScheme.onSurface,
                  ),
                  textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isMe ? colorScheme.onPrimary : colorScheme.primary,
                  ),
                ),
              ),
            );

            final double topPad = (i == 0 && replyContent == null) ? 8.0 : 4.0;
            final double bottomPad = isLast ? 8.0 : 4.0;

            if (isLast) {
              children.add(
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, topPad, 12.0, bottomPad),
                  child: ChatBubbleLayout(
                    text: textWidget,
                    time: BubbleTimeAndStatus(
                      timestamp: message.timestamp,
                      isMe: isMe,
                    ),
                  ),
                ),
              );
            } else {
              children.add(
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, topPad, 12.0, bottomPad),
                  child: textWidget,
                ),
              );
            }
          }
        }

        final hasLastText =
            validContents.isNotEmpty &&
            (validContents.last.type == 'text' ||
                validContents.last.type == 'activity');
        if (!hasLastText && validContents.isNotEmpty) {
          children.add(
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 12.0,
                  bottom: 8.0,
                  top: 4.0,
                ),
                child: BubbleTimeAndStatus(
                  timestamp: message.timestamp,
                  isMe: isMe,
                ),
              ),
            ),
          );
        }

        final hasImage = validContents.any((c) => c.type == 'image');

        if (hasImage) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: children,
          );
        }

        return IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        );
      },
    );

    if (isMe) {
      return Align(
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(
                left: AppUIConstants.spacing.space$48,
                right: 0,
              ),
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(topLeftRadius),
                  topRight: Radius.circular(topRightRadius),
                  bottomLeft: Radius.circular(bottomLeftRadius),
                  bottomRight: Radius.circular(bottomRightRadius),
                ),
                boxShadow: AppUIConstants.shadows.xs,
              ),
              child: bubbleContent,
            ),
          ],
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!hasSameSenderAbove)
              Padding(
                padding: const EdgeInsets.only(
                  left: 36,
                  // Aligned with start of bubble (28 avatar + 8 spacing)
                  bottom: 4,
                ),
                child: Text(
                  senderName,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!hasSameSenderAbove)
                  MemberAvatar(
                    name: senderName,
                    image: senderImage,
                    radius: 14, // Standard avatar radius (28px width)
                  )
                else
                  SizedBox(width: AppUIConstants.spacing.space$28),
                // Spacer representing the avatar width
                AppUIConstants.widgets.horizontalBox$8,
                // Spacing between avatar and bubble
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(topLeftRadius),
                          topRight: Radius.circular(topRightRadius),
                          bottomLeft: Radius.circular(bottomLeftRadius),
                          bottomRight: Radius.circular(bottomRightRadius),
                        ),
                        boxShadow: AppUIConstants.shadows.xs,
                      ),
                      child: bubbleContent,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
