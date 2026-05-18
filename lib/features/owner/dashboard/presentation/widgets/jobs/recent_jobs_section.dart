import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/card/app_job_card.dart';
import 'package:trackyond/core/common/widgets/layout/app_section.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/dashboard/presentation/controllers/owner_dashboard_controller.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_job_card_skeleton.dart';

class RecentJobsSection extends GetView<OwnerDashboardController> {
  final bool isLoading;

  const RecentJobsSection({super.key, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return AppSection(
      title: AppStrings.ownerDashboard.recentJobs,
      onActionPressed: controller.goToJobs,
      actionLabel: AppStrings.ownerDashboard.viewAll,
      childPadding: EdgeInsets.symmetric(
        horizontal: AppUIConstants.spacing.space$24,
      ),
      child: Obx(() {
        if (!isLoading && controller.recentJobs.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppUIConstants.spacing.space$32,
              ),
              child: Text(
                AppStrings.ownerDashboard.noRecentJobs,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }

        final itemCount = isLoading ? 3 : controller.recentJobs.length;

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          separatorBuilder: (context, index) =>
              AppUIConstants.widgets.verticalBox$12,
          itemBuilder: (context, index) {
            if (isLoading) {
              return const AppJobCardSkeleton();
            }
            final job = controller.recentJobs[index];

            return AppJobCard(
              job: job,
              onTap: () => controller.goToJobChat(job),
            );
          },
        );
      }),
    );
  }
}
