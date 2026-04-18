import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class TeamSizeTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final int value;
  final bool isSelected;
  final ValueChanged<int?> onChanged;

  const TeamSizeTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(bottom: AppUIConstants.spacing.space$4),
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.primaryContainer.withValues(alpha: 0.05)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$16),
        border: Border.all(
          color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onChanged(value);
        },
        borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$16),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppUIConstants.spacing.space$16,
            vertical: AppUIConstants.spacing.space$12,
          ),
          child: Row(
            spacing: AppUIConstants.spacing.space$16,
            children: [
              // Leading Icon
              Container(
                padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary.withValues(alpha: 0.1)
                      : colorScheme.onSurface.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(
                    AppUIConstants.radius.radius$12,
                  ),
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 24,
                ),
              ),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: AppUIConstants.spacing.space$4,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),

              // Trailing Radio Button
              Radio<int>(
                value: value,
                activeColor: colorScheme.primary,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
