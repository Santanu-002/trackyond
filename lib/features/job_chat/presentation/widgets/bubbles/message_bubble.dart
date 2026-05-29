import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/job_activity_type.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/activity_message_card.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/bubble_time_and_status.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/chat_image_grid/chat_image_grid.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/reply_image_thumbnail.dart';
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

    final double screenWidth = context.width;
    final double maxBubbleWidth = isMe
        ? (screenWidth - 84).clamp(240.0, 310.0)
        : (screenWidth - 104).clamp(240.0, 310.0);

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
          (c) => c.type == 'reply',
        );

        if (replyContent != null) {
          final metadata = replyContent.metadata ?? {};
          final replyToUid = metadata['messageUid'] as String? ?? '';
          final replySenderId = metadata['senderId'] as String? ?? '';
          final replySenderProfileUid = metadata['senderProfileUid'] as String?;
          final replySenderName = metadata['senderName'] as String? ?? '';
          final replyType = metadata['type'] as String? ?? 'message';
          final replyImageUrl = metadata['imageUrl'] as String?;

          final resolvedSenderName = chatController.resolveMemberName(
            replySenderId.isEmpty ? null : replySenderId,
            replySenderProfileUid,
            replySenderName,
          );
          final replyToMe = replySenderId == chatController.currentUserId;
          final displayName = replyToMe ? 'You' : resolvedSenderName;

          Widget replyBodyWidget;
          if (replyType == 'activity') {
            final activityType = JobActivityType.fromString(metadata['activityType']);
            String activityTitle = 'Activity Update';
            IconData activityIcon = Icons.info_outline;

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
                activityTitle =
                    AppStrings.jobChat.activityStatusProofsRequested;
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
                      fontSize: 12,
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
                    fontSize: 12,
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
                fontSize: 12,
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
                          ReplyImageThumbnail(
                            imageUrl: replyImageUrl,
                            blurHash: metadata['blurHash'] as String? ??
                                metadata['blur_hash'] as String?,
                            remainingCount: metadata['remainingImageCount'] as int? ?? 0,
                            size: 30.0,
                            borderRadius: 2.0,
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
                                style: textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
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

        final imageContents = validContents.where((c) => c.type == 'image').toList();
        final videoContents = validContents.where((c) => c.type == 'video').toList();
        final docContents = validContents.where((c) => c.type == 'docs').toList();
        final textContents = validContents
            .where((c) => c.type != 'image' && c.type != 'video' && c.type != 'docs')
            .toList();

        if (imageContents.isNotEmpty) {
          final double topPad = (replyContent == null) ? 6.0 : 4.0;
          final isLast = textContents.isEmpty && videoContents.isEmpty && docContents.isEmpty;
          final double bottomPad = isLast ? 6.0 : 4.0;
          children.add(
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppUIConstants.spacing.space$4,
                topPad,
                AppUIConstants.spacing.space$4,
                bottomPad,
              ),
              child: ChatImageGrid(
                message: message,
                imageContents: imageContents,
                isMe: isMe,
                width: 240,
              ),
            ),
          );
        }

        if (videoContents.isNotEmpty) {
          for (final video in videoContents) {
            final fileMeta = video.metadata?['fileMetadata'] as Map<String, dynamic>?;
            final duration = fileMeta?['videoMetaData']?['duration'] as String? ?? '0:00';
            final fileName = fileMeta?['fileName'] as String? ?? 'Video';
            final url = video.metadata?['url'] as String? ?? '';
            
            children.add(
              GestureDetector(
                onTap: () {
                  AppSnackbar.info('Playing video: $fileName ($duration)');
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppUIConstants.spacing.space$8,
                    vertical: AppUIConstants.spacing.space$4,
                  ),
                  child: Container(
                    width: 240,
                    height: 150,
                    decoration: BoxDecoration(
                      color: colorScheme.black.withValues(alpha: 0.87),
                      borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$12),
                      image: url.isNotEmpty && url.contains('http')
                          ? DecorationImage(
                              image: NetworkImage('https://picsum.photos/400/300?random=video'),
                              fit: BoxFit.cover,
                              opacity: 0.6,
                            )
                          : null,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Play Button
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: colorScheme.black.withValues(alpha: 0.54),
                            shape: BoxShape.circle,
                            border: Border.all(color: colorScheme.onPrimary, width: 2),
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: colorScheme.onPrimary,
                            size: 32,
                          ),
                        ),
                        // Duration badge bottom right
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: colorScheme.black.withValues(alpha: 0.87),
                              borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.videocam, color: colorScheme.onPrimary, size: 12),
                                AppUIConstants.widgets.horizontalBox$4,
                                Text(
                                  duration,
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onPrimary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        }

        if (docContents.isNotEmpty) {
          for (final doc in docContents) {
            final fileMeta = doc.metadata?['fileMetadata'] as Map<String, dynamic>?;
            final fileName = fileMeta?['fileName'] as String? ?? doc.content ?? 'Document';
            final fileSize = fileMeta?['size'] as String? ?? 'Unknown size';
            final mimeType = fileMeta?['mimeType'] as String? ?? '';
            final isPdf = mimeType.contains('pdf') || fileName.toLowerCase().endsWith('.pdf');

            final docIcon = isPdf ? Icons.picture_as_pdf : Icons.description;
            final docIconColor = isPdf ? colorScheme.attachmentPdf : colorScheme.attachmentDocs;

            children.add(
              GestureDetector(
                onTap: () {
                  AppSnackbar.success('Opening document: $fileName');
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppUIConstants.spacing.space$8,
                    vertical: AppUIConstants.spacing.space$4,
                  ),
                  child: Container(
                    width: 240,
                    padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
                    decoration: BoxDecoration(
                      color: isMe 
                          ? colorScheme.onPrimary.withValues(alpha: 0.1) 
                          : colorScheme.onSurface.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$12),
                      border: Border.all(
                        color: isMe 
                            ? colorScheme.onPrimary.withValues(alpha: 0.2) 
                            : colorScheme.outlineVariant,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(AppUIConstants.spacing.space$8),
                          decoration: BoxDecoration(
                            color: docIconColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$8),
                          ),
                          child: Icon(
                            docIcon,
                            color: docIconColor,
                            size: 28,
                          ),
                        ),
                        AppUIConstants.widgets.horizontalBox$12,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fileName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isMe ? colorScheme.onPrimary : colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                fileSize,
                                style: textTheme.bodySmall?.copyWith(
                                  color: isMe 
                                      ? colorScheme.onPrimary.withValues(alpha: 0.7) 
                                      : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.open_in_new,
                          color: isMe 
                              ? colorScheme.onPrimary.withValues(alpha: 0.6) 
                              : colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        }

        for (int i = 0; i < textContents.length; i++) {
          final content = textContents[i];
          final isLast = i == textContents.length - 1;

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

          final double topPad = (i == 0 && imageContents.isEmpty && videoContents.isEmpty && docContents.isEmpty && replyContent == null) ? 8.0 : 4.0;
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

        final hasMedia = validContents.any((c) => c.type == 'image' || c.type == 'video' || c.type == 'docs');

        if (hasMedia) {
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
              constraints: BoxConstraints(maxWidth: maxBubbleWidth),
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
                      constraints: BoxConstraints(maxWidth: maxBubbleWidth),
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
