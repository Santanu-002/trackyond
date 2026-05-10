import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:trackyond/features/worker/dashboard/data/datasources/job_datasource.dart';
import 'package:trackyond/features/worker/dashboard/data/repositories/job_repository_impl.dart';
import 'package:trackyond/features/worker/dashboard/domain/repositories/i_job_repository.dart';
import 'package:trackyond/features/worker/dashboard/domain/usecases/get_assigned_jobs_usecase.dart';
import 'package:trackyond/features/worker/dashboard/presentation/controllers/worker_dashboard_controller.dart';
import 'package:trackyond/features/worker/attendance/domain/usecases/end_attendance_usecase.dart';
import 'package:trackyond/features/worker/attendance/domain/usecases/get_attendance_status_usecase.dart';
import 'package:trackyond/features/worker/attendance/domain/usecases/start_attendance_usecase.dart';

class WorkerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    // DataSources
    Get.lazyPut<IJobDataSource>(() => JobDataSourceImpl(Get.find<Dio>()));

    // Repositories
    Get.lazyPut<IJobRepository>(() => JobRepositoryImpl(Get.find<IJobDataSource>()));

    // UseCases
    Get.lazyPut(() => GetAssignedJobsUseCase(Get.find<IJobRepository>()));

    // Controllers
    Get.lazyPut(
      () => WorkerDashboardController(
        startAttendanceUseCase: Get.find<StartAttendanceUseCase>(),
        endAttendanceUseCase: Get.find<EndAttendanceUseCase>(),
        getAttendanceStatusUseCase: Get.find<GetAttendanceStatusUseCase>(),
        getAssignedJobsUseCase: Get.find<GetAssignedJobsUseCase>(),
      ),
    );
  }
}
