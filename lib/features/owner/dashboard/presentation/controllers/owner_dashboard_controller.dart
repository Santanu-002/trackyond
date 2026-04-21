import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/services/user/user_service.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/logout_usecase.dart';

class OwnerDashboardController extends GetxController {
  final LogoutUseCase _logoutUseCase;
  final UserService _userService;

  OwnerDashboardController({
    required LogoutUseCase logoutUseCase,
    required UserService userService,
  })  : _logoutUseCase = logoutUseCase,
        _userService = userService;

  final title = AppStrings.ownerDashboard.title.obs;

  String get ownerName => _userService.getProfile()?.name ?? 'Owner';
  String get companyName => _userService.getCompany()?.companyName ?? 'Company';

  Future<void> logout() async {
    final result = await _logoutUseCase(NoParams());
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (_) => Get.offAllNamed(AppRoutes.common.auth.chooseRole),
    );
  }
}
