import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MessageBubble extends StatelessWidget {
  final JobChatMessageEntity message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.textTheme;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isMe ? AppUIConstants.spacing.space$48 : 0,
          right: isMe ? 0 : AppUIConstants.spacing.space$48,
          bottom: AppUIConstants.spacing.space$8,
        ),
        padding: EdgeInsets.all(AppUIConstants.spacing.space$8),
        decoration: BoxDecoration(
          color: isMe ? colorScheme.primary : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppUIConstants.radius.radius$16),
            topRight: Radius.circular(AppUIConstants.radius.radius$16),
            bottomLeft: Radius.circular(isMe ? AppUIConstants.radius.radius$16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : AppUIConstants.radius.radius$16),
          ),
          boxShadow: AppUIConstants.shadows.xs,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isMe && message.senderName != null)
              Padding(
                padding: EdgeInsets.only(bottom: AppUIConstants.spacing.space$4),
                child: Text(
                  message.senderName!,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ...message.contents.map((content) {
              if (content.type == 'image') {
                final url = content.metadata?['url'] ?? '';
                return Padding(
                  padding: EdgeInsets.only(bottom: AppUIConstants.spacing.space$4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$8),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      placeholder: (context, url) => Container(
                        width: 200,
                        height: 150,
                        color: colorScheme.surfaceDim,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                );
              } else if (content.type == 'text') {
                return Padding(
                  padding: EdgeInsets.only(bottom: AppUIConstants.spacing.space$4),
                  child: Text(
                    content.message ?? '',
                    style: textTheme.bodyMedium?.copyWith(
                      color: isMe ? colorScheme.onPrimary : colorScheme.onSurface,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }).where((e) => e != const SizedBox.shrink()),
            AppUIConstants.widgets.verticalBox$4,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('hh:mm a').format(message.timestamp),
                  style: textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    color: isMe
                        ? colorScheme.onPrimary.withValues(alpha: 0.7)
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                if (isMe) ...[
                  AppUIConstants.widgets.horizontalBox$4,
                  Icon(
                    Icons.done_all,
                    size: 14,
                    color: colorScheme.onPrimary.withValues(alpha: 0.7),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
