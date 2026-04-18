import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/features/owner/setup_company/presentation/widgets/custom_team_size_bottom_sheet.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/snackbar/app_snackbar.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';
import 'package:trackyond/features/owner/setup_company/domain/entities/team_size_option.dart';
import 'package:trackyond/features/owner/setup_company/domain/usecases/setup_company_usecase.dart';

class SetupCompanyController extends GetxController {
  final SetupCompanyUseCase _setupCompanyUseCase;

  SetupCompanyController({required SetupCompanyUseCase setupCompanyUseCase})
    : _setupCompanyUseCase = setupCompanyUseCase;

  // ------------------ CONTROLLERS ------------------
  late final TextEditingController companyNameController;
  late final TextEditingController userNameController;
  late final TextEditingController phoneController;

  // ------------------ STATE ------------------
  final isFormValid = false.obs;
  final isLoading = false.obs;
  final selectedTeamSize = 5.obs;

  final List<TeamSizeOption> teamSizeOptions = [
    TeamSizeOption(
      title: AppStrings.chooseTeamSize.smallTeamTitle,
      subtitle: AppStrings.chooseTeamSize.smallTeamSub,
      value: 5,
    ),
    TeamSizeOption(
      title: AppStrings.chooseTeamSize.growingTeamTitle,
      subtitle: AppStrings.chooseTeamSize.growingTeamSub,
      value: 10,
    ),
    TeamSizeOption(
      title: AppStrings.chooseTeamSize.mediumTeamTitle,
      subtitle: AppStrings.chooseTeamSize.mediumTeamSub,
      value: 20,
    ),
    TeamSizeOption(
      title: AppStrings.chooseTeamSize.customTeamTitle,
      subtitle: AppStrings.chooseTeamSize.customTeamSub,
      value: 0, // 0 indicates custom/large
      icon: Icons.manage_accounts_rounded,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    companyNameController = TextEditingController();
    userNameController = TextEditingController();
    phoneController = TextEditingController(
      text: Get.find<AuthController>().user?.phone ?? '',
    );

    companyNameController.addListener(_validateForm);
    userNameController.addListener(_validateForm);
  }

  @override
  void onClose() {
    companyNameController.dispose();
    userNameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void _validateForm() {
    isFormValid.value =
        companyNameController.text.trim().isNotEmpty &&
        userNameController.text.trim().isNotEmpty;
  }

  void selectTeamSize(int value) {
    if (value == 0) {
      _showCustomTeamSizeBottomSheet();
    } else {
      selectedTeamSize.value = value;
    }
  }

  void _showCustomTeamSizeBottomSheet() {
    Get.bottomSheet(
      CustomTeamSizeBottomSheet(
        initialValue: selectedTeamSize.value,
        onConfirm: (size) => selectedTeamSize.value = size,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void submitStepOne() {
    if (!isFormValid.value) return;
    FocusManager.instance.primaryFocus?.unfocus();
    Get.toNamed(AppRoutes.owner.chooseTeamSize);
  }

  Future<void> finalizeSetup() async {
    isLoading.value = true;
    try {
      final result = await _setupCompanyUseCase(
        SetupCompanyParams(
          companyName: companyNameController.text.trim(),
          ownerName: userNameController.text.trim(),
          phone: phoneController.text.trim(),
          teamSize: selectedTeamSize.value,
        ),
      );

      result.fold(
        (failure) {
          AppSnackbar.error(failure.toString());
        },
        (company) {
          debugPrint('SUCCESS: Company Created - $company');
          AppSnackbar.success(AppStrings.setupCompany.setupSuccess);
          FocusManager.instance.primaryFocus?.unfocus();
          Get.offAllNamed(AppRoutes.owner.dashboard);
        },
      );
    } catch (e) {
      AppSnackbar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
