import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:trackyond/features/owner/jobs/data/datasources/jobs_remote_data_source.dart';
import 'package:trackyond/features/owner/jobs/data/repositories/jobs_repository_impl.dart';
import 'package:trackyond/features/owner/jobs/domain/repositories/i_jobs_repository.dart';
import 'package:trackyond/features/owner/jobs/domain/usecases/get_jobs_use_case.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/jobs_controller.dart';
import 'package:trackyond/features/owner/team_status/data/datasources/team_status_datasource.dart';
import 'package:trackyond/features/owner/team_status/data/repositories/team_status_repository_impl.dart';
import 'package:trackyond/features/owner/team_status/domain/repositories/i_team_status_repository.dart';
import 'package:trackyond/features/owner/team_status/domain/usecases/get_team_status_use_case.dart';

class JobsBinding extends Bindings {
  @override
  void dependencies() {
    // Team Status (Shared dependencies for worker filtering)
    Get.lazyPut<ITeamStatusDataSource>(() => TeamStatusDataSourceImpl(Get.find()));
    Get.lazyPut<ITeamStatusRepository>(
      () => TeamStatusRepositoryImpl(Get.find()),
    );
    Get.lazyPut(() => GetTeamStatusUseCase(Get.find()));

    // Data Sources
    Get.lazyPut<IJobsRemoteDataSource>(
      () => JobsRemoteDataSourceImpl(Get.find<Dio>()),
    );

    // Repositories
    Get.lazyPut<IJobsRepository>(() => JobsRepositoryImpl(Get.find()));

    // Use Cases
    Get.lazyPut(() => GetJobsUseCase(Get.find()));

    // Controllers
    Get.lazyPut(
      () => JobsController(
        getJobsUseCase: Get.find(),
        getTeamStatusUseCase: Get.find(),
      ),
    );
  }
}
