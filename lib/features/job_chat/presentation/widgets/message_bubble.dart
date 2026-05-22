import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/chat_bubble_layout.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/components/bubble_time_and_status.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/message_types/location_message_card.dart';

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
    final reachedLocationContentIndex = message.content.indexWhere(
      (c) =>
          c.type == 'activity' &&
          c.metadata?['activity_type'] == 'reached_location',
    );

    final isNewReachedLocation = message.type == 'activity' &&
        message.metadata?['activity_type'] == 'reached_location';

    if (isNewReachedLocation || reachedLocationContentIndex != -1) {
      final content = isNewReachedLocation
          ? message.content.firstWhere(
              (c) => c.type == 'text',
              orElse: () => message.content.first,
            )
          : message.content[reachedLocationContentIndex];
      return LocationMessageCard(
        message: message,
        content: content,
        hasSameSenderAbove: hasSameSenderAbove,
        hasSameSenderBelow: hasSameSenderBelow,
      );
    }

    final isMe = message.isMe;
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.textTheme;

    final double softRadius = AppUIConstants.radius.radius$16;
    final double hardRadius = 2.0; // Slightly rounded hard edge

    final double topLeftRadius = (!isMe && hasSameSenderAbove) ? hardRadius : softRadius;
    final double bottomLeftRadius = (!isMe && hasSameSenderBelow) ? hardRadius : softRadius;
    final double topRightRadius = (isMe && hasSameSenderAbove) ? hardRadius : softRadius;
    final double bottomRightRadius = (isMe && hasSameSenderBelow) ? hardRadius : softRadius;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe && !hasSameSenderAbove)
            Padding(
              padding: EdgeInsets.only(
                left: AppUIConstants.spacing.space$12,
                bottom: AppUIConstants.spacing.space$4,
              ),
              child: Text(
                message.senderName,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Container(
            margin: EdgeInsets.only(
              left: isMe ? AppUIConstants.spacing.space$48 : 0,
              right: isMe ? 0 : AppUIConstants.spacing.space$48,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppUIConstants.spacing.space$12,
              vertical: AppUIConstants.spacing.space$8,
            ),
            decoration: BoxDecoration(
              color: isMe
                  ? colorScheme.primary
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(topLeftRadius),
                topRight: Radius.circular(topRightRadius),
                bottomLeft: Radius.circular(bottomLeftRadius),
                bottomRight: Radius.circular(bottomRightRadius),
              ),
              boxShadow: AppUIConstants.shadows.xs,
            ),
            child: Builder(
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
                    children.add(
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: isLast ? 0 : AppUIConstants.spacing.space$4,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppUIConstants.radius.radius$8,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: url,
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
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    );
                  } else {
                    final textWidget = Text(
                      content.content ?? '',
                      style: textTheme.bodyMedium?.copyWith(
                        color: isMe
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
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
            ),
          ),
        ],
      ),
    );
  }
}

