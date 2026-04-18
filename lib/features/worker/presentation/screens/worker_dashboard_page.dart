import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/services/token/token_service.dart';
import 'package:trackyond/app/routes/app_routes.dart';
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
            const Icon(Icons.person, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              'Welcome, Worker!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Your login was successful.'),
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
