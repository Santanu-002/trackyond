import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class JobDetailsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const JobDetailsSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: context.theme.colorScheme.primary),
            AppUIConstants.widgets.horizontalBox$8,
            Text(
              title,
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.theme.colorScheme.onSurface.withValues(
                  alpha: 0.8,
                ),
              ),
            ),
          ],
        ),
        AppUIConstants.widgets.verticalBox$12,
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppUIConstants.spacing.space$16),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(
              AppUIConstants.radius.radius$16,
            ),
            border: Border.all(color: context.theme.colorScheme.outlineVariant),
            boxShadow: AppUIConstants.shadows.sm,
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
