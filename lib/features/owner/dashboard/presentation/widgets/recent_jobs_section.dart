import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/card/app_card.dart';
import 'package:trackyond/core/common/widgets/layout/app_section.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/core/utils/app_utils.dart';
import 'package:trackyond/features/owner/dashboard/presentation/controllers/owner_dashboard_controller.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_skeleton.dart';

class RecentJobsSection extends GetView<OwnerDashboardController> {
  final bool isLoading;

  const RecentJobsSection({
    super.key,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppSection(
      title: AppStrings.ownerDashboard.recentJobs,
      onActionPressed: controller.goToJobs,
      actionLabel: AppStrings.ownerDashboard.viewAll,
      childPadding: EdgeInsets.symmetric(
        horizontal: AppUIConstants.spacing.space$24,
      ),
      child: Obx(
        () {
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
              final isCompleted = job.status == JobStatus.completed;

              return AppCard(
                padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.primaryContainer
                            .withAlpha(50),
                        borderRadius: BorderRadius.circular(
                          AppUIConstants.radius.radius$12,
                        ),
                      ),
                      child: Icon(
                        !isCompleted
                            ? AppIcons.jobs.work
                            : AppIcons.dashboard.completed,
                        color: context.theme.colorScheme.primary,
                      ),
                    ),
                    AppUIConstants.widgets.horizontalBox$12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.jobTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AppUIConstants.widgets.verticalBox$4,
                          Text(
                            job.customerAddress ?? 'No address provided',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          AppUtils.formatRelativeTime(job.createdAt),
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        AppUIConstants.widgets.verticalBox$4,
                        Builder(
                          builder: (context) {
                            final pendingColor =
                                context.theme.colorScheme.pending;
                            final completedColor =
                                context.theme.colorScheme.tertiary;
                            final statusColor = !isCompleted
                                ? pendingColor
                                : completedColor;

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withAlpha(30),
                                borderRadius: BorderRadius.circular(
                                  AppUIConstants.radius.radius$8,
                                ),
                              ),
                              child: Text(
                                job.status.name.toUpperCase(),

                                style: context.textTheme.labelSmall?.copyWith(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
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
            const AppSkeletonContainer(
              width: 48,
              height: 48,
              borderRadius: 12,
            ),
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
                AppSkeletonContainer(
                  width: 60,
                  height: 20,
                  borderRadius: 8,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
