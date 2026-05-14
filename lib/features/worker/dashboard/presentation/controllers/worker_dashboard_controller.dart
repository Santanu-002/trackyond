import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/entities/attendance/attendance_entity.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/entities/job/job_summary_stats.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/common/enums/stats_filter.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/core/network/api/request_extras.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';
import 'package:trackyond/features/notification/presentation/controllers/notification_controller.dart';
import 'package:trackyond/features/worker/attendance/domain/usecases/end_attendance_usecase.dart';
import 'package:trackyond/features/worker/attendance/domain/usecases/start_attendance_usecase.dart';
import 'package:trackyond/features/worker/dashboard/domain/entities/attendance_info_item.dart';
import 'package:trackyond/features/worker/dashboard/domain/usecases/get_worker_dashboard_use_case.dart';
import 'package:trackyond/features/worker/settings/presentation/controllers/worker_settings_controller.dart';

class WorkerDashboardController extends GetxController {
  final StartAttendanceUseCase _startAttendanceUseCase;
  final EndAttendanceUseCase _endAttendanceUseCase;
  final GetWorkerDashboardUseCase _getWorkerDashboardUseCase;

  WorkerDashboardController({
    required StartAttendanceUseCase startAttendanceUseCase,
    required EndAttendanceUseCase endAttendanceUseCase,
    required GetWorkerDashboardUseCase getWorkerDashboardUseCase,
  }) : _startAttendanceUseCase = startAttendanceUseCase,
       _endAttendanceUseCase = endAttendanceUseCase,
       _getWorkerDashboardUseCase = getWorkerDashboardUseCase;

  AppLifecycleListener? _lifecycleListener;
  Timer? _timer;

  final authController = Get.find<AuthController>();
  final settingsController = Get.find<WorkerSettingsController>();

  // UI Observables
  final title = AppStrings.workerDashboard.title.obs;

  final workerName = 'Worker'.obs;
  final workerImage = RxnString();

  final isProfileLoading = false.obs;
  final isDashboardLoading = false.obs;

  // Workday State
  final attendanceStatus = AttendanceStatus.notStarted.obs;
  final attendanceInfo = Rxn<AttendanceEntity>();
  final punchInTime = Rxn<DateTime>();
  final currentLocation = RxnString();
  final elapsedTime = '00:00:00'.obs;
  final isActionLoading = false.obs;
  final actionLoadingMessage = RxnString();

  // Dashboard Data State
  final recentJobs = <JobEntity>[].obs;
  final _todayStats = const JobSummaryStats().obs;
  final _overallStats = const JobSummaryStats().obs;
  final selectedStatsFilter = StatsFilter.today.obs;

  JobSummaryStats get dashboardStats =>
      selectedStatsFilter.value == StatsFilter.today
      ? _todayStats.value
      : _overallStats.value;

  // Location Status
  final isLocationEnabled = false.obs;
  final locationPermission = LocationPermission.denied.obs;

  @override
  void onInit() {
    super.onInit();
    _initLifecycleListener();
    _checkAndRequestLocationPermission();

    _loadUserInfo();
    _loadStatsFilter();
    fetchDashboardData();
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

  Future<void> fetchDashboardData() async {
    isDashboardLoading.value = true;
    final result = await _getWorkerDashboardUseCase(const NoParams());

    result.fold((failure) => AppSnackbar.destructive(failure.message), (data) {
      // Update Attendance Status
      attendanceStatus.value = data.attendanceStatus.status;
      attendanceInfo.value = data.attendanceStatus.attendance;

      if (data.attendanceStatus.status == AttendanceStatus.working &&
          data.attendanceStatus.attendance != null) {
        currentLocation.value = data.attendanceStatus.attendance!.startAddress;
        startTimer(data.attendanceStatus.attendance!.startAt);
      } else if (data.attendanceStatus.status == AttendanceStatus.notStarted) {
        stopTimer();
        currentLocation.value = null;
      }

      // Update Jobs and Stats
      recentJobs.assignAll(data.recentJobs);
      _todayStats.value = data.jobCounts.todayStats;
      _overallStats.value = data.jobCounts.overallStats;
    });
    isDashboardLoading.value = false;
  }

  @override
  void onClose() {
    _timer?.cancel();
    _lifecycleListener?.dispose();
    super.onClose();
  }

  void _initLifecycleListener() {
    _lifecycleListener = AppLifecycleListener(
      onResume: () async {
        await Future.delayed(const Duration(milliseconds: 500));

        _checkAndRequestLocationPermission();
      },
    );
  }

  void _checkAndRequestLocationPermission() async {
    // 1. Update GPS hardware status first
    final isEnabled = await Geolocator.isLocationServiceEnabled();
    isLocationEnabled.value = isEnabled;

    // 2. Update permission status
    final permission = await Geolocator.checkPermission();
    locationPermission.value = permission;

    if (permission == LocationPermission.denied) {
      _requestLocationPermission();
    }
  }

  Future<void> _requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    locationPermission.value = permission;

    // Sync hardware status after request as well
    final isEnabled = await Geolocator.isLocationServiceEnabled();
    isLocationEnabled.value = isEnabled;
  }

  Future<void> _setPhase(String message) async {
    actionLoadingMessage.value = message;
    await Future.delayed(const Duration(milliseconds: 800));
  }

  void startMyDay() async {
    final profile = await Get.find<AuthController>().profile;
    final profileUid = profile?.uid;
    if (profileUid == null) return;

    isActionLoading.value = true;
    await _setPhase(AppStrings.workerDashboard.checkingPermissions);

    try {
      final permission = await Geolocator.checkPermission();
      locationPermission.value = permission;

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _requestLocationPermission();
        isActionLoading.value = false;
        actionLoadingMessage.value = null;
        return;
      }

      final isEnabled = await Geolocator.isLocationServiceEnabled();
      isLocationEnabled.value = isEnabled;
      if (!isEnabled) {
        AppSnackbar.warn(AppStrings.workerDashboard.locationDisabledMessage);
        isActionLoading.value = false;
        actionLoadingMessage.value = null;
        return;
      }

      await _setPhase(AppStrings.workerDashboard.acquiringGps);
      final position =
          await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
            ),
          ).timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException(
                "Location request timed out. Please check your GPS.",
              );
            },
          );

      await _setPhase(AppStrings.workerDashboard.resolvingAddress);
      final address = await _getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      await _setPhase(AppStrings.workerDashboard.syncingWithServer);
      final result = await _startAttendanceUseCase(
        StartAttendanceParams(
          profileUid: profileUid,
          latitude: position.latitude,
          longitude: position.longitude,
          address: address,
        ),
      );

      result.fold((failure) => AppSnackbar.destructive(failure.message), (
        attendance,
      ) {
        attendanceStatus.value = AttendanceStatus.working;
        attendanceInfo.value = attendance;
        currentLocation.value = attendance.startAddress;
        startTimer(DateTime.now());
        AppSnackbar.success(AppStrings.workerDashboard.workDayStarted);
      });
    } catch (e) {
      AppSnackbar.destructive(e.toString());
    } finally {
      isActionLoading.value = false;
      actionLoadingMessage.value = null;
    }
  }

  void endMyDay() async {
    final profile = await Get.find<AuthController>().profile;
    final profileUid = profile?.uid;
    if (profileUid == null) return;

    isActionLoading.value = true;
    await _setPhase(AppStrings.workerDashboard.acquiringGps);

    try {
      final permission = await Geolocator.checkPermission();
      locationPermission.value = permission;

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _requestLocationPermission();
        isActionLoading.value = false;
        actionLoadingMessage.value = null;
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      await _setPhase(AppStrings.workerDashboard.resolvingAddress);
      final address = await _getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      await _setPhase(AppStrings.workerDashboard.endingSession);
      final result = await _endAttendanceUseCase(
        EndAttendanceParams(
          profileUid: profileUid,
          latitude: position.latitude,
          longitude: position.longitude,
          address: address,
        ),
      );

      result.fold((failure) => AppSnackbar.destructive(failure.message), (
        attendance,
      ) {
        attendanceStatus.value = AttendanceStatus.notStarted;
        attendanceInfo.value = attendance;
        stopTimer();
        currentLocation.value = null;
      });
    } catch (e) {
      AppSnackbar.destructive(e.toString());
    } finally {
      isActionLoading.value = false;
      actionLoadingMessage.value = null;
    }
  }

  Future<String?> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.name}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
      }
    } catch (e) {
      debugPrint("Error fetching address: $e");
    }
    return null;
  }

  void startTimer(DateTime startTime) {
    _timer?.cancel();

    // Set initial value
    punchInTime.value = startTime;

    void tick() {
      final now = DateTime.now().toUtc();
      final start = startTime.toUtc();
      final duration = now.difference(start);

      final totalSeconds = (duration.inMilliseconds / 1000).round();
      final displaySeconds = totalSeconds < 0 ? 0 : totalSeconds;

      final hours = (displaySeconds ~/ 3600).toString().padLeft(2, '0');
      final minutes = ((displaySeconds % 3600) ~/ 60).toString().padLeft(
        2,
        '0',
      );
      final seconds = (displaySeconds % 60).toString().padLeft(2, '0');
      elapsedTime.value = '$hours:$minutes:$seconds';
    }

    tick();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) => tick());
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    punchInTime.value = null;
    elapsedTime.value = '00:00:00';
  }

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
      pending: _todayStats.value.pending + 1, // Assuming new jobs are pending/assigned
    );

    _overallStats.value = _overallStats.value.copyWith(
      totalAssigned: _overallStats.value.totalAssigned + 1,
      pending: _overallStats.value.pending + 1,
    );

    debugPrint('WorkerDashboard updated reactively with new job: ${job.jobId}');
  }

  void openNotifications() {
    Get.find<NotificationController>().clearUnread();
    Get.toNamed(AppRoutes.common.notifications);
  }

  void goToJobs() => AppSnackbar.info(AppStrings.common.underDevelopment);

  void goToJobDetails(JobEntity job) {
    // TODO: Implement navigation to worker job details
    // Get.toNamed(AppRoutes.worker.jobDetails, arguments: job);
  }

  void navigateToProfile() => Get.toNamed(AppRoutes.worker.profile);

  Future<void> sendTestNotification() async {
    isActionLoading.value = true;
    try {
      final dio = Get.find<Dio>();
      final profile = await authController.profile;
      if (profile == null) return;
      
      final response = await dio.post(
        ApiEndpoints.admin.jobs, // Using admin endpoint to trigger creation
        data: {
          "title": "Mock Demo Job ${DateTime.now().second}",
          "customerName": "Demo Customer",
          "customerPhone": "0000000000",
          "workerProfileUid": profile.uid,
          "requirePhotoOnStart": false,
          "requirePhotoOnComplete": false,
          "captureLocation": false
        },
        options: Options(
          extra: {RequestExtras.userRole: UserRole.owner.value}, // Force owner role for admin endpoint
        ),
      );
      
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
