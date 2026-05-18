import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_type.dart';

class TimelineEntry extends GetView<JobChatController> {
  final JobChatMessageEntity message;

  const TimelineEntry({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.textTheme;

    return Container(
      margin: EdgeInsets.symmetric(vertical: AppUIConstants.spacing.space$16),
      child: Column(
        children: [
          ...message.contents.map((content) {
            final type = JobChatMessageType.fromString(content.type);
            
            if (type == JobChatMessageType.activity || type == JobChatMessageType.header) {
              final isHeader = type == JobChatMessageType.header;
              
              final baseStyle = textTheme.labelSmall?.copyWith(
                color: isHeader ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
                fontStyle: isHeader ? FontStyle.normal : FontStyle.italic,
              );
                  
              final mentionStyle = baseStyle?.copyWith(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                color: colorScheme.primary,
              );

              return Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: AppUIConstants.spacing.space$4),
                padding: EdgeInsets.symmetric(
                  horizontal: AppUIConstants.spacing.space$12,
                  vertical: AppUIConstants.spacing.space$4,
                ),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: controller.parseMentionsToSpans(content.message, baseStyle, mentionStyle),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          AppUIConstants.widgets.verticalBox$4,
          Text(
            DateFormat('dd MMM, hh:mm a').format(message.timestamp),
            style: textTheme.labelSmall?.copyWith(
              fontSize: 9,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
