import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class ProfileActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ProfileActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$16),
      child: Padding(
        padding: EdgeInsets.all(AppUIConstants.spacing.space$8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(
                  AppUIConstants.radius.radius$16,
                ),
              ),
              child: Icon(
                icon,
                color: context.theme.colorScheme.primary,
                size: 24,
              ),
            ),
            AppUIConstants.widgets.verticalBox$8,
            Text(
              label,
              style: context.textTheme.labelMedium?.copyWith(
                color: context.theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
