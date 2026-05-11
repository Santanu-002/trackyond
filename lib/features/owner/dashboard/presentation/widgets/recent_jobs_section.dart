import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/card/app_card.dart';
import 'package:trackyond/core/common/widgets/card/app_job_card.dart';
import 'package:trackyond/core/common/widgets/layout/app_section.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_skeleton.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/dashboard/presentation/controllers/owner_dashboard_controller.dart';

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
                'No recent jobs found',
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
              return const RecentJobCardSkeleton();
            }
            final job = controller.recentJobs[index];

            return AppJobCard(
              job: job,
              onTap: () => controller.goToJobDetails(job),
            );
          },
        );
      }),
    );
  }
}

class RecentJobCardSkeleton extends StatelessWidget {
  const RecentJobCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
      child: AppShimmer(
        child: Row(
          children: [
            const AppSkeletonContainer(width: 48, height: 48, borderRadius: 12),
            AppUIConstants.widgets.horizontalBox$12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppSkeletonText(
                    variant: AppSkeletonTextVariant.title,
                    width: 120,
                  ),
                  AppUIConstants.widgets.verticalBox$4,
                  AppSkeletonText(
                    variant: AppSkeletonTextVariant.caption,
                    width: 150,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const AppSkeletonText(
                  variant: AppSkeletonTextVariant.caption,
                  width: 40,
                ),
                AppUIConstants.widgets.verticalBox$4,
                AppSkeletonContainer(width: 60, height: 20, borderRadius: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
