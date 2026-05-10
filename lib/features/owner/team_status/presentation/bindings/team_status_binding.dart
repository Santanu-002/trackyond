import 'package:get/get.dart';
import 'package:trackyond/features/owner/team_status/data/datasources/team_status_datasource.dart';
import 'package:trackyond/features/owner/team_status/data/repositories/team_status_repository_impl.dart';
import 'package:trackyond/features/owner/team_status/domain/repositories/i_team_status_repository.dart';
import 'package:trackyond/features/owner/team_status/domain/usecases/get_team_status_use_case.dart';
import 'package:trackyond/features/owner/team_status/presentation/controllers/team_status_controller.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';

class TeamStatusBinding extends Bindings {
  @override
  void dependencies() {
    // DataSource
    Get.lazyPut<ITeamStatusDataSource>(() => TeamStatusDataSourceImpl(Get.find()));

    // Repository
    Get.lazyPut<ITeamStatusRepository>(
      () => TeamStatusRepositoryImpl(Get.find()),
    );

    // UseCases
    Get.lazyPut(() => GetTeamStatusUseCase(Get.find()));

    // Controllers
    Get.lazyPut(() => TeamStatusController(
          getTeamStatusUseCase: Get.find<GetTeamStatusUseCase>(),
          authController: Get.find<AuthController>(),
        ));
  }
}
