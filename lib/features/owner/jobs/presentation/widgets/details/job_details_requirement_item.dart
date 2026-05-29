import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class JobDetailsRequirementItem extends StatelessWidget {
  final String label;
  final bool value;

  const JobDetailsRequirementItem({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppUIConstants.spacing.space$8),
      child: Row(
        children: [
          Icon(
            value ? AppIcons.common.checkCircle : AppIcons.dashboard.cancelled,
            size: 16,
            color: value
                ? context.theme.colorScheme.tertiary
                : context.theme.colorScheme.onSurfaceVariant,
          ),
          AppUIConstants.widgets.horizontalBox$8,
          Text(label, style: context.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
