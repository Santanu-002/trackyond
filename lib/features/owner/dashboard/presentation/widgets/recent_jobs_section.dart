import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/card/app_card.dart';
import 'package:trackyond/core/common/widgets/layout/app_section.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/features/owner/dashboard/presentation/controllers/owner_dashboard_controller.dart';

class RecentJobsSection extends GetView<OwnerDashboardController> {
  const RecentJobsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSection(
      title: AppStrings.ownerDashboard.recentJobs,
      onActionPressed: controller.goToJobs,
      actionLabel: AppStrings.ownerDashboard.viewAll,
      child: Obx(
        () => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.recentJobs.length,
          separatorBuilder: (context, index) =>
              AppUIConstants.widgets.verticalBox$12,
          itemBuilder: (context, index) {
            final job = controller.recentJobs[index];
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
                      job.isOngoing
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
                          job.title,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          job.location,
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
                        '\$${job.budget.toStringAsFixed(2)}',
                        style: context.textTheme.titleSmall?.copyWith(
                          color: context.theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          final pendingColor =
                              context.theme.colorScheme.pending;
                          final completedColor =
                              context.theme.colorScheme.tertiary;
                          final statusColor = job.isOngoing
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
                              job.status,
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
        ),
      ),
    );
  }
}
