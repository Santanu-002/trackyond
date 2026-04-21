import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/worker/presentation/controllers/worker_dashboard_controller.dart';

class WorkerDashboardPage extends GetView<WorkerDashboardController> {
  const WorkerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.title.value)),
        actions: [
          IconButton(
            onPressed: controller.logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppUIConstants.spacing.space$16,
          children: [
            Icon(
              Icons.person,
              size: 80,
              color: context.theme.colorScheme.secondary,
            ),
            Obx(
              () => Text(
                AppStrings.workerDashboard.welcome(controller.workerName),
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              AppStrings.workerDashboard.message,
              style: context.textTheme.bodyLarge,
            ),
            AppUIConstants.widgets.verticalBox$8,
            AppButton.outlined(
              onPressed: () => Get.back(),
              text: AppStrings.workerDashboard.goBack,
            ),
          ],
        ),
      ),
    );
  }
}
