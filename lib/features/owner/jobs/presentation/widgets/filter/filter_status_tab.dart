import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/jobs_controller.dart';

class FilterStatusTab extends StatelessWidget {
  final JobsController controller;
  const FilterStatusTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text('Select Statuses', style: context.textTheme.titleMedium),
        AppUIConstants.widgets.verticalBox$16,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: JobStatus.values.map((status) {
            return Obx(() {
              final isSelected = controller.isStatusSelected(status);
              return FilterChip(
                label: Text(status.name.capitalizeFirst!),
                selected: isSelected,
                onSelected: (_) => controller.setStatus(status),
                labelStyle: TextStyle(
                  color: isSelected
                      ? context.theme.colorScheme.onPrimaryContainer
                      : null,
                  fontWeight: isSelected ? FontWeight.bold : null,
                ),
                selectedColor: context.theme.colorScheme.primaryContainer,
                showCheckmark: false,
              );
            });
          }).toList(),
        ),
      ],
    );
  }
}
