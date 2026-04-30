import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/common/widgets/layout/app_nav_layout.dart';
import 'package:trackyond/features/owner/dashboard/presentation/controllers/owner_dashboard_controller.dart';
import 'package:trackyond/features/owner/dashboard/presentation/widgets/drawer/app_drawer.dart';
import 'package:trackyond/features/owner/dashboard/presentation/widgets/team_status_section.dart';
import 'package:trackyond/features/owner/dashboard/presentation/widgets/task_stats_section.dart';
import 'package:trackyond/features/owner/dashboard/presentation/widgets/recent_jobs_section.dart';

class OwnerDashboardPage extends GetView<OwnerDashboardController> {
  const OwnerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.ownerDashboard;
    final theme = context.theme;

    return AppNavLayout(
      title: strings.title,
      padding: EdgeInsets.zero,
      onFabPressed: () {
        // TODO: Implement FAB action (e.g., navigate to create job)
      },
      drawer: const AppDrawer(),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(AppIcons.common.notifications),
              onPressed: controller.openNotifications,
            ),
            Obx(() => controller.notificationCount.value > 0
                ? Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.scaffoldBackgroundColor, width: 1.5),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 8,
                        minHeight: 8,
                      ),
                    ),
                  )
                : const SizedBox.shrink()),
          ],
        ),
        AppUIConstants.widgets.horizontalBox$8,
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppUIConstants.spacing.space$32,
        children: [
          // Team Status Section
          Obx(() => TeamStatusSection(members: controller.teamMembers.toList())),

          // Stats Section
          Obx(() => TaskStatsSection(
            stats: controller.taskStats,
          )),

          // Recent Jobs Section
          const RecentJobsSection(),
        ],
      ),
    );
  }
}
