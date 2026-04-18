import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class AppHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const AppHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: AppUIConstants.spacing.space$16,
      children: [
        // Rounded Icon Container
        Container(
          padding: EdgeInsets.all(AppUIConstants.spacing.space$16),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.primaryContainer.withValues(
              alpha: 0.1,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 40, color: context.theme.colorScheme.primary),
        ),

        // Text Content
        Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppUIConstants.spacing.space$8,
          children: [
            Text(
              title,
              style: context.textTheme.displayLarge?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.theme.colorScheme.onSurface.withValues(
                  alpha: 0.6,
                ),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}
