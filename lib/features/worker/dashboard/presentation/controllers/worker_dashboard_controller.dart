import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/entities/attendance/attendance_entity.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/entities/job/job_summary_stats.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/common/enums/stats_filter.dart';
import 'package:trackyond/core/common/events/job_event.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';
import 'package:trackyond/features/notification/presentation/controllers/notification_controller.dart';
import 'package:trackyond/features/worker/attendance/presentation/controllers/attendance_controller.dart';
import 'package:trackyond/features/worker/dashboard/domain/entities/attendance_info_item.dart';
import 'package:trackyond/features/worker/dashboard/domain/usecases/get_worker_dashboard_use_case.dart';
import 'package:trackyond/features/worker/dashboard/domain/usecases/listen_job_events_use_case.dart';
import 'package:trackyond/features/worker/settings/presentation/controllers/worker_settings_controller.dart';

class WorkerDashboardController extends GetxController {
  final GetWorkerDashboardUseCase _getWorkerDashboardUseCase;
  final ListenJobEventsUseCase _listenJobEventsUseCase;

  WorkerDashboardController({
    required GetWorkerDashboardUseCase getWorkerDashboardUseCase,
    required ListenJobEventsUseCase listenJobEventsUseCase,
  }) : _getWorkerDashboardUseCase = getWorkerDashboardUseCase,
       _listenJobEventsUseCase = listenJobEventsUseCase;

  AppLifecycleListener? _lifecycleListener;

  final authController = Get.find<AuthController>();
  final settingsController = Get.find<WorkerSettingsController>();
  final attendanceController = Get.find<AttendanceController>();

  // UI Observables
  final title = AppStrings.workerDashboard.title.obs;

  int get notificationCount =>
      Get.find<NotificationController>().unreadCount.value;

  final workerName = 'Worker'.obs;
  final workerImage = RxnString();

  final isProfileLoading = false.obs;
  final isDashboardLoading = false.obs;

  // Workday State (delegated to permanent AttendanceController)
  Rx<AttendanceStatus> get attendanceStatus =>
      attendanceController.attendanceStatus;

  Rxn<AttendanceEntity> get attendanceInfo =>
      attendanceController.attendanceInfo;

  Rxn<DateTime> get punchInTime => attendanceController.punchInTime;

  RxnString get currentLocation => attendanceController.currentLocation;

  RxString get elapsedTime => attendanceController.elapsedTime;

  RxBool get isActionLoading => attendanceController.isActionLoading;

  RxnString get actionLoadingMessage =>
      attendanceController.actionLoadingMessage;

  // Dashboard Data State
  final recentJobs = <JobEntity>[].obs;
  final _todayStats = const JobSummaryStats().obs;
  final _overallStats = const JobSummaryStats().obs;
  final selectedStatsFilter = StatsFilter.today.obs;

  JobSummaryStats get dashboardStats =>
      selectedStatsFilter.value == StatsFilter.today
      ? _todayStats.value
      : _overallStats.value;

  // Location Status (delegated to permanent AttendanceController)
  RxBool get isLocationEnabled => attendanceController.isLocationEnabled;

  Rx<LocationPermission> get locationPermission =>
      attendanceController.locationPermission;

  StreamSubscription<JobEvent>? _jobEventsSubscription;

  @override
  void onInit() {
    super.onInit();
    _initLifecycleListener();

    _loadUserInfo();
    _loadStatsFilter();
    fetchDashboardData();
    _listenToJobEvents();
  }

  Future<void> _listenToJobEvents() async {
    final result = await _listenJobEventsUseCase(const NoParams());
    result.fold(
      (failure) =>
          debugPrint('Error listening to job events: ${failure.message}'),
      (stream) {
        _jobEventsSubscription = stream.listen((event) {
          switch (event) {
            case JobUpdatedEvent(:final job):
              onJobUpdated(job);
            case JobDeletedEvent(:final jobId):
              onJobDeleted(jobId);
          }
        });
      },
    );
  }

  void onJobUpdated(JobEntity updatedJob) {
    final index = recentJobs.indexWhere((j) => j.jobId == updatedJob.jobId);
    if (index != -1) {
      recentJobs[index] = updatedJob;
    } else {
      recentJobs.insert(0, updatedJob);
      if (recentJobs.length > 5) {
        recentJobs.removeLast();
      }
    }
    fetchDashboardData(silent: true);
  }

  void onJobDeleted(String jobId) {
    recentJobs.removeWhere((j) => j.jobId == jobId);
    fetchDashboardData(silent: true);
  }

  Future<void> _loadStatsFilter() async {
    selectedStatsFilter.value = await settingsController.dashboardStatsFilter;
  }

  Future<void> setStatsFilter(StatsFilter filter) async {
    selectedStatsFilter.value = filter;
    await settingsController.saveDashboardStatsFilter(filter);
  }

  Future<void> _loadUserInfo() async {
    isProfileLoading.value = true;
    final profile = await authController.profile;
    workerName.value = profile?.name ?? 'Worker';
    workerImage.value = profile?.image;
    isProfileLoading.value = false;
  }

  Future<void> fetchDashboardData({bool silent = false}) async {
    if (!silent) {
      isDashboardLoading.value = true;
    }
    final result = await _getWorkerDashboardUseCase(const NoParams());

    result.fold(
      (failure) {
        if (!silent) {
          AppSnackbar.destructive(failure.message);
        }
      },
      (data) {
        // Update Attendance Status in the permanent AttendanceController
        attendanceController.attendanceStatus.value =
            data.attendanceStatus.status;
        attendanceController.attendanceInfo.value =
            data.attendanceStatus.attendance;

        if (data.attendanceStatus.status == AttendanceStatus.working &&
            data.attendanceStatus.attendance != null) {
          attendanceController.currentLocation.value =
              data.attendanceStatus.attendance!.startAddress;
          attendanceController.startTimer(
            data.attendanceStatus.attendance!.startAt,
          );
        } else if (data.attendanceStatus.status ==
            AttendanceStatus.notStarted) {
          attendanceController.stopTimer();
          attendanceController.currentLocation.value = null;
        }

        // Update Jobs and Stats
        recentJobs.assignAll(data.recentJobs);
        _todayStats.value = data.jobCounts.todayStats;
        _overallStats.value = data.jobCounts.overallStats;

        // Sync unread notification count
        Get.find<NotificationController>().unreadCount.value =
            data.unreadNotificationCount;
      },
    );
    if (!silent) {
      isDashboardLoading.value = false;
    }
  }

  @override
  void onClose() {
    _jobEventsSubscription?.cancel();
    _lifecycleListener?.dispose();
    super.onClose();
  }

  void _initLifecycleListener() {
    _lifecycleListener = AppLifecycleListener(
      onResume: () async {
        await Future.delayed(const Duration(milliseconds: 500));
        // Refresh status through permanent controller
        attendanceController.fetchAttendanceStatus();
      },
    );
  }

  void startMyDay() => attendanceController.startMyDay();

  void endMyDay() => attendanceController.endMyDay();

  // Getters
  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppStrings.workerDashboard.goodMorning;
    if (hour < 17) return AppStrings.workerDashboard.goodAfternoon;
    return AppStrings.workerDashboard.goodEvening;
  }

  List<AttendanceInfoItem> get attendanceItems => [
    AttendanceInfoItem(
      icon: AppIcons.dashboard.location,
      value: currentLocation.value ?? "Unknown",
      type: AttendanceInfoType.location,
    ),
    AttendanceInfoItem(
      icon: AppIcons.dashboard.clock,
      value: punchInTime.value,
      type: AttendanceInfoType.clock,
    ),
    AttendanceInfoItem(
      icon: AppIcons.dashboard.timer,
      value: elapsedTime.value,
      type: AttendanceInfoType.timer,
    ),
    AttendanceInfoItem(
      icon: AppIcons.dashboard.calendar,
      value: DateTime.now(),
      type: AttendanceInfoType.calendar,
    ),
  ];

  Future<void> refreshDashboard() async {
    await fetchDashboardData();
  }

  void onNewJobReceived(JobEntity job) {
    // 1. Update Recent Jobs (Add to the top and keep only latest few if needed)
    // Here we just insert at the beginning
    if (!recentJobs.any((j) => j.jobId == job.jobId)) {
      recentJobs.insert(0, job);
      if (recentJobs.length > 5) {
        recentJobs.removeLast();
      }
    }

    // 2. Update Stats
    // For a new job assignment, totalAssigned and pending/assigned count increases.
    _todayStats.value = _todayStats.value.copyWith(
      totalAssigned: _todayStats.value.totalAssigned + 1,
      pending:
          _todayStats.value.pending +
          1, // Assuming new jobs are pending/assigned
    );

    _overallStats.value = _overallStats.value.copyWith(
      totalAssigned: _overallStats.value.totalAssigned + 1,
      pending: _overallStats.value.pending + 1,
    );

    debugPrint('WorkerDashboard updated reactively with new job: ${job.jobId}');
  }

  void openNotifications() {
    Get.toNamed(AppRoutes.common.notifications);
  }

  void goToJobs() => AppSnackbar.info(AppStrings.common.underDevelopment);

  void goToJobChat(JobEntity job) {
    Get.toNamed(AppRoutes.common.jobChat, arguments: job);
  }

  void navigateToProfile() => Get.toNamed(AppRoutes.worker.profile);

  Future<void> sendTestNotification() async {
    isActionLoading.value = true;
    try {
      final dio = Get.find<Dio>();
      final response = await dio.post(ApiEndpoints.employee.jobsMock);

      if (response.statusCode == 200) {
        AppSnackbar.success("Mock job sent! Wait for notification.");
      }
    } catch (e) {
      debugPrint("Error sending mock job: $e");
      AppSnackbar.destructive("Failed to send mock job");
    } finally {
      isActionLoading.value = false;
    }
  }

  Future<void> logout() async => await Get.find<AuthController>().logout();
}
