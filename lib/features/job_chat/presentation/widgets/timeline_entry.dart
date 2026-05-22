import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_type.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';

class TimelineEntry extends GetView<JobChatController> {
  final JobChatMessageEntity message;

  const TimelineEntry({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.textTheme;

    return Column(
      children: [
        ...message.content.map((content) {
          final type = JobChatMessageType.fromString(content.type);

          if (type == JobChatMessageType.activity ||
              type == JobChatMessageType.header) {
            final baseStyle = textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            );

            final mentionStyle = baseStyle?.copyWith(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
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
                  children: controller.parseMentionsToSpans(
                    content.content ?? '',
                    baseStyle,
                    mentionStyle,
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}
