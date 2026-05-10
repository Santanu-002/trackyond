import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/entities/user/user.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/check_onboarding_status_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/check_token_validity_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/get_authenticated_user_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/get_company_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/get_member_profile_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/get_setting_use_case.dart';
import 'package:trackyond/features/auth/domain/usecases/get_user_role_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/logout_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/save_setting_use_case.dart';

class AuthController extends GetxController {
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final GetAuthenticatedUserUseCase _getAuthenticatedUserUseCase;
  final GetUserRoleUseCase _getUserRoleUseCase;
  final GetMemberProfileUseCase _getMemberProfileUseCase;
  final GetCompanyUseCase _getCompanyUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckTokenValidityUseCase _checkTokenValidityUseCase;
  final CheckOnboardingStatusUseCase _checkOnboardingStatusUseCase;

  // Role-based settings use cases
  final GetSettingUseCase _getOwnerSettingUseCase;
  final SaveSettingUseCase _saveOwnerSettingUseCase;
  final GetSettingUseCase _getWorkerSettingUseCase;
  final SaveSettingUseCase _saveWorkerSettingUseCase;

  AuthController({
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required GetAuthenticatedUserUseCase getAuthenticatedUserUseCase,
    required GetUserRoleUseCase getUserRoleUseCase,
    required GetMemberProfileUseCase getMemberProfileUseCase,
    required GetCompanyUseCase getCompanyUseCase,
    required LogoutUseCase logoutUseCase,
    required CheckTokenValidityUseCase checkTokenValidityUseCase,
    required CheckOnboardingStatusUseCase checkOnboardingStatusUseCase,
    required GetSettingUseCase getOwnerSettingUseCase,
    required SaveSettingUseCase saveOwnerSettingUseCase,
    required GetSettingUseCase getWorkerSettingUseCase,
    required SaveSettingUseCase saveWorkerSettingUseCase,
  })  : _checkAuthStatusUseCase = checkAuthStatusUseCase,
        _getAuthenticatedUserUseCase = getAuthenticatedUserUseCase,
        _getUserRoleUseCase = getUserRoleUseCase,
        _getMemberProfileUseCase = getMemberProfileUseCase,
        _getCompanyUseCase = getCompanyUseCase,
        _logoutUseCase = logoutUseCase,
        _checkTokenValidityUseCase = checkTokenValidityUseCase,
        _checkOnboardingStatusUseCase = checkOnboardingStatusUseCase,
        _getOwnerSettingUseCase = getOwnerSettingUseCase,
        _saveOwnerSettingUseCase = saveOwnerSettingUseCase,
        _getWorkerSettingUseCase = getWorkerSettingUseCase,
        _saveWorkerSettingUseCase = saveWorkerSettingUseCase;

  @override
  void onReady() async {
    await bootstrap();
    super.onReady();
  }

  // ------------------ STATE ------------------
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  // ------------------ GETTERS (via UseCases) ------------------

  Future<User?> get user async {
    final userResult = await _getAuthenticatedUserUseCase(const NoParams());
    return userResult.fold<User?>((_) => null, (user) => user);
  }

  Future<UserRole?> get userRole async {
    final roleResult = await _getUserRoleUseCase(const NoParams());
    return roleResult.fold<UserRole?>((_) => null, (role) => role);
  }

  Future<MemberProfile?> get profile async {
    final profileResult = await _getMemberProfileUseCase(const NoParams());
    return profileResult.fold<MemberProfile?>(
      (_) => null,
      (profile) => profile,
    );
  }

  Future<String> get ownerName async {
    final profileResult = await profile;
    return profileResult?.name ?? 'Owner';
  }

  Future<String> get companyName async {
    final companyResult = await _getCompanyUseCase(const NoParams());
    return companyResult.fold(
      (_) => 'Company',
      (company) => company?.name ?? 'Company',
    );
  }

  Future<String> get ownerPhone async {
    final userRes = await user;
    return userRes?.phone ?? '';
  }

  Future<bool> get isLoggedIn async {
    final statusResult = await _checkAuthStatusUseCase(const NoParams());
    return statusResult.fold<bool>((_) => false, (status) => status);
  }

  Future<bool> get isAuthenticated async {
    final tokenResult = await _checkTokenValidityUseCase(const NoParams());
    return tokenResult.fold((_) => false, (valid) => valid);
  }

  Future<bool> get _hasCompletedOnboarding async {
    final result = await _checkOnboardingStatusUseCase(const NoParams());
    return result.fold<bool>((_) => false, (completed) => completed);
  }

  // ------------------ SETTINGS ------------------

  Future<dynamic> getSetting(String key, Type type) async {
    final role = await userRole;
    if (role == UserRole.owner) {
      final res = await _getOwnerSettingUseCase(GetSettingParams(key: key, type: type));
      return res.fold((_) => null, (v) => v);
    } else if (role == UserRole.worker) {
      final res = await _getWorkerSettingUseCase(GetSettingParams(key: key, type: type));
      return res.fold((_) => null, (v) => v);
    }
    return null;
  }

  Future<void> saveSetting(String key, dynamic value) async {
    final role = await userRole;
    if (role == UserRole.owner) {
      await _saveOwnerSettingUseCase(SaveSettingParams(key: key, value: value));
    } else if (role == UserRole.worker) {
      await _saveWorkerSettingUseCase(SaveSettingParams(key: key, value: value));
    }
  }

  // Convenience getters for common settings
  Future<bool> getBoolSetting(String key, {bool defaultValue = false}) async {
    return (await getSetting(key, bool)) as bool? ?? defaultValue;
  }

  Future<String?> getStringSetting(String key) async {
    return (await getSetting(key, String)) as String?;
  }

  // ------------------ ACTIONS ------------------

  /// Bootstraps the application state and handles initial navigation.
  Future<void> bootstrap() async {
    _isLoading.value = true;
    try {
      final isRefreshValid = await isAuthenticated;
      final loggedIn = await isLoggedIn;

      if (!isRefreshValid || !loggedIn) {
        _handleUnauthenticated();
        return;
      }

      // 3. User exists, check status and navigate
      final role = await userRole;

      await _navigateBasedOnRole(role);
    } catch (e) {
      _handleUnauthenticated();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _logoutUseCase(const NoParams());
    Get.offAllNamed(AppRoutes.common.auth.chooseRole);
  }

  // ------------------ HELPERS ------------------

  void _handleUnauthenticated() async {
    await logout();
  }

  Future<void> _navigateBasedOnRole(UserRole? role) async {
    final userData = await user;

    if (role == UserRole.owner) {
      if (userData?.isNewUser ?? true) {
        Get.offAllNamed(
          AppRoutes.owner.setupCompany,
          arguments: <String, dynamic>{'phone': userData?.phone},
        );
        return;
      }

      if (await _hasCompletedOnboarding) {
        Get.offAllNamed(AppRoutes.owner.dashboard);
      } else {
        Get.offAllNamed(AppRoutes.owner.addTeamMember);
      }
    } else if (role == UserRole.worker) {
      Get.offAllNamed(AppRoutes.worker.dashboard);
    } else {
      _handleUnauthenticated();
    }
  }
}
