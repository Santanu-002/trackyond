import 'package:trackyond/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/features/owner/jobs/domain/usecases/create_job_use_case.dart';
import 'package:trackyond/core/common/entities/member/team_member_status_entity.dart';
import 'package:trackyond/features/owner/team_status/domain/usecases/get_team_status_use_case.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/owner/jobs/presentation/widgets/worker/worker_picker_sheet.dart';
import 'package:trackyond/features/owner/settings/presentation/controllers/owner_settings_controller.dart';

class CreateJobController extends GetxController {
  final CreateJobUseCase _createJobUseCase;
  final GetTeamStatusUseCase _getTeamStatusUseCase;
  
  final formKey = GlobalKey<FormState>();
  
  // Text Controllers
  final workController = TextEditingController();
  final customerNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  
  // Searchable Worker Selection
  final workerSearchQuery = ''.obs;
  final searchBy = 'All'.obs;
  final selectedWorker = Rxn<MemberProfile>();
  
  // Job Requirements
  final requirePhotoOnCompletion = false.obs;
  final captureLocation = true.obs; // Enabled by default
  final requirePhotoOnStart = false.obs;
  
  final isLoading = false.obs;
  final isWorkersLoading = false.obs;

  /// Optional callback to be called when job is created successfully.
  /// If provided, this controller will NOT call [Get.back].
  void Function(JobEntity)? onSuccess;

  // Pref Keys
  static const String _prefKeyPhotoOnCompletion = 'job_pref_photo_on_completion';
  static const String _prefKeyCaptureLocation = 'job_pref_capture_location';
  static const String _prefKeyPhotoOnStart = 'job_pref_photo_on_start';

  CreateJobController({
    required CreateJobUseCase createJobUseCase,
    required GetTeamStatusUseCase getTeamStatusUseCase,
  })  : _createJobUseCase = createJobUseCase,
        _getTeamStatusUseCase = getTeamStatusUseCase;

  @override
  void onInit() {
    super.onInit();
    _loadPreferences();
    // Initial fetch with limit 5
    fetchWorkers(limit: 5);
    
    // Listen to search query changes with debounce for API calls
    debounce(workerSearchQuery, (_) => fetchWorkers(), time: const Duration(milliseconds: 500));
    // Also re-fetch when search criteria changes
    ever(searchBy, (_) => fetchWorkers());
  }

  Future<void> _loadPreferences() async {
    final settingsController = Get.find<OwnerSettingsController>();
    requirePhotoOnCompletion.value = await settingsController.getBoolSetting(_prefKeyPhotoOnCompletion);
    captureLocation.value = await settingsController.getBoolSetting(_prefKeyCaptureLocation, defaultValue: true);
    requirePhotoOnStart.value = await settingsController.getBoolSetting(_prefKeyPhotoOnStart);
  }

  Future<void> _savePreferences() async {
    final settingsController = Get.find<OwnerSettingsController>();
    await settingsController.saveSetting(_prefKeyPhotoOnCompletion, requirePhotoOnCompletion.value);
    await settingsController.saveSetting(_prefKeyCaptureLocation, captureLocation.value);
    await settingsController.saveSetting(_prefKeyPhotoOnStart, requirePhotoOnStart.value);
  }

  // All workers fetched from backend
  final _allFetchedMembers = <TeamMemberStatusEntity>[].obs;

  List<TeamMemberStatusEntity> get filteredMembers {
    if (workerSearchQuery.isEmpty) {
      return _allFetchedMembers;
    }

    final query = workerSearchQuery.value.toLowerCase();
    return _allFetchedMembers.where((m) {
      final searchableString = switch (searchBy.value) {
        'Name' => m.profile.name,
        'Designation' => m.profile.designation,
        'Phone' => m.profile.phone,
        _ => '${m.profile.name} ${m.profile.designation} ${m.profile.phone}',
      };
      return searchableString.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> fetchWorkers({int? limit}) async {
    isWorkersLoading.value = true;
    
    // If we are searching, we fetch a larger batch (e.g. 50) to allow local filtering
    final effectiveLimit = workerSearchQuery.isEmpty ? (limit ?? 5) : 50;
    
    final result = await _getTeamStatusUseCase.call(GetTeamStatusParams(
      limit: effectiveLimit,
    ));
    
    isWorkersLoading.value = false;

    result.fold(
      (failure) => AppSnackbar.destructive(failure.message),
      (teamStatus) {
        _allFetchedMembers.assignAll(teamStatus.members);
      },
    );
  }


  void setWorker(MemberProfile? worker) {
    selectedWorker.value = worker;
  }

  Future<void> navigateToAddMemberDetails() async {
    final result = await Get.toNamed(AppRoutes.owner.addMemberDetails);
    if (result is MemberProfile) {
      // Create a status entity for the new member
      final entity = TeamMemberStatusEntity(profile: result);
      
      // Add to the list if not already there
      if (!_allFetchedMembers.any((m) => m.profile.uid == result.uid)) {
        _allFetchedMembers.insert(0, entity);
      }
      
      // Select the worker
      setWorker(result);
    }
  }

  String getSearchByLabel(String value) => switch (value) {
        'All' => AppStrings.teamStatus.searchByAll,
        'Name' => AppStrings.teamStatus.searchByName,
        'Designation' => AppStrings.teamStatus.searchByDesignation,
        'Phone' => AppStrings.teamStatus.searchByPhone,
        _ => value,
      };

  Future<void> showWorkerPicker(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppUIConstants.radius.radius$24),
        ),
      ),
      builder: (_) => const WorkerPickerSheet(),
    );
  }

  Future<void> createJob() async {
    if (formKey.currentState?.validate() != true) return;
    
    if (selectedWorker.value == null) {
      AppSnackbar.warn(AppStrings.createJob.assignWorkerWarning);
      return;
    }

    isLoading.value = true;
    
    final params = CreateJobParams(
      title: workController.text.trim(),
      customerName: customerNameController.text.trim(),
      customerPhone: '${AppStrings.common.countryCode}${phoneController.text.trim()}',
      customerAddress: addressController.text.trim(),
      description: null, // Optional, can add a controller for this if needed
      workerProfileUid: selectedWorker.value!.uid,
      requirePhotoOnStart: requirePhotoOnStart.value,
      requirePhotoOnComplete: requirePhotoOnCompletion.value,
      captureLocation: captureLocation.value,
    );

    final result = await _createJobUseCase.call(params);
    
    isLoading.value = false;

    result.fold(
      (failure) => AppSnackbar.destructive(failure.message),
      (job) {
        _savePreferences();
        AppSnackbar.success(AppStrings.createJob.createJobSuccess);
        
        // Reset form
        _clearForm();
        
        if (onSuccess != null) {
          onSuccess!(job);
        } else {
          // Return the fresh job to the previous screen (Dashboard)
          Get.back(result: job);
        }
      },
    );
  }

  void _clearForm() {
    workController.clear();
    customerNameController.clear();
    phoneController.clear();
    addressController.clear();
    selectedWorker.value = null;
    workerSearchQuery.value = '';
  }

  @override
  void onClose() {
    workController.dispose();
    customerNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
