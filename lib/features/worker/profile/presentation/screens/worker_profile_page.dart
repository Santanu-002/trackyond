import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/common/widgets/layout/app_nav_layout.dart';
import 'package:trackyond/features/worker/profile/presentation/controllers/worker_profile_controller.dart';

class WorkerProfilePage extends GetView<WorkerProfileController> {
  const WorkerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppNavLayout(
      title: AppStrings.workerProfile.title,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppStrings.workerProfile.profilePlaceholder),
            AppUIConstants.widgets.verticalBox$24,
            AppButton.filled(
              text: AppStrings.workerProfile.logoutTesting,
              onPressed: controller.logout,
              color: context.theme.colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}
