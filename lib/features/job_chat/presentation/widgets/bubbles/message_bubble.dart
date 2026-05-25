import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/core/common/widgets/image/app_image.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/chat_bubble_layout.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/bubble_time_and_status.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/bubbles/activity_message_card.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';

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

    final double topLeftRadius = (!isMe && hasSameSenderAbove) ? hardRadius : softRadius;
    final double bottomLeftRadius = (!isMe && hasSameSenderBelow) ? hardRadius : softRadius;
    final double topRightRadius = (isMe && hasSameSenderAbove) ? hardRadius : softRadius;
    final double bottomRightRadius = (isMe && hasSameSenderBelow) ? hardRadius : softRadius;

    final bubbleContent = Builder(
      builder: (context) {
        final validContents = message.content
            .where((c) =>
                c.type == 'text' ||
                c.type == 'image' ||
                c.type == 'activity')
            .toList();
        final List<Widget> children = [];

        for (int i = 0; i < validContents.length; i++) {
          final content = validContents[i];
          final isLast = i == validContents.length - 1;

          if (content.type == 'image') {
            final url = content.metadata?['url'] ?? '';
            final fileMetadata = content.metadata?['fileMetadata'] as Map<String, dynamic>?;
            final imageMetadata = fileMetadata?['imageMetadata'] as Map<String, dynamic>?;
            final width = (imageMetadata?['width'] ?? content.metadata?['width']) as num?;
            final height = (imageMetadata?['height'] ?? content.metadata?['height']) as num?;

            Widget imgWidget = AppImage(
              imageUrl: url,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 200,
                height: 150,
                color: colorScheme.surfaceDim,
                child: Center(
                  child: CircularProgressIndicator(
                    color: isMe
                        ? colorScheme.onPrimary
                        : colorScheme.primary,
                    strokeWidth: 2,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: 200,
                height: 150,
                color: colorScheme.surfaceDim,
                child: const Center(
                  child: Icon(Icons.error_outline),
                ),
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
              imgWidget = SizedBox(
                width: 200,
                height: 150,
                child: imgWidget,
              );
            }

            children.add(
              Padding(
                padding: EdgeInsets.only(
                  bottom: isLast ? 0 : AppUIConstants.spacing.space$4,
                ),
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
                    color: isMe
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                  ),
                  textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isMe
                        ? colorScheme.onPrimary
                        : colorScheme.primary,
                  ),
                ),
              ),
            );

            if (isLast) {
              children.add(
                ChatBubbleLayout(
                  text: textWidget,
                  time: BubbleTimeAndStatus(
                    timestamp: message.timestamp,
                    isMe: isMe,
                  ),
                ),
              );
            } else {
              children.add(
                Padding(
                  padding: EdgeInsets.only(
                    bottom: AppUIConstants.spacing.space$4,
                  ),
                  child: textWidget,
                ),
              );
            }
          }
        }

        final hasLastText = validContents.isNotEmpty &&
            (validContents.last.type == 'text' ||
                validContents.last.type == 'activity');
        if (!hasLastText && validContents.isNotEmpty) {
          children.add(
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(
                    top: AppUIConstants.spacing.space$4),
                child: BubbleTimeAndStatus(
                  timestamp: message.timestamp,
                  isMe: isMe,
                ),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: children,
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
              padding: EdgeInsets.symmetric(
                horizontal: AppUIConstants.spacing.space$12,
                vertical: AppUIConstants.spacing.space$8,
              ),
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
                  left: 36, // Aligned with start of bubble (28 avatar + 8 spacing)
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
                  const SizedBox(width: 28), // Spacer representing the avatar width
                const SizedBox(width: 8), // Spacing between avatar and bubble
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppUIConstants.spacing.space$12,
                        vertical: AppUIConstants.spacing.space$8,
                      ),
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
