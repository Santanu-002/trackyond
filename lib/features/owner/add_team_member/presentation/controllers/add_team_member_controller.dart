import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/services/user/user_service.dart';
import 'package:trackyond/features/owner/add_team_member/domain/usecases/add_team_member_usecase.dart';

class AddTeamMemberController extends GetxController {
  final AddTeamMemberUseCase _addTeamMemberUseCase;
  final UserService _userService = Get.find<UserService>();

  AddTeamMemberController(this._addTeamMemberUseCase);

  // ------------------ CONTROLLERS ------------------
  late final TextEditingController nameController;
  late final TextEditingController phoneController;

  // ------------------ STATE ------------------
  final isLoading = false.obs;
  final isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    phoneController = TextEditingController();

    nameController.addListener(_validateForm);
    phoneController.addListener(_validateForm);
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void _validateForm() {
    isFormValid.value =
        nameController.text.trim().isNotEmpty &&
        phoneController.text.trim().length == 10;
  }

  Future<void> skip() async {
    await _completeStep();
  }

  Future<void> addMember() async {
    if (!isFormValid.value) return;

    isLoading.value = true;
    final result = await _addTeamMemberUseCase.execute(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
    );

    result.fold(
      (failure) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      },
      (_) async {
        isLoading.value = false;
        await _completeStep();
      },
    );
  }

  Future<void> _completeStep() async {
    await _userService.setHasCompletedAddTeamMember(true);
    Get.offAllNamed(AppRoutes.owner.dashboard);
  }
}
