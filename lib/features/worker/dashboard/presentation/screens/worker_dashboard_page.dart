import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';
import 'package:trackyond/core/common/widgets/icons/app_notification_bell.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';
import 'package:trackyond/core/common/widgets/skeleton/app_skeleton_avatar.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/worker/dashboard/presentation/controllers/worker_dashboard_controller.dart';
import 'package:trackyond/features/worker/dashboard/presentation/widgets/attendance/work_attendance_card.dart';
import 'package:trackyond/features/worker/dashboard/presentation/widgets/recent_jobs/worker_recent_jobs_section.dart';
import 'package:trackyond/features/worker/dashboard/presentation/widgets/stats/worker_stats_section.dart';

class WorkerDashboardPage extends GetView<WorkerDashboardController> {
  const WorkerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: controller.title.value,
      useScrollView: false,
      padding: EdgeInsets.zero,
      leading: Padding(
        padding: EdgeInsets.only(left: AppUIConstants.spacing.space$12),
        child: Center(
          child: Obx(() {
            if (controller.isProfileLoading.value) {
              return AppSkeletonAvatar(
                size: AppUIConstants.radius.radius$16 * 2,
              );
            }
            return MemberAvatar(
              name: controller.workerName.value,
              image: controller.workerImage.value,
              radius: AppUIConstants.radius.radius$16,
              onPressed: controller.navigateToProfile,
            );
          }),
        ),
      ),
      actions: [
        AppNotificationBell(count: 0, onPressed: () {}),
        AppUIConstants.widgets.horizontalBox$8,
      ],
      child: RefreshIndicator(
        onRefresh: controller.refreshDashboard,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(AppUIConstants.spacing.space$24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppUIConstants.spacing.space$32,
            children: [
              Obx(
                () => WorkerAttendanceCard(
                  isLoading: controller.isDashboardLoading.value,
                ),
              ),
              Obx(
                () => WorkerStatsSection(
                  isLoading: controller.isDashboardLoading.value,
                ),
              ),
              Obx(
                () => WorkerRecentJobsSection(
                  isLoading: controller.isDashboardLoading.value,
                ),
              ),
              AppUIConstants.widgets.verticalBox$32,
            ],
          ),
        ),
      ),
    );
  }
}
