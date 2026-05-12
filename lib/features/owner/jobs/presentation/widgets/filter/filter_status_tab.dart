import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/filter/status_quick_chip.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/jobs_controller.dart';

class FilterStatusTab extends StatelessWidget {
  final JobsController controller;
  const FilterStatusTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Text(AppStrings.jobs.selectStatuses, style: context.textTheme.titleMedium),
        AppUIConstants.widgets.verticalBox$16,
        Wrap(
          spacing: AppUIConstants.spacing.space$8,
          runSpacing: AppUIConstants.spacing.space$8,
          children: [
            StatusQuickChip(
              label: AppStrings.jobs.pending,
              status: JobStatus.pending,
            ),
            StatusQuickChip(
              label: AppStrings.jobs.inProgress,
              status: JobStatus.inProgress,
            ),
            StatusQuickChip(
              label: AppStrings.jobs.completed,
              status: JobStatus.completed,
            ),
            StatusQuickChip(
              label: AppStrings.jobs.cancelled,
              status: JobStatus.cancelled,
            ),
          ],
        ),
      ],
    );
  }
}
