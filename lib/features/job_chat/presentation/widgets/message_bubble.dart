import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MessageBubble extends StatelessWidget {
  final JobChatMessageEntity message;

  const MessageBubble({super.key, required this.message});

  Widget _buildLocationCard(
    BuildContext context,
    dynamic content,
    bool isMe,
  ) {
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.textTheme;
    final metadata = content.metadata ?? {};
    final address = metadata['address'] as String? ?? 'No address acquired';
    final workerName =
        metadata['workerName'] as String? ?? message.senderName ?? 'Worker';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isMe ? AppUIConstants.spacing.space$48 : 0,
          right: isMe ? 0 : AppUIConstants.spacing.space$48,
          bottom: AppUIConstants.spacing.space$8,
        ),
        width: 300,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.15),
            width: 1.5,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppUIConstants.radius.radius$16),
            topRight: Radius.circular(AppUIConstants.radius.radius$16),
            bottomLeft:
                Radius.circular(isMe ? AppUIConstants.radius.radius$16 : 0),
            bottomRight:
                Radius.circular(isMe ? 0 : AppUIConstants.radius.radius$16),
          ),
          boxShadow: AppUIConstants.shadows.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppUIConstants.spacing.space$8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      AppIcons.jobs.checkIn,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: AppUIConstants.spacing.space$8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reached Site',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        Text(
                          workerName,
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    DateFormat('hh:mm a').format(message.timestamp),
                    style: textTheme.labelSmall?.copyWith(
                      fontSize: 10,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppUIConstants.spacing.space$12,
              ),
              child: Text(
                content.message ?? "I'have reached at the location",
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            AppUIConstants.widgets.verticalBox$8,
            const Divider(height: 1),
            Container(
              padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
              decoration: BoxDecoration(
                color:
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    isMe ? AppUIConstants.radius.radius$16 : 0,
                  ),
                  bottomRight: Radius.circular(
                    isMe ? 0 : AppUIConstants.radius.radius$16,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    AppIcons.jobs.locationPinFilled,
                    color: colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: AppUIConstants.spacing.space$8),
                  Expanded(
                    child: Text(
                      address,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reachedLocationContentIndex = message.contents.indexWhere((c) =>
        c.type == 'activity' &&
        c.metadata?['activity_type'] == 'reached_location');

    if (reachedLocationContentIndex != -1) {
      final content = message.contents[reachedLocationContentIndex];
      return _buildLocationCard(context, content, message.isMe);
    }

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
