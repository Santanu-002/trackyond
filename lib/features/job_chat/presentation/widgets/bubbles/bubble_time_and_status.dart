import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class BubbleTimeAndStatus extends StatelessWidget {
  final DateTime timestamp;
  final bool isMe;

  const BubbleTimeAndStatus({
    super.key,
    required this.timestamp,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.textTheme;

    final diff = DateTime.now().difference(timestamp);
    final timeString = diff.inMinutes < 1 ? 'Just now' : DateFormat('hh:mm a').format(timestamp);

    return Transform.translate(
      offset: const Offset(4, 4),
      child: Padding(
        padding: EdgeInsets.only(left: AppUIConstants.spacing.space$12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              timeString,
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
      ),
    );
  }
}
