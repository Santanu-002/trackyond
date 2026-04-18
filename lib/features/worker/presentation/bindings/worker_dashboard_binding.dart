import 'package:get/get.dart';
import 'package:trackyond/features/worker/presentation/controllers/worker_dashboard_controller.dart';

class WorkerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WorkerDashboardController());
  }
}
