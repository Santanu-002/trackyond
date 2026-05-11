import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class AppFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? borderColor;
  final double? radius;

  const AppFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.activeColor,
    this.inactiveColor,
    this.borderColor,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final effectiveRadius = radius ?? AppUIConstants.radius.radius$32;
    
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      labelStyle: context.textTheme.labelMedium?.copyWith(
        color: isSelected
            ? (activeColor != null ? theme.colorScheme.onPrimary : theme.colorScheme.onPrimary)
            : theme.colorScheme.onSurfaceVariant,
        fontWeight: isSelected ? FontWeight.w600 : null,
      ),
      selectedColor: activeColor ?? theme.colorScheme.primary,
      backgroundColor: inactiveColor ?? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(effectiveRadius),
        side: BorderSide(
          color: isSelected
              ? (activeColor ?? theme.colorScheme.primary)
              : (borderColor ?? theme.colorScheme.outlineVariant),
        ),
      ),
      showCheckmark: false,
      pressElevation: 0,
    );
  }
}
