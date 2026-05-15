import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_icons.dart';

class AppSortChip extends StatelessWidget {
  final bool isDescending;
  final String descendingLabel;
  final String ascendingLabel;
  final VoidCallback onToggle;

  const AppSortChip({
    super.key,
    required this.isDescending,
    required this.descendingLabel,
    required this.ascendingLabel,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(
        isDescending ? descendingLabel : ascendingLabel,
        style: context.textTheme.labelMedium?.copyWith(
          color: context.theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: () {
        HapticFeedback.lightImpact();
        onToggle();
      },
      avatar: Icon(
        isDescending ? AppIcons.common.arrowDown : AppIcons.common.arrowUp,
        size: 16,
        color: context.theme.colorScheme.primary,
      ),
      side: BorderSide(
        color: context.theme.colorScheme.primary.withValues(alpha: 0.2),
      ),
    );
  }
}
