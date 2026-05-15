import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/entities/job/job_summary_stats.dart';
import 'package:trackyond/core/common/entities/member/team_member_status_entity.dart';
import 'package:trackyond/core/common/enums/stats_filter.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';
import 'package:trackyond/features/notification/presentation/controllers/notification_controller.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/drawer_item_config.dart';
import 'package:trackyond/features/owner/dashboard/domain/entities/task_stat_config.dart';
import 'package:trackyond/features/owner/dashboard/domain/usecases/get_owner_dashboard_use_case.dart';
import 'package:trackyond/features/owner/settings/presentation/controllers/owner_settings_controller.dart';

class OwnerDashboardController extends GetxController {
  final GetOwnerDashboardUseCase _getOwnerDashboardUseCase;

  OwnerDashboardController({
    required GetOwnerDashboardUseCase getOwnerDashboardUseCase,
  }) : _getOwnerDashboardUseCase = getOwnerDashboardUseCase;

  final authController = Get.find<AuthController>();
  final settingsController = Get.find<OwnerSettingsController>();

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
    _loadStatsFilter();
  }

  @override
  void onReady() {
    super.onReady();
    fetchDashboardData();
  }

  final title = AppStrings.ownerDashboard.title.obs;
  int get notificationCount => Get.find<NotificationController>().unreadCount.value;
  final isLoading = false.obs;
  final isProfileLoading = false.obs;

  final teamMembers = <TeamMemberStatusEntity>[].obs;
  final recentJobs = <JobEntity>[].obs;
  
  final _todayStats = const JobSummaryStats().obs;
  final _overallStats = const JobSummaryStats().obs;
  final selectedStatsFilter = StatsFilter.today.obs;

  JobSummaryStats get dashboardStats =>
      selectedStatsFilter.value == StatsFilter.today
      ? _todayStats.value
      : _overallStats.value;

  final ownerName = 'Owner'.obs;
  final ownerPhone = ''.obs;
  final companyName = 'Company'.obs;

  Future<void> _loadStatsFilter() async {
    selectedStatsFilter.value = await settingsController.dashboardStatsFilter;
  }

  Future<void> setStatsFilter(StatsFilter filter) async {
    selectedStatsFilter.value = filter;
    await settingsController.saveDashboardStatsFilter(filter);
  }

  Future<void> _loadUserInfo() async {
    isProfileLoading.value = true;
    ownerName.value = await authController.ownerName;
    ownerPhone.value = await authController.ownerPhone;
    companyName.value = await authController.companyName;
    isProfileLoading.value = false;
  }

  Future<void> fetchDashboardData() async {
    isLoading.value = true;
    final result = await _getOwnerDashboardUseCase(NoParams());

    result.fold((failure) => AppSnackbar.destructive(failure.message), (data) {
      teamMembers.assignAll(data.teamMembersStatus);
      _todayStats.value = data.jobCounts.todayStats;
      _overallStats.value = data.jobCounts.overallStats;
      recentJobs.assignAll(data.recentJobs);
      
      // Sync unread notification count
      Get.find<NotificationController>().unreadCount.value = data.unreadNotificationCount;
    });
    isLoading.value = false;
  }

  List<TaskStatConfig> get taskStats => [
    TaskStatConfig(
      label: AppStrings.ownerDashboard.pending,
      value: dashboardStats.pending,
      icon: AppIcons.dashboard.timer,
      color: Get.theme.colorScheme.pending,
    ),
    TaskStatConfig(
      label: AppStrings.ownerDashboard.progress,
      value: dashboardStats.inProgress,
      icon: AppIcons.dashboard.active,
      color: Get.theme.colorScheme.inProgress,
    ),
    TaskStatConfig(
      label: AppStrings.ownerDashboard.completed,
      value: dashboardStats.completed,
      icon: AppIcons.dashboard.completed,
      color: Get.theme.colorScheme.completed,
    ),
    TaskStatConfig(
      label: AppStrings.ownerDashboard.cancelled,
      value: dashboardStats.cancelled,
      icon: AppIcons.dashboard.cancelled,
      color: Get.theme.colorScheme.cancelled,
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
    Get.toNamed(AppRoutes.common.notifications);
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

      // Update stats (both today and overall)
      _todayStats.value = _todayStats.value.copyWith(pending: _todayStats.value.pending + 1);
      _overallStats.value = _overallStats.value.copyWith(pending: _overallStats.value.pending + 1);

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
    Get.toNamed(AppRoutes.owner.jobDetails, arguments: job);
  }
}
