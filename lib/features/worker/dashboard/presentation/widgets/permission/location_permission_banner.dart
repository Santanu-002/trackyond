import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/worker/dashboard/presentation/controllers/worker_dashboard_controller.dart';

class LocationPermissionBanner extends GetView<WorkerDashboardController> {
  const LocationPermissionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLocationDisabled = !controller.isLocationEnabled.value;
      final isPermissionDenied =
          controller.locationPermission.value == LocationPermission.denied ||
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
                isLocationDisabled ? Icons.location_off : Icons.lock_outline,
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
    });
  }
}
