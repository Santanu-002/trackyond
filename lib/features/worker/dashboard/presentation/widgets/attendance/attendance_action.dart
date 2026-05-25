import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/worker/dashboard/presentation/controllers/worker_dashboard_controller.dart';

class AttendanceAction extends GetView<WorkerDashboardController> {
  const AttendanceAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = controller.attendanceStatus.value;
      final isWorking = status == AttendanceStatus.working;
      final onPrimary = context.theme.colorScheme.onPrimary;

      return AppButton.filled(
        onPressed: controller.isActionLoading.value
            ? null
            : (isWorking ? controller.endMyDay : controller.startMyDay),
        color: isWorking ? context.theme.colorScheme.error : null,
        child: Obx(() {
          final isLoading = controller.isActionLoading.value;
          final message = controller.actionLoadingMessage.value;

          if (isLoading) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: AppUIConstants.spacing.space$12,
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: onPrimary,
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    final isEntering = child.key ==
                        ValueKey(controller.actionLoadingMessage.value);

                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: isEntering
                            ? const Offset(0, -0.3)
                            : const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      )),
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    message ?? AppStrings.common.loading,
                    key: ValueKey(message),
                    style: context.textTheme.labelLarge?.copyWith(
                      color: onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AppUIConstants.spacing.space$4,
            children: [
              Icon(
                isWorking ? AppIcons.common.stop : AppIcons.common.play,
                color: onPrimary,
                size: 24,
              ),
              Text(
                isWorking
                    ? AppStrings.workerDashboard.endMyDay
                    : AppStrings.workerDashboard.startMyDay,
                style: context.textTheme.labelLarge?.copyWith(
                  color: onPrimary,
                  fontSize: 16,
                ),
              ),
            ],
          );
        }),
      );
    });
  }
}
