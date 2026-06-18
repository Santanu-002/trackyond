import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/layout/app_section.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_job_card_skeleton.dart';
import 'package:trackyond/features/worker/dashboard/presentation/controllers/worker_dashboard_controller.dart';
import 'package:trackyond/features/worker/dashboard/presentation/widgets/jobs/job_item_widget.dart';

class WorkerRecentJobsSection extends GetView<WorkerDashboardController> {
  final bool isLoading;

  const WorkerRecentJobsSection({super.key, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.workerDashboard;

    return AppSection(
      title: strings.recentJobs,
      onActionPressed: controller.goToJobs,
      actionLabel: strings.viewAll,
      padding: EdgeInsets.zero,
      childPadding: EdgeInsets.zero,
      headerPadding: EdgeInsets.zero,
      child: Obx(() {
        final recentJobs = controller.recentJobs.toList();

        if (!isLoading && recentJobs.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppUIConstants.spacing.space$32,
              ),
              child: Text(
                strings.noRecentJobs,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }

        final itemCount = isLoading ? 3 : recentJobs.length;

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: itemCount,
          separatorBuilder: (context, index) =>
              AppUIConstants.widgets.verticalBox$12,
          itemBuilder: (context, index) {
            if (isLoading) {
              return const AppJobCardSkeleton();
            }
            final job = recentJobs[index];
            return JobItemWidget(
              job: job,
              onTap: () => controller.goToJobChat(job),
            );
          },
        );
      }),
    );
  }
}
