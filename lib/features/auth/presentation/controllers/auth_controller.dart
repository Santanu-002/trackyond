import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/entities/user/user.dart';
import 'package:trackyond/core/common/entities/user/user_role.dart';
import 'package:trackyond/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/check_token_validity_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/get_authenticated_user_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/get_member_profile_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/get_user_role_usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/logout_usecase.dart';

class AuthController extends GetxController {
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final GetAuthenticatedUserUseCase _getAuthenticatedUserUseCase;
  final GetUserRoleUseCase _getUserRoleUseCase;
  final GetMemberProfileUseCase _getMemberProfileUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckTokenValidityUseCase _checkTokenValidityUseCase;

  AuthController({
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required GetAuthenticatedUserUseCase getAuthenticatedUserUseCase,
    required GetUserRoleUseCase getUserRoleUseCase,
    required GetMemberProfileUseCase getMemberProfileUseCase,
    required LogoutUseCase logoutUseCase,
    required CheckTokenValidityUseCase checkTokenValidityUseCase,
  }) : _checkAuthStatusUseCase = checkAuthStatusUseCase,
       _getAuthenticatedUserUseCase = getAuthenticatedUserUseCase,
       _getUserRoleUseCase = getUserRoleUseCase,
       _getMemberProfileUseCase = getMemberProfileUseCase,
       _logoutUseCase = logoutUseCase,
       _checkTokenValidityUseCase = checkTokenValidityUseCase;

  // ------------------ STATE ------------------

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  // ------------------ GETTERS ------------------

  User? get user => _getAuthenticatedUserUseCase.execute();

  UserRole? get userRole => _getUserRoleUseCase.execute();

  MemberProfile? get profile => _getMemberProfileUseCase.execute();

  bool get isAuthenticated => _checkAuthStatusUseCase.execute();

  // ------------------ ACTIONS ------------------

  /// Bootstraps the application state and handles initial navigation.
  Future<void> bootstrap() async {
    _isLoading.value = true;
    try {
      // 1. Check if refresh token is valid
      final isRefreshValid = await _checkTokenValidityUseCase.isRefreshValid();

      if (!isRefreshValid) {
        _handleUnauthenticated();
        return;
      }

      // 2. Refresh token is valid, check if user exists in local cache
      if (!isAuthenticated) {
        _handleUnauthenticated();
        return;
      }

      // 3. User exists, check status and navigate
      _navigateBasedOnRole(userRole);
    } catch (e) {
      _handleUnauthenticated();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _logoutUseCase.execute();
    Get.offAllNamed(AppRoutes.common.auth.chooseRole);
  }

  // ------------------ HELPERS ------------------

  void _handleUnauthenticated() {
    Get.offAllNamed(AppRoutes.common.auth.chooseRole);
  }

  void _navigateBasedOnRole(UserRole? role) {
    if (role == UserRole.owner) {
      // Use the isNewUser flag from the User entity for navigation
      if (user?.isNewUser ?? true) {
        Get.offAllNamed(AppRoutes.owner.setupCompany);
      } else {
        Get.offAllNamed(AppRoutes.owner.dashboard);
      }
    } else if (role == UserRole.worker) {
      Get.offAllNamed(AppRoutes.worker.dashboard);
    } else {
      _handleUnauthenticated();
    }
  }
}
