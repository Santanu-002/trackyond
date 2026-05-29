import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/jobs_controller.dart';

class JobsEmptyState extends GetView<JobsController> {
  const JobsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.jobs.filter,
              size: 64,
              color: context.theme.colorScheme.outlineVariant,
            ),
            const SizedBox(height: 16),
            Obx(() => Text(
              controller.searchQuery.isNotEmpty
                  ? AppStrings.jobs.noSearchFound(controller.searchQuery.value)
                  : controller.isFilteringActive
                      ? AppStrings.jobs.noJobsMatchingFilters
                      : AppStrings.jobs.noJobsFound,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium,
            )),
            const SizedBox(height: 8),
            Obx(() {
              if (controller.isFilteringActive) {
                return AppButton.ghost(
                  onPressed: controller.clearFilters,
                  text: AppStrings.jobs.clearAllFilters,
                  width: null,
                  height: null,
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
