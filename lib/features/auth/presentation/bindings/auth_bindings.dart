import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:trackyond/features/auth/data/datasources/auth_datasource.dart';
import 'package:trackyond/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:trackyond/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:trackyond/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/check_token_validity_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/check_onboarding_status_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/get_authenticated_user_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/get_member_profile_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/get_user_role_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/get_company_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/logout_usecase.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';
import 'package:trackyond/features/auth/presentation/controllers/choose_role_controller.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    // Data layer
    Get.lazyPut<IAuthDataSource>(() => AuthDataSourceImpl(Get.find<Dio>()));
    Get.lazyPut<IAuthRepository>(
      () => AuthRepositoryImpl(
        Get.find<IAuthDataSource>(),
        Get.find(),
        Get.find(),
      ),
    );

    // Use cases
    Get.lazyPut(() => CheckAuthStatusUseCase(Get.find()));
    Get.lazyPut(() => GetAuthenticatedUserUseCase(Get.find()));
    Get.lazyPut(() => GetUserRoleUseCase(Get.find()));
    Get.lazyPut(() => GetMemberProfileUseCase(Get.find()));
    Get.lazyPut(() => GetCompanyUseCase(Get.find()));
    Get.lazyPut(() => LogoutUseCase(Get.find()));
    Get.lazyPut(() => CheckTokenValidityUseCase(Get.find()));
    Get.lazyPut(() => CheckOnboardingStatusUseCase(Get.find()));

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
      ),
      permanent: true,
    );
    Get.lazyPut(() => ChooseRoleController());
  }
}
