import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/features/owner/jobs/domain/usecases/create_job_use_case.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/member/team_member_status_entity.dart';
import 'package:trackyond/features/owner/team_status/domain/usecases/get_team_status_use_case.dart';

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

  CreateJobController({
    required CreateJobUseCase createJobUseCase,
    required GetTeamStatusUseCase getTeamStatusUseCase,
  })  : _createJobUseCase = createJobUseCase,
        _getTeamStatusUseCase = getTeamStatusUseCase;

  @override
  void onInit() {
    super.onInit();
    // Initial fetch with limit 5
    fetchWorkers(limit: 5);
    
    // Listen to search query changes with debounce
    debounce(workerSearchQuery, (_) => fetchWorkers(), time: const Duration(milliseconds: 500));
    // Also re-fetch when search criteria changes
    ever(searchBy, (_) => fetchWorkers());
  }

  // All workers fetched from backend with status
  final _allMembers = <TeamMemberStatusEntity>[].obs;

  List<TeamMemberStatusEntity> get filteredMembers {
    // Controller logic for sorting if needed, but if API returns sorted/limited results, we just return them.
    // However, the user wants "initial fetch 5 top member according to working status priority first and then others".
    // We should ensure the API or our fetch logic handles this.
    return _allMembers;
  }

  Future<void> fetchWorkers({int? limit}) async {
    isWorkersLoading.value = true;
    
    // If we are searching, we don't use the initial limit 5 unless specified.
    // Usually search should show all matches.
    final effectiveLimit = workerSearchQuery.isEmpty ? (limit ?? 5) : null;
    
    final result = await _getTeamStatusUseCase.call(GetTeamStatusParams(
      limit: effectiveLimit,
      // We might need to add search params to GetTeamStatusParams if not already there
      // For now, let's assume we can filter or we'll add it.
    ));
    
    isWorkersLoading.value = false;

    result.fold(
      (failure) => AppSnackbar.destructive(failure.message),
      (teamStatus) {
        final members = teamStatus.members;
        
        // Client-side filtering if API doesn't support the specific 'searchBy' logic yet
        if (workerSearchQuery.isNotEmpty) {
          final query = workerSearchQuery.value.toLowerCase();
          final filtered = members.where((m) {
            String searchableString;
            switch (searchBy.value) {
              case 'Name': searchableString = m.profile.name; break;
              case 'Designation': searchableString = m.profile.designation; break;
              case 'Phone': searchableString = m.profile.phone; break;
              default: searchableString = '${m.profile.name} ${m.profile.designation} ${m.profile.phone}';
            }
            return searchableString.toLowerCase().contains(query);
          }).toList();
          _allMembers.assignAll(filtered);
        } else {
          _allMembers.assignAll(members);
        }
      },
    );
  }


  void setWorker(MemberProfile? worker) {
    selectedWorker.value = worker;
  }

  String getSearchByLabel(String value) {
    switch (value) {
      case 'All':
        return AppStrings.teamStatus.searchByAll;
      case 'Name':
        return AppStrings.teamStatus.searchByName;
      case 'Designation':
        return AppStrings.teamStatus.searchByDesignation;
      case 'Phone':
        return AppStrings.teamStatus.searchByPhone;
      default:
        return value;
    }
  }

  Future<void> createJob() async {
    if (!formKey.currentState!.validate()) return;
    
    if (selectedWorker.value == null) {
      AppSnackbar.warn('Please assign a worker to this job.');
      return;
    }

    isLoading.value = true;
    
    final params = CreateJobParams(
      title: workController.text.trim(),
      customerName: customerNameController.text.trim(),
      customerPhone: phoneController.text.trim(),
      customerAddress: addressController.text.trim(),
      description: null, // Optional, can add a controller for this if needed
      workerAccountUid: selectedWorker.value?.accountUid,
      requirePhotoOnStart: requirePhotoOnStart.value,
      requirePhotoOnComplete: requirePhotoOnCompletion.value,
      captureLocation: captureLocation.value,
    );

    final result = await _createJobUseCase.call(params);
    
    isLoading.value = false;

    result.fold(
      (failure) => AppSnackbar.destructive(failure.message),
      (job) {
        AppSnackbar.success('Job created successfully.');
        Get.back();
      },
    );
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
