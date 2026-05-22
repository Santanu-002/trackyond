import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:trackyond/features/worker/dashboard/data/datasources/job_datasource.dart';
import 'package:trackyond/features/worker/dashboard/data/datasources/worker_dashboard_remote_data_source.dart';
import 'package:trackyond/features/worker/dashboard/data/repositories/job_repository_impl.dart';
import 'package:trackyond/features/worker/dashboard/data/repositories/worker_dashboard_repository_impl.dart';
import 'package:trackyond/features/worker/dashboard/domain/repositories/i_job_repository.dart';
import 'package:trackyond/features/worker/dashboard/domain/repositories/i_worker_dashboard_repository.dart';
import 'package:trackyond/features/worker/dashboard/domain/usecases/get_assigned_jobs_usecase.dart';
import 'package:trackyond/features/worker/dashboard/domain/usecases/get_worker_dashboard_use_case.dart';
import 'package:trackyond/features/worker/dashboard/domain/usecases/listen_job_events_use_case.dart';
import 'package:trackyond/features/worker/dashboard/presentation/controllers/worker_dashboard_controller.dart';

class WorkerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    // DataSources
    Get.lazyPut<IJobDataSource>(() => JobDataSourceImpl(Get.find<Dio>()));
    Get.lazyPut<IWorkerDashboardRemoteDataSource>(
      () => WorkerDashboardRemoteDataSourceImpl(Get.find<Dio>()),
    );

    // Repositories
    Get.lazyPut<IJobRepository>(
      () => JobRepositoryImpl(Get.find<IJobDataSource>()),
    );
    Get.lazyPut<IWorkerDashboardRepository>(
      () => WorkerDashboardRepositoryImpl(
        Get.find<IWorkerDashboardRemoteDataSource>(),
      ),
    );

    // UseCases
    Get.lazyPut(() => GetAssignedJobsUseCase(Get.find<IJobRepository>()));
    Get.lazyPut(
      () => GetWorkerDashboardUseCase(Get.find<IWorkerDashboardRepository>()),
    );
    Get.lazyPut(() => ListenJobEventsUseCase(Get.find()));

    // Controllers
    Get.lazyPut(
      () => WorkerDashboardController(
        getWorkerDashboardUseCase: Get.find<GetWorkerDashboardUseCase>(),
        listenJobEventsUseCase: Get.find<ListenJobEventsUseCase>(),
      ),
    );
  }
}
