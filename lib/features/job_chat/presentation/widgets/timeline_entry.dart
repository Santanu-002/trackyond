import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_type.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/header_card.dart';

class TimelineEntry extends GetView<JobChatController> {
  final JobChatMessageEntity message;

  const TimelineEntry({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.textTheme;

    return Container(
      margin: EdgeInsets.only(
        top: AppUIConstants.spacing.space$4,
        bottom: AppUIConstants.spacing.space$4,
      ),
      child: Column(
        children: [
          ...message.contents.map((content) {
            final type = JobChatMessageType.fromString(content.type);
            
            if (type == JobChatMessageType.activity || type == JobChatMessageType.header) {
              final isHeader = type == JobChatMessageType.header;
              
              if (isHeader) {
                final baseStyle = textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 11,
                );
                
                final mentionStyle = baseStyle?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                );

                return HeaderCard(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: controller.parseMentionsToSpans(
                        content.message,
                        baseStyle,
                        mentionStyle,
                      ),
                    ),
                  ),
                );
              }
              
              final baseStyle = textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
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
        ],
      ),
    );
  }
}
