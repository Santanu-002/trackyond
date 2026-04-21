import 'package:get/get.dart';
import 'package:trackyond/core/services/user/user_service.dart';
import 'package:trackyond/features/auth/domain/usecases/logout_usecase.dart';
import 'package:trackyond/features/worker/presentation/controllers/worker_dashboard_controller.dart';

class WorkerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => WorkerDashboardController(
        logoutUseCase: Get.find<LogoutUseCase>(),
        userService: Get.find<UserService>(),
      ),
    );
  }
}
