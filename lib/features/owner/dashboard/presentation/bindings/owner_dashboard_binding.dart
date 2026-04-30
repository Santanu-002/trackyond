import 'package:get/get.dart';
import 'package:trackyond/features/owner/add_team_member/data/datasources/team_remote_data_source.dart';
import 'package:trackyond/features/owner/add_team_member/data/repositories/team_repository_impl.dart';
import 'package:trackyond/features/owner/add_team_member/domain/repositories/i_team_repository.dart';
import 'package:trackyond/features/owner/dashboard/domain/usecases/get_team_status_usecase.dart';
import 'package:trackyond/features/owner/dashboard/presentation/controllers/owner_dashboard_controller.dart';

class OwnerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Repositories
    Get.lazyPut<ITeamRepository>(
      () => TeamRepositoryImpl(
        remoteDataSource: TeamRemoteDataSourceImpl(dio: Get.find()),
        userService: Get.find(),
      ),
    );

    // UseCases
    Get.lazyPut(() => GetTeamStatusUseCase(Get.find()));

    Get.lazyPut(
      () => OwnerDashboardController(
        logoutUseCase: Get.find(),
        getTeamStatusUseCase: Get.find(),
        userService: Get.find(),
      ),
    );
  }
}
