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
import 'package:trackyond/core/common/widgets/skeleton/app_skeleton.dart';

class WorkerAttendanceCard extends GetView<WorkerDashboardController> {
  final bool isLoading;

  const WorkerAttendanceCard({super.key, this.isLoading = false});

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
              if (isLoading)
                const AppShimmer(
                  child: AppSkeletonText(
                    width: 150,
                    variant: AppSkeletonTextVariant.title,
                  ),
                )
              else
                Obx(
                  () => Text(
                    AppStrings.workerDashboard.greetingWithName(
                      controller.greeting,
                      controller.workerName.value,
                    ),
                    style: context.textTheme.titleMedium,
                  ),
                ),
              if (isLoading)
                const AppShimmer(
                  child: AppSkeletonButton(
                    width: 80,
                    height: 26,
                  ),
                )
              else
                Obx(
                  () => WorkingStatusChip(
                    status: controller.attendanceStatus.value,
                  ),
                ),
            ],
          ),
          if (isLoading) ...[
            AppUIConstants.widgets.verticalBox$16,
            const AppShimmer(
              child: AppSkeletonButton(
                width: double.infinity,
                height: 56,
              ),
            ),
          ] else ...[
            const LocationPermissionBanner(),
            const AttendanceGrid(),
            AppUIConstants.widgets.verticalBox$16,
            const AttendanceAction()
          ],
        ],
      ),
    );
  }
}
