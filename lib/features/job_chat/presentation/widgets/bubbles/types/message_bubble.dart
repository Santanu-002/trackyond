import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/activity/activity_message_card.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/layout/bubble_time_and_status.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/types/chat_image_grid/chat_image_grid.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/layout/reply_image_thumbnail.dart';
import 'package:trackyond/features/job_chat/data/models/response/chat_message_metadata_model.dart';
import 'package:trackyond/core/common/enums/job_activity_type.dart';
import 'package:trackyond/core/common/enums/job_chat_message_type.dart';
import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/layout/chat_bubble_layout.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/types/document_bubble_item.dart';
import 'package:trackyond/core/common/enums/job_chat_message_status.dart';

import 'package:trackyond/core/network/api/api_endpoints.dart';

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
      (c) => c.type == JobChatMessageContentType.activity,
    );

    final isActivityMessage = message.type == JobChatMessageType.activity;

    if ((isActivityMessage || activityContentIndex != -1) && !message.deleted) {
      final content = isActivityMessage
          ? (message.content.firstWhereOrNull(
                (c) => c.type == JobChatMessageContentType.text,
              ) ??
              message.content.first)
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
        if (message.deleted) {
          final displayText = message.deletedByUserType == 'owner'
              ? AppStrings.jobChat.messageRemovedByAdmin
              : AppStrings.jobChat.messageRemoved;

          final contentColor = isMe
              ? colorScheme.onPrimary.withValues(alpha: 0.76)
              : colorScheme.onSurfaceVariant.withValues(alpha: 0.6);

          return Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
            child: ChatBubbleLayout(
              text: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.block,
                    size: 16,
                    color: contentColor.withValues(alpha: 0.6),
                  ),
                  AppUIConstants.widgets.horizontalBox$4,
                  Flexible(
                    child: Text(
                      displayText,
                      style: textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: contentColor,
                      ),
                    ),
                  ),
                ],
              ),
              time: const SizedBox.shrink(),
            ),
          );
        }

        final validContents =
            message.content
                .where(
                  (c) =>
                      c.type == JobChatMessageContentType.text ||
                      c.type == JobChatMessageContentType.image ||
                      c.type == JobChatMessageContentType.video ||
                      c.type == JobChatMessageContentType.document ||
                      c.type == JobChatMessageContentType.pdf ||
                      c.type == JobChatMessageContentType.activity,
                )
                .toList()
              ..sort((a, b) {
                if (a.type == JobChatMessageContentType.image && b.type != JobChatMessageContentType.image) return -1;
                if (a.type != JobChatMessageContentType.image && b.type == JobChatMessageContentType.image) return 1;
                return 0;
              });
        final List<Widget> children = [];

        final replyContent = message.content.firstWhereOrNull(
          (c) => c.type == JobChatMessageContentType.reply,
        );

        if (replyContent != null) {
          final dynamic rawMetadata = replyContent.metadata;
          final Map<String, dynamic> metadata = rawMetadata is ChatMessageMetadataModel
              ? (rawMetadata.replyMetadata?.toJson() ?? {})
              : (rawMetadata is Map
                  ? (rawMetadata['replyMetadata'] is Map
                      ? Map<String, dynamic>.from(rawMetadata['replyMetadata'] as Map)
                      : Map<String, dynamic>.from(rawMetadata))
                  : {});
          final replyToUid = metadata['messageUid'] as String? ?? '';
          final replySenderUid = metadata['senderUid'] as String?;
          final replySenderName = metadata['senderName'] as String? ?? '';
          final replyType = JobChatMessageType.fromString(metadata['type'] as String?);
          final contentTypeStr = metadata['contentType'] as String?;
          final contentType = JobChatMessageContentType.fromString(contentTypeStr);
          final mediaUrl = metadata['mediaUrl'] as String?;
          final replyBlurHash = metadata['blurHash'] as String?;
          final remainingMediaCount = metadata['remainingMediaCount'] as int? ?? 0;

          final originalMsg = chatController.messages.firstWhereOrNull((m) => m.uid == replyToUid);
          final isActivity = replyType == JobChatMessageType.activity || originalMsg?.type == JobChatMessageType.activity;

          // --- Name resolution matching ReplyPreviewBar ---
          final replyToMe = replySenderUid == chatController.currentUserProfileUid;
          String displayName;
          if (replyToMe) {
            displayName = 'You';
          } else if (isActivity) {
            // For activity messages senderUid is 'system' which isn't in chatMembers.
            // Resolve the actual person from metadata like ReplyPreviewBar does.
            final metaWorkerName = originalMsg?.metadata?['workerName'] as String?;
            if (metaWorkerName != null && metaWorkerName.isNotEmpty) {
              displayName = metaWorkerName;
            } else {
              final resolved = chatController.resolveMemberName(replySenderUid, replySenderName);
              if (resolved == 'System' || resolved.isEmpty) {
                final activityTypeStr = metadata['activityType'] as String? ?? originalMsg?.metadata?['activityType'] as String?;
                final aType = JobActivityType.fromString(activityTypeStr);
                final isOwnerAction =
                    aType == JobActivityType.askLocation ||
                    aType == JobActivityType.askStatus ||
                    aType == JobActivityType.askStatusProofs ||
                    aType == JobActivityType.cancelJob ||
                    aType == JobActivityType.reopenJob ||
                    aType == JobActivityType.jobCreated;
                displayName = isOwnerAction
                    ? (chatController.job.createdByName ?? 'Admin')
                    : (chatController.job.workerName ?? 'Worker');
              } else {
                displayName = resolved;
              }
            }
          } else {
            displayName = chatController.resolveMemberName(replySenderUid, replySenderName);
            if (displayName.toLowerCase() == 'user') {
              displayName = chatController.job.workerName ?? 'Worker';
            }
          }

          Widget replyBodyWidget;
          if (isActivity) {
            final activityTypeStr = metadata['activityType'] as String? ?? originalMsg?.metadata?['activityType'] as String?;
            final activityType = JobActivityType.fromString(activityTypeStr);

            replyBodyWidget = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: isMe
                        ? colorScheme.onPrimary.withValues(alpha: 0.15)
                        : colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    activityType.icon,
                    size: 14,
                    color: isMe
                        ? colorScheme.onPrimary.withValues(alpha: 0.7)
                        : colorScheme.primary,
                  ),
                ),
                AppUIConstants.widgets.horizontalBox$4,
                Flexible(
                  child: Text(
                    activityType.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isMe
                          ? colorScheme.onPrimary.withValues(alpha: 0.8)
                          : colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            );
          } else if (contentType == JobChatMessageContentType.image) {
            final displayText = (replyContent.content != null && replyContent.content!.isNotEmpty)
                ? replyContent.content!
                : 'Photo';
            replyBodyWidget = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.photo_outlined,
                  size: 14,
                  color: isMe
                      ? colorScheme.onPrimary.withValues(alpha: 0.7)
                      : colorScheme.primary,
                ),
                AppUIConstants.widgets.horizontalBox$4,
                Flexible(
                  child: Text(
                    displayText,
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
          } else if (contentType == JobChatMessageContentType.video) {
            final displayText = (replyContent.content != null && replyContent.content!.isNotEmpty)
                ? replyContent.content!
                : 'Video';
            replyBodyWidget = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.videocam_outlined,
                  size: 14,
                  color: isMe
                      ? colorScheme.onPrimary.withValues(alpha: 0.7)
                      : colorScheme.primary,
                ),
                AppUIConstants.widgets.horizontalBox$4,
                Flexible(
                  child: Text(
                    displayText,
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
          } else if (contentType == JobChatMessageContentType.document || contentType == JobChatMessageContentType.pdf) {
            replyBodyWidget = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  contentType == JobChatMessageContentType.pdf ? Icons.picture_as_pdf : Icons.description,
                  size: 14,
                  color: isMe
                      ? colorScheme.onPrimary.withValues(alpha: 0.7)
                      : colorScheme.primary,
                ),
                AppUIConstants.widgets.horizontalBox$4,
                Text(
                  contentType == JobChatMessageContentType.pdf ? 'PDF' : 'Document',
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
              chatController.parseMentions(replyContent.content),
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
                        if (mediaUrl != null && (contentType == JobChatMessageContentType.image || contentType == JobChatMessageContentType.video)) ...[
                          ReplyImageThumbnail(
                            imageUrl: mediaUrl.startsWith('http') ? mediaUrl : ApiEndpoints.common.download(mediaUrl),
                            blurHash: replyBlurHash,
                            remainingCount: remainingMediaCount,
                            size: 36.0,
                            borderRadius: AppUIConstants.radius.radius$4,
                            isVideo: contentType == JobChatMessageContentType.video,
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

        final mediaContents = validContents
            .where((c) =>
                c.type == JobChatMessageContentType.image ||
                c.type == JobChatMessageContentType.video)
            .toList();
        final docContents = validContents.where((c) => c.type == JobChatMessageContentType.document || c.type == JobChatMessageContentType.pdf).toList();
        final textContents = validContents
            .where((c) => c.type != JobChatMessageContentType.image && c.type != JobChatMessageContentType.video && c.type != JobChatMessageContentType.document && c.type != JobChatMessageContentType.pdf)
            .toList();

        final isSingleMediaNoCaption = mediaContents.length == 1 &&
            textContents.isEmpty &&
            docContents.isEmpty;

        if (mediaContents.isNotEmpty) {
          children.add(
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4.0,
                vertical: 4.0,
              ),
              child: ChatImageGrid(
                message: message,
                imageContents: mediaContents,
                isMe: isMe,
                width: maxBubbleWidth - 8.0,
                showTimeOverlay: isSingleMediaNoCaption,
              ),
            ),
          );
        }

        if (docContents.isNotEmpty) {
          for (final doc in docContents) {
            children.add(
              DocumentBubbleItem(
                doc: doc,
                isMe: isMe,
                colorScheme: colorScheme,
                textTheme: textTheme,
                messageUid: message.uid,
                isPending: message.status == JobChatMessageStatus.pending,
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

          final double topPad = (i == 0 && mediaContents.isEmpty && docContents.isEmpty && replyContent == null)
              ? 8.0
              : (docContents.isNotEmpty ? 0.0 : 4.0);
          final double bottomPad = isLast ? 8.0 : 4.0;
          final double leftPad = docContents.isNotEmpty ? 12.0 : 8.0;

          if (isLast) {
            children.add(
              Padding(
                padding: EdgeInsets.fromLTRB(leftPad, topPad, 12.0, bottomPad),
                child: ChatBubbleLayout(
                  text: textWidget,
                  time: BubbleTimeAndStatus(
                    timestamp: message.timestamp,
                    isMe: isMe,
                    status: message.status.name,
                  ),
                ),
              ),
            );
          } else {
            children.add(
              Padding(
                padding: EdgeInsets.fromLTRB(leftPad, topPad, 12.0, bottomPad),
                child: textWidget,
              ),
            );
          }
        }

        final hasVisualTextAtBottom = textContents.isNotEmpty;
        final hasNoTextOrDocs = textContents.isEmpty && docContents.isEmpty;
        if (!hasVisualTextAtBottom && validContents.isNotEmpty && !isSingleMediaNoCaption) {
          children.add(
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(
                  right: 12.0,
                  bottom: hasNoTextOrDocs ? 6.0 : 8.0,
                  top: hasNoTextOrDocs ? 0.0 : (textContents.isEmpty ? 0.0 : 4.0),
                ),
                child: BubbleTimeAndStatus(
                  timestamp: message.timestamp,
                  isMe: isMe,
                  status: message.status.name,
                ),
              ),
            ),
          );
        }

        final hasMedia = validContents.any((c) => c.type == JobChatMessageContentType.image || c.type == JobChatMessageContentType.video || c.type == JobChatMessageContentType.document || c.type == JobChatMessageContentType.pdf);

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
                border: null,
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
                        border: null,
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
