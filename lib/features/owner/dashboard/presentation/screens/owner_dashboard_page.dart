import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/layout/app_nav_layout.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/common/widgets/icons/app_notification_bell.dart';
import 'package:trackyond/features/notification/presentation/controllers/notification_controller.dart';
import 'package:trackyond/features/owner/dashboard/presentation/controllers/owner_dashboard_controller.dart';
import 'package:trackyond/features/owner/dashboard/presentation/widgets/drawer/app_drawer.dart';
import 'package:trackyond/features/owner/dashboard/presentation/widgets/jobs/recent_jobs_section.dart';
import 'package:trackyond/features/owner/dashboard/presentation/widgets/stats/task_stats_section.dart';
import 'package:trackyond/features/owner/dashboard/presentation/widgets/team/team_status_section.dart';
import 'package:trackyond/features/owner/jobs/presentation/bindings/create_job_binding.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/create_job_controller.dart';
import 'package:trackyond/features/owner/jobs/presentation/screens/create_job_page.dart';

class OwnerDashboardPage extends GetView<OwnerDashboardController> {
  const OwnerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.ownerDashboard;
    final notificationController = Get.find<NotificationController>();

    return AppNavLayout(
      title: strings.title,
      padding: EdgeInsets.zero,
      useScrollView: false,
      openBuilder: (context, action) {
        CreateJobBinding().dependencies();
        final createJobController = Get.find<CreateJobController>();
        createJobController.onSuccess = (job) {
          controller.fetchDashboardData(); // Refresh all data to be sure
          action(returnValue: job);
        };
        return const CreateJobPage();
      },
      drawer: const AppDrawer(),
      actions: [
        Obx(() => AppNotificationBell(
              count: notificationController.unreadCount.value,
              onPressed: controller.openNotifications,
            )),
        AppUIConstants.widgets.horizontalBox$8,
      ],
      child: RefreshIndicator(
        onRefresh: controller.fetchDashboardData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppUIConstants.spacing.space$32,
            children: [
              // Team Status Section
              Obx(
                () => TeamStatusSection(
                  members: controller.teamMembers.toList(),
                  isLoading: controller.isLoading.value,
                ),
              ),

              // Stats Section
              Obx(
                () => TaskStatsSection(
                  isLoading: controller.isLoading.value,
                ),
              ),

              // Recent Jobs Section
              Obx(
                () => RecentJobsSection(isLoading: controller.isLoading.value),
              ),

              AppUIConstants.widgets.verticalBox$32,
            ],
          ),
        ),
      ),
    );
  }
}
