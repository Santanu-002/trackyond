import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/common/widgets/card/app_card.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/features/worker/dashboard/domain/entities/attendance_info_item.dart';
import 'package:trackyond/features/worker/dashboard/presentation/controllers/worker_dashboard_controller.dart';
import 'package:trackyond/features/worker/dashboard/presentation/widgets/attendance_info_tile.dart';
import 'package:trackyond/features/worker/dashboard/presentation/widgets/working_status_chip.dart';

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
              Text(
                AppStrings.workerDashboard.greetingWithName(
                  controller.greeting,
                  controller.workerName,
                ),
                style: context.textTheme.titleMedium,
              ),
              Obx(
                () => WorkingStatusChip(
                  status: controller.attendanceStatus.value,
                ),
              ),
            ],
          ),
          Obx(() {
            final isLocationDisabled = !controller.isLocationEnabled.value;
            final isPermissionDenied =
                controller.locationPermission.value ==
                    LocationPermission.denied ||
                controller.locationPermission.value ==
                    LocationPermission.deniedForever;

            if (!isLocationDisabled && !isPermissionDenied) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: EdgeInsets.only(top: AppUIConstants.spacing.space$12),
              child: Container(
                padding: EdgeInsets.all(AppUIConstants.spacing.space$12),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    AppUIConstants.radius.radius$12,
                  ),
                  border: Border.all(
                    color: context.theme.colorScheme.error.withValues(
                      alpha: 0.3,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isLocationDisabled
                          ? Icons.location_off
                          : Icons.lock_outline,
                      color: context.theme.colorScheme.error,
                      size: 20,
                    ),
                    AppUIConstants.widgets.horizontalBox$12,
                    Expanded(
                      child: Text(
                        isLocationDisabled
                            ? AppStrings.workerDashboard.locationDisabled
                            : AppStrings.workerDashboard.locationRequired,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.theme.colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    AppButton.ghost(
                      text: isLocationDisabled
                          ? AppStrings.workerDashboard.openLocationSettings
                          : AppStrings.workerDashboard.openAppSettings,
                      onPressed: () {
                        if (isLocationDisabled) {
                          Geolocator.openLocationSettings();
                        } else {
                          Geolocator.openAppSettings();
                        }
                      },
                      width: null,
                      height: null,
                      color: context.theme.colorScheme.error,
                    ),
                  ],
                ),
              ),
            );
          }),
          Obx(
            () => AnimatedSize(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    axis: Axis.vertical,
                    axisAlignment: -1.0,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child:
                    controller.attendanceStatus.value ==
                        AttendanceStatus.working
                    ? Column(
                        key: const ValueKey('attendance_grid'),
                        children: [
                          SizedBox(height: AppUIConstants.spacing.space$16),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: AppUIConstants.spacing.space$12,
                            childAspectRatio: 3,
                            children: List.generate(
                              controller.attendanceItems.length,
                              (index) {
                                final item = controller.attendanceItems[index];
                                return AttendanceInfoTile(
                                  icon: item.icon,
                                  text: item.text,
                                  color: _getColorForType(context, item.type),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(key: ValueKey('no_grid')),
              ),
            ),
          ),
          SizedBox(height: AppUIConstants.spacing.space$16),
          Obx(() {
            final status = controller.attendanceStatus.value;
            final isWorking = status == AttendanceStatus.working;
            final isEnded = status == AttendanceStatus.ended;

            return AppButton.filled(
              isLoading: controller.isActionLoading.value,
              onPressed:
                  isEnded
                      ? null
                      : (isWorking ? controller.endMyDay : controller.startMyDay),
              color: isWorking
                  ? context.theme.colorScheme.error
                  : (isEnded
                        ? context.theme.colorScheme.onSurface.withValues(
                            alpha: 0.1,
                          )
                        : null),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: AppUIConstants.spacing.space$4,
                children: [
                  Icon(
                    isWorking
                        ? AppIcons.common.stop
                        : (isEnded
                              ? Icons.check_circle_outline
                              : AppIcons.common.play),
                    color: isEnded
                        ? context.theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          )
                        : context.theme.colorScheme.onPrimary,
                    size: 24,
                  ),
                  Text(
                    isWorking
                        ? AppStrings.workerDashboard.endMyDay
                        : (isEnded
                              ? AppStrings.workerDashboard.dayEnded
                              : AppStrings.workerDashboard.startMyDay),
                    style: context.textTheme.labelLarge?.copyWith(
                      color: isEnded
                          ? context.theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            )
                          : context.theme.colorScheme.onPrimary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getColorForType(BuildContext context, AttendanceInfoType type) =>
      switch (type) {
        AttendanceInfoType.location => context.theme.colorScheme.primary,
        AttendanceInfoType.clock => context.theme.colorScheme.pending,
        AttendanceInfoType.timer => context.theme.colorScheme.error,
        AttendanceInfoType.calendar =>
          context.theme.colorScheme.onSurface.withValues(alpha: 0.5),
      };
}
