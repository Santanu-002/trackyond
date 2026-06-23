import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/media_preview/buttons/aspect_preset_icon.dart';


class AspectPresetButton extends StatelessWidget {
  final String ratioLabel;
  final bool isActive;
  final ColorScheme colorScheme;
  final VoidCallback onTap;

  const AspectPresetButton({
    super.key,
    required this.ratioLabel,
    required this.isActive,
    required this.colorScheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          right: AppUIConstants.spacing.space$8,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppUIConstants.spacing.space$12,
          vertical: AppUIConstants.spacing.space$6,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? colorScheme.primary
              : colorScheme.onPrimary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(
            AppUIConstants.radius.radius$12,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectPresetIcon(
              ratioLabel: ratioLabel,
              isActive: isActive,
              colorScheme: colorScheme,
            ),
            AppUIConstants.widgets.horizontalBox$8,
            Text(
              ratioLabel,
              style: context.textTheme.labelMedium?.copyWith(
                color: isActive ? colorScheme.onPrimary : colorScheme.onPrimary.withValues(alpha: 0.7),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
