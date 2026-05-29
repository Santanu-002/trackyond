import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/jobs_controller.dart';

class StatusPickerSheet extends GetView<JobsController> {
  const StatusPickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.jobs.selectStatuses,
            style: context.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: JobStatus.values.map((status) {
              return Obx(() {
                final isSelected = controller.isStatusSelected(status);
                return FilterChip(
                  label: Text(status.name.capitalizeFirst!),
                  selected: isSelected,
                  onSelected: (_) => controller.setStatus(status),
                );
              });
            }).toList(),
          ),
          const SizedBox(height: 16),
          AppButton.filled(
            text: AppStrings.common.done,
            onPressed: () => Get.back(),
            height: 48,
          ),
        ],
      ),
    );
  }
}
