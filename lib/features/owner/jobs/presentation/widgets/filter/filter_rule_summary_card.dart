import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/jobs_controller.dart';

class FilterRuleSummaryCard extends StatelessWidget {
  final dynamic rule;
  final VoidCallback onDelete;
  final JobsController controller;

  const FilterRuleSummaryCard({
    super.key,
    required this.rule,
    required this.onDelete,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$12),
        side: BorderSide(color: context.theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.getFieldLabel(rule.field),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppUIConstants.widgets.verticalBox$4,
                  Text(
                    controller.getValueLabel(rule.value),
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: Icon(AppIcons.common.close, size: 18),
              style: IconButton.styleFrom(
                backgroundColor: context.theme.colorScheme.surface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
