import 'package:get/get.dart';
import 'package:trackyond/features/worker/profile/presentation/controllers/worker_profile_controller.dart';

class WorkerProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WorkerProfileController());
  }
}
