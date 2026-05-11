import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/dashboard_stats.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/drawer_item_config.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/task_stat_config.dart';
import 'package:trackyond/features/owner/dashboard/domain/usecases/get_owner_dashboard_use_case.dart';
import 'package:trackyond/core/common/entities/job_entity.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/member/team_member_status_entity.dart';

class OwnerDashboardController extends GetxController {
  final GetOwnerDashboardUseCase _getOwnerDashboardUseCase;

  OwnerDashboardController({
    required GetOwnerDashboardUseCase getOwnerDashboardUseCase,
  })  : _getOwnerDashboardUseCase = getOwnerDashboardUseCase;

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
  }

  @override
  void onReady() {
    super.onReady();
    fetchDashboardData();
  }

  final title = AppStrings.ownerDashboard.title.obs;
  final notificationCount = 3.obs;
  final isLoading = false.obs;

  final ownerName = 'Owner'.obs;
  final ownerPhone = ''.obs;
  final companyName = 'Company'.obs;

  final teamMembers = <TeamMemberStatusEntity>[].obs;
  final recentJobs = <JobEntity>[].obs;
  final stats = DashboardStats(pending: 0, inProgress: 0, completed: 0).obs;

  Future<void> _loadUserInfo() async {
    final authController = Get.find<AuthController>();
    ownerName.value = await authController.ownerName;
    ownerPhone.value = await authController.ownerPhone;
    companyName.value = await authController.companyName;
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    final result = await _getOwnerDashboardUseCase(NoParams());

    result.fold(
      (failure) => AppSnackbar.destructive(failure.message),
      (data) {
        teamMembers.assignAll(data.teamMembersStatus);
        stats.value = data.jobCounts;
        recentJobs.assignAll(data.recentJobs);
      },
    );
    isLoading.value = false;
  }

  List<TaskStatConfig> get taskStats => [
    TaskStatConfig(
      label: AppStrings.ownerDashboard.pending,
      value: stats.value.pending,
      icon: AppIcons.dashboard.recentHistory,
      color: Get.theme.colorScheme.pending,
    ),
    TaskStatConfig(
      label: AppStrings.ownerDashboard.progress,
      value: stats.value.inProgress,
      icon: AppIcons.dashboard.active,
      color: Get.theme.colorScheme.inProgress,
    ),
    TaskStatConfig(
      label: AppStrings.ownerDashboard.completed,
      value: stats.value.completed,
      icon: AppIcons.dashboard.completed,
      color: Get.theme.colorScheme.completed,
    ),
  ];

  List<DrawerItemConfig> get drawerItems => [
    DrawerItemConfig(
      icon: AppIcons.dashboard.dashboard,
      label: AppStrings.drawer.dashboard,
      route: AppRoutes.owner.dashboard,
    ),
    DrawerItemConfig(
      icon: AppIcons.common.team,
      label: AppStrings.drawer.team,
      route: AppRoutes.owner.team,
    ),
    DrawerItemConfig(
      icon: AppIcons.dashboard.assignment,
      label: AppStrings.drawer.jobs,
      route: AppRoutes.owner.jobs,
    ),
    DrawerItemConfig(
      icon: AppIcons.dashboard.insights,
      label: AppStrings.drawer.activity,
    ),
    DrawerItemConfig(
      icon: AppIcons.dashboard.wallet,
      label: AppStrings.drawer.billing,
    ),
    DrawerItemConfig(
      icon: AppIcons.dashboard.settings,
      label: AppStrings.drawer.settings,
    ),
  ];

  Future<void> logout() async {
    await Get.find<AuthController>().logout();
  }

  void openDrawer() {
    Scaffold.of(Get.context!).openDrawer();
  }

  void openNotifications() {
    //TODO: Navigate to notifications page
  }

  void goToJobs() {
    Get.toNamed(AppRoutes.owner.jobs);
  }

  void goToTeam() {
    Get.toNamed(AppRoutes.owner.team);
  }

  Future<void> goToCreateJob() async {
    final result = await Get.toNamed(AppRoutes.owner.createJob);
    if (result is JobEntity) {
      // Add to recent jobs list immediately
      recentJobs.insert(0, result);
      
      // Update stats
      stats.value = stats.value.copyWith(
        pending: stats.value.pending + 1,
      );
      
      // Optional: limit the list size
      if (recentJobs.length > 10) {
        recentJobs.removeLast();
      }
    }
  }

  void goToMemberProfile(TeamMemberStatusEntity member) {
    Get.toNamed(AppRoutes.owner.teamMemberProfile, arguments: member);
  }

  void goToJobDetails(JobEntity job) {
    AppSnackbar.info(AppStrings.common.underDevelopment);
  }
}
