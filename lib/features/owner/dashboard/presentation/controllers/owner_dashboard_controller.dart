import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/services/user/user_service.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/logout_usecase.dart';

import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/features/owner/dashboard/domain/usecases/get_team_status_usecase.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/team_status_query_options.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/dashboard_stats.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/drawer_item_config.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/recent_job.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/task_stat_config.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/team_member_status.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/team_status_result.dart';

class OwnerDashboardController extends GetxController {
  final LogoutUseCase _logoutUseCase;
  final GetTeamStatusUseCase _getTeamStatusUseCase;
  final UserService _userService;

  OwnerDashboardController({
    required LogoutUseCase logoutUseCase,
    required GetTeamStatusUseCase getTeamStatusUseCase,
    required UserService userService,
  })  : _logoutUseCase = logoutUseCase,
        _getTeamStatusUseCase = getTeamStatusUseCase,
        _userService = userService;

  @override
  void onReady() {
    super.onReady();
    fetchTeamStatus();
  }

  final title = AppStrings.ownerDashboard.title.obs;
  final notificationCount = 3.obs;
  final isTeamLoading = false.obs;

  String get ownerName => _userService.getProfile()?.name ?? 'Owner';
  String get companyName => _userService.getCompany()?.companyName ?? 'Company';
  String get ownerPhone => '+91 98765 43210'; // Mocked

  final teamMembers = <TeamMemberStatus>[].obs;

  final stats = DashboardStats(
    pending: 5,
    inProgress: 3,
    completed: 8,
  ).obs;

  Future<void> fetchTeamStatus() async {
    isTeamLoading.value = true;
    final Either<AppFailure, TeamStatusResult> result = await _getTeamStatusUseCase(
      GetTeamStatusParams(
        options: const TeamStatusQueryOptions(limit: 5),
      ),
    );

    result.fold(
      (failure) => AppSnackbar.destructive(failure.message),
      (teamStatus) {
        teamMembers.assignAll(teamStatus.members);
      },
    );
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
    final result = await _logoutUseCase(NoParams());
    result.fold(
      (failure) => AppSnackbar.destructive(failure.message),
      (_) => Get.offAllNamed(AppRoutes.common.auth.chooseRole),
    );
  }

  void openDrawer() {
    Scaffold.of(Get.context!).openDrawer();
  }

  void openNotifications() {
    // Navigate to notifications or show overlay
  }

  void goToJobs() {
    Get.toNamed(AppRoutes.owner.jobs);
  }

  void goToTeam() {
    Get.toNamed(AppRoutes.owner.team);
  }
}
