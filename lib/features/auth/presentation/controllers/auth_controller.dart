import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/entities/user/user_role.dart';
import 'package:trackyond/core/services/token/token_service.dart';
import 'package:trackyond/core/services/user/user_service.dart';

class AuthController extends GetxController {
  final TokenService _tokenService = Get.find();
  final UserService _userService = Get.find();

  final isLoading = false.obs;

  @override
  void onInit() async {
    await bootStrap();
    super.onInit();
  }

  Future<void> bootStrap() async {
    final isRefreshExpired = await _tokenService.isRefreshTokenExpired();

    if (isRefreshExpired) {
      Get.offAllNamed(AppRoutes.common.auth.chooseRole);
    } else {
      final userRole = _userService.getUserRole();

      if (userRole == UserRole.owner) {
        // go to owner dashboard
      } else if (userRole == UserRole.worker) {
        // go to worker dashboard
      } else {
        Get.offAllNamed(AppRoutes.common.auth.chooseRole);
      }
    }
  }
}
