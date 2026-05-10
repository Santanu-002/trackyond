import 'package:get/get.dart';
import 'package:trackyond/features/owner/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:trackyond/features/owner/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:trackyond/features/owner/dashboard/domain/repositories/i_dashboard_repository.dart';
import 'package:trackyond/features/owner/dashboard/domain/usecases/get_owner_dashboard_use_case.dart';
import 'package:trackyond/features/owner/team_status/data/datasources/team_status_datasource.dart';
import 'package:trackyond/features/owner/team_status/data/repositories/team_status_repository_impl.dart';
import 'package:trackyond/features/owner/team_status/domain/repositories/i_team_status_repository.dart';
import 'package:trackyond/features/owner/team_status/domain/usecases/get_team_status_use_case.dart';
import 'package:trackyond/features/owner/dashboard/presentation/controllers/owner_dashboard_controller.dart';

class OwnerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Data Sources
    Get.lazyPut<IDashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImpl(Get.find()),
    );
    Get.lazyPut<ITeamStatusDataSource>(
      () => TeamStatusDataSourceImpl(Get.find()),
    );

    // Repositories
    Get.lazyPut<IDashboardRepository>(
      () => DashboardRepositoryImpl(Get.find()),
    );
    Get.lazyPut<ITeamStatusRepository>(
      () => TeamStatusRepositoryImpl(Get.find()),
    );

    // UseCases
    Get.lazyPut(() => GetOwnerDashboardUseCase(Get.find()));
    Get.lazyPut(() => GetTeamStatusUseCase(Get.find()));

    // Controllers
    Get.lazyPut(
      () => OwnerDashboardController(
        getOwnerDashboardUseCase: Get.find(),
      ),
    );
  }
}
