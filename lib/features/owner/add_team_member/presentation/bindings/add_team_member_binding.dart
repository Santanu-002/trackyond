import 'package:get/get.dart';
import 'package:trackyond/core/services/user/user_service.dart';
import 'package:trackyond/features/owner/add_team_member/data/datasources/team_remote_data_source.dart';
import 'package:trackyond/features/owner/add_team_member/data/repositories/team_repository_impl.dart';
import 'package:trackyond/features/owner/add_team_member/domain/repositories/i_team_repository.dart';
import 'package:trackyond/features/owner/add_team_member/domain/usecases/add_team_member_usecase.dart';
import 'package:trackyond/features/owner/add_team_member/domain/usecases/get_team_company_usecase.dart';
import 'package:trackyond/features/owner/add_team_member/domain/usecases/get_team_members_usecase.dart';
import 'package:trackyond/features/owner/add_team_member/domain/usecases/save_onboarding_progress_use_case.dart';
import 'package:trackyond/features/owner/add_team_member/presentation/controllers/add_team_member_controller.dart';

class AddTeamMemberBinding extends Bindings {
  @override
  void dependencies() {
    // Data Source
    Get.lazyPut<ITeamRemoteDataSource>(
      () => TeamRemoteDataSourceImpl(dio: Get.find()),
    );

    // Repository
    Get.lazyPut<ITeamRepository>(
      () => TeamRepositoryImpl(
        remoteDataSource: Get.find<ITeamRemoteDataSource>(),
        userService: Get.find<UserService>(),
      ),
    );

    // Use Cases
    Get.lazyPut<AddTeamMemberUseCase>(
      () => AddTeamMemberUseCase(Get.find<ITeamRepository>()),
    );

    Get.lazyPut<GetTeamMembersUseCase>(
      () => GetTeamMembersUseCase(Get.find<ITeamRepository>()),
    );

    Get.lazyPut<SaveOnboardingProgressUseCase>(
      () => SaveOnboardingProgressUseCase(Get.find<ITeamRepository>()),
    );

    Get.lazyPut<GetTeamCompanyUseCase>(
      () => GetTeamCompanyUseCase(Get.find<ITeamRepository>()),
    );

    // Controller
    Get.lazyPut<AddTeamMemberController>(
      () => AddTeamMemberController(
        addTeamMemberUseCase: Get.find<AddTeamMemberUseCase>(),
        getTeamMembersUseCase: Get.find<GetTeamMembersUseCase>(),
        getCompanyUseCase: Get.find<GetTeamCompanyUseCase>(),
        saveOnboardingProgressUseCase:
            Get.find<SaveOnboardingProgressUseCase>(),
      ),
    );
  }
}
