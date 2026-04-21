import 'package:get/get.dart';
import 'package:trackyond/features/owner/add_team_member/data/datasources/team_remote_data_source.dart';
import 'package:trackyond/features/owner/add_team_member/data/repositories/team_repository_impl.dart';
import 'package:trackyond/features/owner/add_team_member/domain/repositories/i_team_repository.dart';
import 'package:trackyond/features/owner/add_team_member/domain/usecases/add_team_member_usecase.dart';
import 'package:trackyond/features/owner/add_team_member/presentation/controllers/add_team_member_controller.dart';

class AddTeamMemberBinding extends Bindings {
  @override
  void dependencies() {
    // Data Source
    Get.lazyPut<TeamRemoteDataSource>(
      () => TeamRemoteDataSourceImpl(dio: Get.find()),
    );

    // Repository
    Get.lazyPut<ITeamRepository>(
      () => TeamRepositoryImpl(
        remoteDataSource: Get.find<TeamRemoteDataSource>(),
      ),
    );

    // Use Case
    Get.lazyPut<AddTeamMemberUseCase>(
      () => AddTeamMemberUseCase(Get.find<ITeamRepository>()),
    );

    // Controller
    Get.lazyPut<AddTeamMemberController>(
      () => AddTeamMemberController(Get.find<AddTeamMemberUseCase>()),
    );
  }
}
