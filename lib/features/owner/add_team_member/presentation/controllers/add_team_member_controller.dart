import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/enums/gender.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/owner/add_team_member/domain/usecases/add_team_member_usecase.dart';
import 'package:trackyond/features/owner/add_team_member/domain/usecases/get_team_members_usecase.dart';
import 'package:trackyond/features/owner/add_team_member/domain/usecases/save_onboarding_progress_use_case.dart';

class AddTeamMemberController extends GetxController {
  final AddTeamMemberUseCase _addTeamMemberUseCase;
  final GetTeamMembersUseCase _getTeamMembersUseCase;
  final SaveOnboardingProgressUseCase _saveOnboardingProgressUseCase;

  AddTeamMemberController({
    required AddTeamMemberUseCase addTeamMemberUseCase,
    required GetTeamMembersUseCase getTeamMembersUseCase,
    required SaveOnboardingProgressUseCase saveOnboardingProgressUseCase,
  }) : _addTeamMemberUseCase = addTeamMemberUseCase,
       _getTeamMembersUseCase = getTeamMembersUseCase,
       _saveOnboardingProgressUseCase = saveOnboardingProgressUseCase;

  // ------------------ CONTROLLERS & FORM KEY ------------------
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  final formKey = GlobalKey<FormState>();

  // ------------------ STATE ------------------
  final isLoading = false.obs;
  final isFetching = false.obs;
  final isFormValid = false.obs;
  final members = <MemberProfile>[].obs;

  // Bottom Sheet Form State
  final selectedGender = Rxn<Gender>();
  final avatarPath = RxnString();
  final isDirty = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    phoneController = TextEditingController();

    nameController.addListener(_updateFormState);
    phoneController.addListener(_updateFormState);

    fetchMembers();
    _markOnboardingAsShown();
  }

  Future<void> _markOnboardingAsShown() async {
    // Mark as shown so subsequent app launches go to Dashboard
    await _saveOnboardingProgressUseCase.call(
      SaveOnboardingProgressParams(completed: true),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void _updateFormState() {
    isFormValid.value =
        nameController.text.trim().isNotEmpty &&
        phoneController.text.trim().length == 10;

    isDirty.value =
        nameController.text.trim().isNotEmpty ||
        phoneController.text.trim().isNotEmpty ||
        selectedGender.value != null ||
        avatarPath.value != null;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      avatarPath.value = image.path;
      _updateFormState();
    }
  }

  void setGender(Gender? gender) {
    selectedGender.value = gender;
    _updateFormState();
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
      },
    );
  }

  Future<void> addMember() async {
    if (!isFormValid.value) return;

    isLoading.value = true;
    final result = await _addTeamMemberUseCase.call(
      AddTeamMemberParams(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        imagePath: avatarPath.value,
        gender: selectedGender.value,
      ),
    );

    result.fold(
      (failure) {
        isLoading.value = false;
        AppSnackbar.destructive(failure.message);
      },
      (_) async {
        isLoading.value = false;
        AppSnackbar.success(AppStrings.addTeamMember.successMessage);

        // Reset form
        resetForm();

        // Refresh list
        await fetchMembers();

        // Close bottom sheet
        Get.back();
      },
    );
  }

  void resetForm() {
    nameController.clear();
    phoneController.clear();
    selectedGender.value = null;
    avatarPath.value = null;
    isDirty.value = false;
  }

  void handleCloseBottomSheet(VoidCallback onCancel) {
    if (isDirty.value) {
      onCancel();
    } else {
      Get.back();
    }
  }

  Future<void> completeOnboarding() async {
    // Navigation to dashboard
    Get.offAllNamed(AppRoutes.owner.dashboard);
  }
}
