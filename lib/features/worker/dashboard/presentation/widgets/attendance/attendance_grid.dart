import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/features/worker/dashboard/domain/entities/attendance_info_item.dart';
import 'package:trackyond/features/worker/dashboard/presentation/controllers/worker_dashboard_controller.dart';
import 'package:trackyond/features/worker/dashboard/presentation/widgets/attendance/attendance_info_tile.dart';

class AttendanceGrid extends GetView<WorkerDashboardController> {
  const AttendanceGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
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
          child: controller.attendanceStatus.value == AttendanceStatus.working
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
    );
  }

  Color _getColorForType(BuildContext context, AttendanceInfoType type) =>
      switch (type) {
        AttendanceInfoType.location => context.theme.colorScheme.primary,
        AttendanceInfoType.clock => context.theme.colorScheme.pending,
        AttendanceInfoType.timer => context.theme.colorScheme.error,
        AttendanceInfoType.calendar =>
          context.theme.colorScheme.completed,
      };
}
