import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/features/worker/presentation/controllers/worker_dashboard_controller.dart';
import 'package:intl/intl.dart';

class WorkDayStatusCard extends GetView<WorkerDashboardController> {
  const WorkDayStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppUIConstants.spacing.space$16),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$16),
        boxShadow: AppUIConstants.shadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppUIConstants.spacing.space$16,
        children: [
          Obx(() {
            if (controller.isWorkDayStarted.value) {
              return Row(
                children: [
                  Text(
                    AppStrings.workerDashboard.workDayStarted,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppUIConstants.widgets.horizontalBox$8,
                  // Pulsing active circle
                  _PulsingCircle(),
                ],
              );
            } else {
              return Text(
                controller.greeting,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              );
            }
          }),
          Obx(() {
            if (controller.isWorkDayStarted.value) {
              return AppButton.filled(
                onPressed: controller.endMyDay,
                color: context.theme.colorScheme.error,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.stop_rounded, color: Colors.white),
                    AppUIConstants.widgets.horizontalBox$8,
                    Text(
                      AppStrings.workerDashboard.endMyDay,
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return AppButton.filled(
                onPressed: controller.startMyDay,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_arrow_rounded, color: Colors.white),
                    AppUIConstants.widgets.horizontalBox$8,
                    Text(
                      AppStrings.workerDashboard.startMyDay,
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
          Obx(() {
            if (controller.isWorkDayStarted.value) {
              return Column(
                spacing: AppUIConstants.spacing.space$8,
                children: [
                  const Divider(),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: context.theme.colorScheme.primary),
                      AppUIConstants.widgets.horizontalBox$8,
                      Expanded(
                        child: Text(
                          controller.currentLocation.value ?? AppStrings.workerDashboard.fetchingLocation,
                          style: context.textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: context.theme.colorScheme.primary),
                      AppUIConstants.widgets.horizontalBox$8,
                      Text(
                        controller.punchInTime.value != null
                            ? DateFormat('hh:mm a').format(controller.punchInTime.value!)
                            : '--:--',
                        style: context.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.hourglass_empty, size: 16, color: context.theme.colorScheme.primary),
                      AppUIConstants.widgets.horizontalBox$8,
                      Text(
                        controller.elapsedTime.value,
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}

class _PulsingCircle extends StatefulWidget {
  @override
  State<_PulsingCircle> createState() => _PulsingCircleState();
}

class _PulsingCircleState extends State<_PulsingCircle> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
