import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class GenderChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const GenderChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onSelected,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppUIConstants.spacing.space$12,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? null
                : context.theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      context.theme.colorScheme.primary,
                      context.theme.colorScheme.primary.withValues(alpha: 0.8),
                    ],
                  )
                : null,
            borderRadius: BorderRadius.circular(
              AppUIConstants.radius.radius$32,
            ),
            border: Border.all(
              color: isSelected
                  ? context.theme.colorScheme.primary
                  : context.theme.colorScheme.outline.withValues(alpha: 0.1),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: context.theme.colorScheme.primary.withValues(
                        alpha: 0.2,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? context.theme.colorScheme.onPrimary
                    : context.theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
