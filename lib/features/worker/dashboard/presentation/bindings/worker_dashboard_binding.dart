import 'package:get/get.dart';
import 'package:trackyond/features/worker/dashboard/presentation/controllers/worker_dashboard_controller.dart';
import 'package:trackyond/features/worker/attendance/domain/usecases/end_attendance_usecase.dart';
import 'package:trackyond/features/worker/attendance/domain/usecases/get_attendance_status_usecase.dart';
import 'package:trackyond/features/worker/attendance/domain/usecases/start_attendance_usecase.dart';

class WorkerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => WorkerDashboardController(
        startAttendanceUseCase: Get.find<StartAttendanceUseCase>(),
        endAttendanceUseCase: Get.find<EndAttendanceUseCase>(),
        getAttendanceStatusUseCase: Get.find<GetAttendanceStatusUseCase>(),
      ),
    );
  }
}
