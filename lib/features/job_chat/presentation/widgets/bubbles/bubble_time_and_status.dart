import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class BubbleTimeAndStatus extends StatelessWidget {
  final DateTime timestamp;
  final bool isMe;
  final String? status;
  final bool isOverlaid;

  const BubbleTimeAndStatus({
    super.key,
    required this.timestamp,
    required this.isMe,
    this.status,
    this.isOverlaid = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.textTheme;

    final diff = DateTime.now().difference(timestamp);
    final timeString = diff.inMinutes < 1 ? AppStrings.jobChat.justNow : DateFormat(AppStrings.jobChat.timeFormat).format(timestamp);

    final Color textColor;
    final Color tickColor;

    if (isOverlaid) {
      textColor = colorScheme.onPrimary;
      tickColor = status == 'seen'
          ? colorScheme.primary
          : colorScheme.onPrimary.withValues(alpha: 0.7);
    } else {
      textColor = isMe
          ? colorScheme.onPrimary.withValues(alpha: 0.7)
          : colorScheme.onSurfaceVariant;
      tickColor = status == 'seen'
          ? colorScheme.onPrimary
          : (isMe 
              ? colorScheme.onPrimary.withValues(alpha: 0.7) 
              : colorScheme.onSurfaceVariant.withValues(alpha: 0.7));
    }

    final IconData statusIcon = status == 'sent' ? Icons.done : Icons.done_all;

    final rowContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          timeString,
          style: textTheme.labelSmall?.copyWith(
            fontSize: 10,
            color: textColor,
          ),
        ),
        if (isMe) ...[
          AppUIConstants.widgets.horizontalBox$4,
          Icon(
            statusIcon,
            size: 14,
            color: tickColor,
          ),
        ],
      ],
    );

    if (isOverlaid) {
      return rowContent;
    }

    return Transform.translate(
      offset: const Offset(4, 4),
      child: Padding(
        padding: EdgeInsets.only(left: AppUIConstants.spacing.space$12),
        child: rowContent,
      ),
    );
  }
}
