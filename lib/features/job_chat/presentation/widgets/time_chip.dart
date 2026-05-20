import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class TimeChip extends StatelessWidget {
  final DateTime time;

  const TimeChip({super.key, required this.time});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.textTheme;

    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: AppUIConstants.spacing.space$4),
        padding: EdgeInsets.symmetric(
          horizontal: AppUIConstants.spacing.space$8,
          vertical: AppUIConstants.spacing.space$2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$12),
        ),
        child: Text(
          DateFormat(AppStrings.jobChat.timeFormat).format(time),
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
