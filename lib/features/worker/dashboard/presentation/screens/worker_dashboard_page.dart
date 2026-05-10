import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/avatar/member_avatar.dart';
import 'package:trackyond/core/common/widgets/icons/app_notification_bell.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/worker/dashboard/presentation/controllers/worker_dashboard_controller.dart';
import 'package:trackyond/features/worker/dashboard/presentation/widgets/work_attendance_card.dart';

class WorkerDashboardPage extends GetView<WorkerDashboardController> {
  const WorkerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: controller.title.value,
      useScrollView: false,
      leading: Padding(
        padding: EdgeInsets.only(left: AppUIConstants.spacing.space$12),
        child: Center(
          child: MemberAvatar(
            name: controller.workerName,
            image: controller.workerImage,
            radius: AppUIConstants.radius.radius$16,
            onPressed: controller.navigateToProfile,
          ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppUIConstants.spacing.space$24,
            children: [
              const WorkerAttendanceCard(),
            ],
          ),
        ),
      ),
    );
  }
}
