import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/common/widgets/card/app_card.dart';
import 'package:trackyond/features/worker/dashboard/presentation/controllers/worker_dashboard_controller.dart';
import 'package:trackyond/features/worker/dashboard/presentation/widgets/attendance/attendance_action.dart';
import 'package:trackyond/features/worker/dashboard/presentation/widgets/attendance/attendance_grid.dart';
import 'package:trackyond/features/worker/dashboard/presentation/widgets/permission/location_permission_banner.dart';
import 'package:trackyond/features/worker/dashboard/presentation/widgets/attendance/working_status_chip.dart';

class WorkerAttendanceCard extends GetView<WorkerDashboardController> {
  const WorkerAttendanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  AppStrings.workerDashboard.greetingWithName(
                    controller.greeting,
                    controller.workerName.value,
                  ),
                  style: context.textTheme.titleMedium,
                ),
              ),
              Obx(
                () => WorkingStatusChip(
                  status: controller.attendanceStatus.value,
                ),
              ),
            ],
          ),
          const LocationPermissionBanner(),
          const AttendanceGrid(),
          AppUIConstants.widgets.verticalBox$16,
          const AttendanceAction()
        ],
      ),
    );
  }
}
