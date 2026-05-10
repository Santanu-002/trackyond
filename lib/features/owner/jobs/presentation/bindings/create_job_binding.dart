import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:trackyond/features/owner/jobs/data/datasources/jobs_remote_data_source.dart';
import 'package:trackyond/features/owner/jobs/data/repositories/jobs_repository_impl.dart';
import 'package:trackyond/features/owner/jobs/domain/repositories/i_jobs_repository.dart';
import 'package:trackyond/features/owner/jobs/domain/usecases/create_job_use_case.dart';
import 'package:trackyond/features/owner/jobs/presentation/controllers/create_job_controller.dart';
import 'package:trackyond/features/owner/add_team_member/data/datasources/team_remote_data_source.dart';
import 'package:trackyond/features/owner/add_team_member/data/repositories/team_repository_impl.dart';
import 'package:trackyond/features/owner/add_team_member/domain/repositories/i_team_repository.dart';
import 'package:trackyond/features/owner/add_team_member/domain/usecases/get_team_members_usecase.dart';
import 'package:trackyond/features/owner/team_status/data/datasources/team_status_datasource.dart';
import 'package:trackyond/features/owner/team_status/data/repositories/team_status_repository_impl.dart';
import 'package:trackyond/features/owner/team_status/domain/repositories/i_team_status_repository.dart';
import 'package:trackyond/features/owner/team_status/domain/usecases/get_team_status_use_case.dart';
import 'package:trackyond/core/services/user/user_service.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';

class CreateJobBinding extends Bindings {
  @override
  void dependencies() {
    // Data Sources
    Get.lazyPut<IJobsRemoteDataSource>(
      () => JobsRemoteDataSourceImpl(Get.find<Dio>()),
    );
    Get.lazyPut<ITeamRemoteDataSource>(
      () => TeamRemoteDataSourceImpl(dio: Get.find()),
    );
    Get.lazyPut<ITeamStatusDataSource>(
      () => TeamStatusDataSourceImpl(Get.find()),
    );

    // Repositories
    Get.lazyPut<IJobsRepository>(() => JobsRepositoryImpl(Get.find()));
    Get.lazyPut<ITeamRepository>(
      () => TeamRepositoryImpl(
        remoteDataSource: Get.find(),
        userService: Get.find<UserService>(),
      ),
    );
    Get.lazyPut<ITeamStatusRepository>(
      () => TeamStatusRepositoryImpl(Get.find()),
    );

    // Use Cases
    Get.lazyPut(() => CreateJobUseCase(Get.find()));
    Get.lazyPut(() => GetTeamMembersUseCase(Get.find()));
    Get.lazyPut(() => GetTeamStatusUseCase(Get.find()));

    // Controllers
    Get.lazyPut(
      () => CreateJobController(
        createJobUseCase: Get.find(),
        getTeamStatusUseCase: Get.find(),
        authController: Get.find<AuthController>(),
      ),
    );
  }
}
