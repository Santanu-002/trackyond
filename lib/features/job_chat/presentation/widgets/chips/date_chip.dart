import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class DateChip extends StatelessWidget {
  final DateTime date;
  final EdgeInsetsGeometry? margin;

  const DateChip({super.key, required this.date, this.margin});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final textTheme = context.textTheme;

    return Center(
      child: Container(
        margin: margin ?? EdgeInsets.only(
          top: AppUIConstants.spacing.space$16,
          bottom: AppUIConstants.spacing.space$8,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppUIConstants.spacing.space$12,
          vertical: AppUIConstants.spacing.space$4,
        ),
        decoration: BoxDecoration(
          color: colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$8),
        ),
        child: Text(
          _formatDate(date),
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final itemDate = DateTime(date.year, date.month, date.day);

    if (itemDate == today) {
      return 'Today';
    } else if (itemDate == yesterday) {
      return 'Yesterday';
    } else if (now.difference(itemDate).inDays < 7) {
      return DateFormat('EEEE').format(date);
    } else {
      return DateFormat('dd MMM, yyyy').format(date);
    }
  }
}
