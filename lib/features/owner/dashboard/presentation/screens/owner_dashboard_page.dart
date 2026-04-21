import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/dashboard/presentation/controllers/owner_dashboard_controller.dart';

class OwnerDashboardPage extends GetView<OwnerDashboardController> {
  const OwnerDashboardPage({super.key});

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
              Icons.admin_panel_settings,
              size: 80,
              color: context.theme.colorScheme.primary,
            ),
            Obx(
              () => Text(
                AppStrings.ownerDashboard.welcome(controller.ownerName),
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Obx(
              () => Text(
                AppStrings.ownerDashboard.message(controller.companyName),
                style: context.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            AppUIConstants.widgets.verticalBox$8,
            AppButton.outlined(
              onPressed: () => Get.back(),
              text: AppStrings.ownerDashboard.goBack,
            ),
          ],
        ),
      ),
    );
  }
}
