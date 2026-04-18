import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/entities/user/user_role.dart';

class ChooseRoleController extends GetxController {
  /// Navigates to the OTP screen for the selected [role].
  void navigateToLogin(UserRole role) {
    Get.toNamed(AppRoutes.common.auth.sendOtp, arguments: role);
  }
}
