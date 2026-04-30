import 'package:get/get.dart';

import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';

class WorkerProfileController extends GetxController {
  Future<void> logout() async {
    await Get.find<AuthController>().logout();
  }
}
