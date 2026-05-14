import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/entities/company/company_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/enums/gender.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/features/owner/add_team_member/domain/usecases/add_team_member_usecase.dart';
import 'package:trackyond/features/owner/add_team_member/domain/usecases/get_team_company_usecase.dart';
import 'package:trackyond/features/owner/add_team_member/domain/usecases/get_team_members_usecase.dart';
import 'package:trackyond/features/owner/add_team_member/domain/usecases/save_onboarding_progress_use_case.dart';

class AddTeamMemberController extends GetxController {
  final AddTeamMemberUseCase _addTeamMemberUseCase;
  final GetTeamMembersUseCase _getTeamMembersUseCase;
  final GetTeamCompanyUseCase _getCompanyUseCase;
  final SaveOnboardingProgressUseCase _saveOnboardingProgressUseCase;

  AddTeamMemberController({
    required AddTeamMemberUseCase addTeamMemberUseCase,
    required GetTeamMembersUseCase getTeamMembersUseCase,
    required GetTeamCompanyUseCase getCompanyUseCase,
    required SaveOnboardingProgressUseCase saveOnboardingProgressUseCase,
  }) : _addTeamMemberUseCase = addTeamMemberUseCase,
       _getTeamMembersUseCase = getTeamMembersUseCase,
       _getCompanyUseCase = getCompanyUseCase,
       _saveOnboardingProgressUseCase = saveOnboardingProgressUseCase;

  // ------------------ CONTROLLERS & FORM KEY ------------------
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController designationController;
  final formKey = GlobalKey<FormState>();

  // ------------------ STATE ------------------
  final isLoading = false.obs;
  final isFetching = false.obs;
  final isFormValid = false.obs;
  final hasSubmitted = false.obs;
  final members = <MemberProfile>[].obs;
  final company = Rxn<CompanyEntity>();
  final initialMembersCount = 0.obs;

  // Form State
  final selectedGender = Rxn<Gender>();
  final avatarPath = RxnString();
  final isDirty = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    designationController = TextEditingController();

    nameController.addListener(_updateFormState);
    phoneController.addListener(_updateFormState);
    designationController.addListener(_updateFormState);

    fetchCompany();
    fetchMembers();
    _markOnboardingAsShown();
  }

  Future<void> _markOnboardingAsShown() async {
    // Mark as shown so subsequent app launches go to Dashboard
    await _saveOnboardingProgressUseCase(
      SaveOnboardingProgressParams(completed: true),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    designationController.dispose();
    super.onClose();
  }

  void _updateFormState() {
    isFormValid.value =
        nameController.text.trim().isNotEmpty &&
        phoneController.text.trim().length == 10 &&
        designationController.text.trim().isNotEmpty;

    isDirty.value =
        nameController.text.trim().isNotEmpty ||
        phoneController.text.trim().isNotEmpty ||
        designationController.text.trim().isNotEmpty ||
        selectedGender.value != null ||
        avatarPath.value != null;
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );
    if (image != null) {
      avatarPath.value = image.path;
      _updateFormState();
    }
  }

  void removeImage() {
    avatarPath.value = null;
    _updateFormState();
  }

  void setGender(Gender? gender) {
    selectedGender.value = gender;
    _updateFormState();
  }

  Future<void> fetchCompany() async {
    final result = await _getCompanyUseCase(const NoParams());

    result.fold(
      (failure) {
        // If company is not found, we might need to handle it
        // For now just show error
        AppSnackbar.destructive(failure.message);
      },
      (data) {
        company.value = data;
      },
    );
  }

  Future<void> fetchMembers() async {
    isFetching.value = true;
    final result = await _getTeamMembersUseCase(const NoParams());

    result.fold(
      (failure) {
        isFetching.value = false;
        AppSnackbar.destructive(failure.message);
      },
      (data) {
        isFetching.value = false;
        members.assignAll(data);
        initialMembersCount.value = data.length;
      },
    );
  }

  Future<void> addMember() async {
    hasSubmitted.value = true;
    if (!formKey.currentState!.validate()) return;

    final companyUid = company.value?.uid;
    if (companyUid == null) {
      AppSnackbar.destructive(AppStrings.addTeamMember.companyNotLoaded);
      return;
    }

    isLoading.value = true;
    final result = await _addTeamMemberUseCase(
      AddTeamMemberParams(
        name: nameController.text.trim(),
        phone: '${AppStrings.common.countryCode}${phoneController.text.trim()}',
        companyUid: companyUid,
        designation: designationController.text.trim(),
        imagePath: avatarPath.value,
        gender: selectedGender.value,
      ),
    );

    result.fold(
      (failure) {
        isLoading.value = false;
        AppSnackbar.destructive(failure.message);
      },
      (newMember) {
        isLoading.value = false;
        AppSnackbar.success(AppStrings.addTeamMember.successMessage);

        // Add to local list immediately for snappy UI
        members.add(newMember);

        // Reset form
        resetForm();

        // Close details page and return the new member
        Get.back(result: newMember);
      },
    );
  }

  void resetForm() {
    nameController.clear();
    phoneController.clear();
    designationController.clear();
    selectedGender.value = null;
    avatarPath.value = null;
    isDirty.value = false;
    hasSubmitted.value = false;
  }

  void handleClosePage(VoidCallback onDiscard) {
    if (isDirty.value) {
      onDiscard();
    } else {
      Get.back();
    }
  }

  void navigateToAddMemberDetails() {
    resetForm();
    Get.toNamed(AppRoutes.owner.addMemberDetails);
  }

  void handleBackNavigation(VoidCallback showDiscardDialog) {
    if (isDirty.value) {
      showDiscardDialog();
    } else {
      Get.back();
    }
  }

  void discardChangesAndBack() {
    resetForm();
    Get.back(); // Close dialog if open
    Get.back(); // Close page
  }

  Future<void> completeOnboarding() async {
    // Navigation to dashboard
    Get.offAllNamed(AppRoutes.owner.dashboard);
  }

  bool get hasAddedNewMember => members.length > initialMembersCount.value;
}
