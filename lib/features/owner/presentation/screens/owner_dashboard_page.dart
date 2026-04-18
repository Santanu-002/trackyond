import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/services/token/token_service.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/features/owner/presentation/controllers/owner_dashboard_controller.dart';

class OwnerDashboardPage extends GetView<OwnerDashboardController> {
  const OwnerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.title.value)),
        actions: [
          IconButton(
            onPressed: () async {
              await Get.find<TokenService>().clearTokens();
              Get.offAllNamed(AppRoutes.common.auth.chooseRole);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.admin_panel_settings, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'Welcome, Owner!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Your stabilization work is complete.'),
            const SizedBox(height: 24),
            AppButton.outlined(
              onPressed: () => Get.back(),
              text: 'Go Back',
            ),
          ],
        ),
      ),
    );
  }
}
