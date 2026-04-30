import 'package:get/get.dart';
import 'package:trackyond/features/owner/team_status/data/datasources/team_status_datasource.dart';
import 'package:trackyond/features/owner/team_status/data/repositories/team_status_repository_impl.dart';
import 'package:trackyond/features/owner/team_status/domain/repositories/i_team_status_repository.dart';
import 'package:trackyond/features/owner/team_status/domain/usecases/get_team_status_use_case.dart';
import 'package:trackyond/features/owner/dashboard/presentation/controllers/owner_dashboard_controller.dart';

class OwnerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ITeamStatusRepository>(
      () => TeamStatusRepositoryImpl(
         TeamStatusDataSourceImpl(Get.find()),
      ),
    );

    // UseCases
    Get.lazyPut(() => GetTeamStatusUseCase(Get.find()));

    Get.lazyPut(
      () => OwnerDashboardController(
        getTeamStatusUseCase: Get.find(),
      ),
    );
  }
}
