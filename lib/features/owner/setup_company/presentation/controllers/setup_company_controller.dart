import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/entities/company/company_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/features/owner/setup_company/domain/entities/team_size_option.dart';
import 'package:trackyond/features/owner/setup_company/domain/usecases/save_company_usecase.dart';
import 'package:trackyond/features/owner/setup_company/domain/usecases/setup_company_usecase.dart';
import 'package:trackyond/features/owner/setup_company/domain/usecases/update_user_details_usecase.dart';
import 'package:trackyond/features/owner/setup_company/presentation/widgets/custom_team_size_bottom_sheet.dart';

class SetupCompanyController extends GetxController {
  final SetupCompanyUseCase _setupCompanyUseCase;
  final UpdateUserDetailsUseCase _updateUserDetailsUseCase;
  final SaveCompanyUseCase _saveCompanyUseCase;

  SetupCompanyController({
    required SetupCompanyUseCase setupCompanyUseCase,
    required UpdateUserDetailsUseCase updateUserDetailsUseCase,
    required SaveCompanyUseCase saveCompanyUseCase,
  }) : _setupCompanyUseCase = setupCompanyUseCase,
       _updateUserDetailsUseCase = updateUserDetailsUseCase,
       _saveCompanyUseCase = saveCompanyUseCase;

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
      text: (Get.arguments as Map<String, dynamic>)['phone'],
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

      await result.fold(
        (failure) async {
          AppSnackbar.destructive(failure.toString());
        },
        (setupResult) async {
          // Finalize onboarding locally and globally
          await completeCompanySetup(
            profile: setupResult.memberProfile,
            company: setupResult.company,
          );

          AppSnackbar.success(AppStrings.setupCompany.setupSuccess);
          FocusManager.instance.primaryFocus?.unfocus();
        },
      );
    } catch (e) {
      AppSnackbar.destructive(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Finalizes the onboarding process for an owner.
  /// This updates the local session and persists company details globally.
  Future<void> completeCompanySetup({
    required MemberProfile profile,
    required CompanyEntity company,
  }) async {
    // 1. Update session locally (sets isNewUser: false and saves profile)
    final sessionResult = await _updateUserDetailsUseCase(
      UpdateUserDetailsParams(profile: profile, isNewUser: false),
    );

    sessionResult.fold(
      (failure) => AppSnackbar.destructive(failure.toString()),
      (_) async {
        // 2. Persist company details globally
        final saveResult = await _saveCompanyUseCase(
          SaveCompanyParams(company: company),
        );

        saveResult.fold(
          (failure) => AppSnackbar.destructive(failure.toString()),
          (_) => Get.offAllNamed(AppRoutes.owner.addTeamMember),
        );
      },
    );
  }
}
