import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/dashboard_stats.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/drawer_item_config.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/recent_job.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/task_stat_config.dart';
import 'package:trackyond/features/owner/team_status/domain/entities/member/team_member_status_entity.dart';
import 'package:trackyond/features/owner/team_status/domain/usecases/get_team_status_use_case.dart';

class OwnerDashboardController extends GetxController {
  final GetTeamStatusUseCase _getTeamStatusUseCase;

  OwnerDashboardController({required GetTeamStatusUseCase getTeamStatusUseCase})
    : _getTeamStatusUseCase = getTeamStatusUseCase;

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
  }

  @override
  void onReady() {
    super.onReady();
    _fetchTeamStatus();
  }

  final title = AppStrings.ownerDashboard.title.obs;
  final notificationCount = 3.obs;
  final isTeamLoading = false.obs;

  final ownerName = 'Owner'.obs;
  final ownerPhone = ''.obs;
  final companyName = 'Company'.obs;

  final teamMembers = <TeamMemberStatusEntity>[].obs;

  final stats = DashboardStats(pending: 5, inProgress: 3, completed: 8).obs;

  Future<void> _loadUserInfo() async {
    final authController = Get.find<AuthController>();
    ownerName.value = await authController.ownerName;
    ownerPhone.value = await authController.ownerPhone;
    companyName.value = await authController.companyName;
  }

  Future<void> _fetchTeamStatus() async {
    isTeamLoading.value = true;
    final result = await _getTeamStatusUseCase(GetTeamStatusParams(limit: 5));

    result.fold((failure) => AppSnackbar.destructive(failure.message), (
      teamStatus,
    ) {
      teamMembers.assignAll(teamStatus.members);
    });
    isTeamLoading.value = false;
  }

  final recentJobs = <RecentJob>[
    const RecentJob(
      title: 'Apartment Deep Clean',
      location: 'Skyline Heights, Tower A',
      budget: 1500.0,
      status: 'Ongoing',
      isOngoing: true,
    ),
    const RecentJob(
      title: 'Office Painting',
      location: 'Tech Park, Block 5',
      budget: 4200.0,
      status: 'Starting Soon',
      isOngoing: true,
    ),
    const RecentJob(
      title: 'Plumbing Repair',
      location: 'Green Valley, Villa 12',
      budget: 450.0,
      status: 'Completed',
      isOngoing: false,
    ),
  ].obs;

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
      icon: AppIcons.common.groups,
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

  void goToMemberProfile(TeamMemberStatusEntity member) {
    Get.toNamed(AppRoutes.owner.teamMemberProfile, arguments: member);
  }
}
