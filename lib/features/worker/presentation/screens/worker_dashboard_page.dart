import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/icons/app_notification_bell.dart';
import 'package:trackyond/core/common/widgets/layout/app_nav_layout.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/worker/presentation/controllers/worker_dashboard_controller.dart';
import 'package:trackyond/features/worker/presentation/widgets/work_day_status_card.dart';
import 'package:trackyond/features/worker/presentation/widgets/worker_recent_jobs_section.dart';

class WorkerDashboardPage extends GetView<WorkerDashboardController> {
  const WorkerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppNavLayout(
      title: controller.title.value,
      leading: IconButton(
        icon: Icon(
          Icons.account_circle,
          size: 28,
          color: context.theme.colorScheme.primary,
        ),
        onPressed: controller.navigateToProfile,
      ),
      actions: [
        AppNotificationBell(
          count: 0,
          onPressed: () {},
        ),
      ],
      padding: EdgeInsets.symmetric(
        horizontal: AppUIConstants.spacing.space$16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppUIConstants.spacing.space$24,
          children: [
            AppUIConstants.widgets.verticalBox$8,
            const WorkDayStatusCard(),
            const WorkerRecentJobsSection(),
            AppUIConstants.widgets.verticalBox$24,
          ],
        ),
      ),
    );
  }
}
