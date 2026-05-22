import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';

class LocationMessageCard extends StatelessWidget {
  final JobChatMessageEntity message;
  final JobChatMessageContentEntity content;
  final bool hasSameSenderAbove;
  final bool hasSameSenderBelow;

  const LocationMessageCard({
    super.key,
    required this.message,
    required this.content,
    this.hasSameSenderAbove = false,
    this.hasSameSenderBelow = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.textTheme;
    final metadata = message.metadata ?? {};
    final address = metadata['address'] as String? ?? 'No address acquired';
    final workerName = metadata['workerName'] as String? ?? message.senderName;

    final double softRadius = AppUIConstants.radius.radius$16;
    final double hardRadius = 2.0;

    final double topLeftRadius = (!isMe && hasSameSenderAbove) ? hardRadius : softRadius;
    final double bottomLeftRadius = (!isMe && hasSameSenderBelow) ? hardRadius : softRadius;
    final double topRightRadius = (isMe && hasSameSenderAbove) ? hardRadius : softRadius;
    final double bottomRightRadius = (isMe && hasSameSenderBelow) ? hardRadius : softRadius;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isMe ? AppUIConstants.spacing.space$48 : 0,
          right: isMe ? 0 : AppUIConstants.spacing.space$48,
        ),
        width: 300,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.15),
            width: 1.5,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topLeftRadius),
            topRight: Radius.circular(topRightRadius),
            bottomLeft: Radius.circular(bottomLeftRadius),
            bottomRight: Radius.circular(bottomRightRadius),
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
                  AppUIConstants.widgets.horizontalBox$8,
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
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppUIConstants.spacing.space$12,
              ),
              child: Text(
                content.content ?? "I've reached the location",
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
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(bottomLeftRadius),
                  bottomRight: Radius.circular(bottomRightRadius),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        AppIcons.dashboard.clock,
                        color: colorScheme.primary,
                        size: 16,
                      ),
                      AppUIConstants.widgets.horizontalBox$8,
                      Text(
                        DateFormat('hh:mm a').format(message.timestamp),
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  AppUIConstants.widgets.verticalBox$4,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        AppIcons.jobs.locationPinFilled,
                        color: colorScheme.primary,
                        size: 16,
                      ),
                      AppUIConstants.widgets.horizontalBox$8,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
