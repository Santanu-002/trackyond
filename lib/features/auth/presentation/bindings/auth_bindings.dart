import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackyond/core/services/settings/settings_pref_service.dart';
import 'package:trackyond/features/auth/data/datasources/auth_datasource.dart';
import 'package:trackyond/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:trackyond/features/auth/data/repositories/settings_repository_impl.dart';
import 'package:trackyond/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:trackyond/features/auth/domain/repositories/i_settings_repository.dart';
import 'package:trackyond/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/check_token_validity_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/check_onboarding_status_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/get_authenticated_user_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/get_member_profile_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/get_setting_use_case.dart';
import 'package:trackyond/features/auth/domain/usecases/get_user_role_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/get_company_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/logout_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/save_setting_use_case.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';
import 'package:trackyond/features/auth/presentation/controllers/choose_role_controller.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut(() => SettingsPrefService(Get.find<SharedPreferences>()));

    // Data layer
    Get.lazyPut<IAuthDataSource>(() => AuthDataSourceImpl(Get.find<Dio>()));
    Get.lazyPut<IAuthRepository>(
      () => AuthRepositoryImpl(
        Get.find<IAuthDataSource>(),
        Get.find(),
        Get.find(),
      ),
    );

    // Settings Repositories
    Get.lazyPut<IOwnerSettingsRepository>(() => OwnerSettingsRepositoryImpl(Get.find()));
    Get.lazyPut<IWorkerSettingsRepository>(() => WorkerSettingsRepositoryImpl(Get.find()));

    // Use cases
    Get.lazyPut(() => CheckAuthStatusUseCase(Get.find()));
    Get.lazyPut(() => GetAuthenticatedUserUseCase(Get.find()));
    Get.lazyPut(() => GetUserRoleUseCase(Get.find()));
    Get.lazyPut(() => GetMemberProfileUseCase(Get.find()));
    Get.lazyPut(() => GetCompanyUseCase(Get.find()));
    Get.lazyPut(() => LogoutUseCase(Get.find()));
    Get.lazyPut(() => CheckTokenValidityUseCase(Get.find()));
    Get.lazyPut(() => CheckOnboardingStatusUseCase(Get.find()));

    // Settings Use Cases
    Get.lazyPut(() => GetSettingUseCase(Get.find<IOwnerSettingsRepository>()), tag: 'owner');
    Get.lazyPut(() => SaveSettingUseCase(Get.find<IOwnerSettingsRepository>()), tag: 'owner');
    Get.lazyPut(() => GetSettingUseCase(Get.find<IWorkerSettingsRepository>()), tag: 'worker');
    Get.lazyPut(() => SaveSettingUseCase(Get.find<IWorkerSettingsRepository>()), tag: 'worker');

    // Controllers
    Get.put(
      AuthController(
        checkAuthStatusUseCase: Get.find(),
        getAuthenticatedUserUseCase: Get.find(),
        getUserRoleUseCase: Get.find(),
        getMemberProfileUseCase: Get.find(),
        getCompanyUseCase: Get.find(),
        logoutUseCase: Get.find(),
        checkTokenValidityUseCase: Get.find(),
        checkOnboardingStatusUseCase: Get.find(),
        getOwnerSettingUseCase: Get.find(tag: 'owner'),
        saveOwnerSettingUseCase: Get.find(tag: 'owner'),
        getWorkerSettingUseCase: Get.find(tag: 'worker'),
        saveWorkerSettingUseCase: Get.find(tag: 'worker'),
      ),
      permanent: true,
    );
    Get.lazyPut(() => ChooseRoleController());
  }
}
