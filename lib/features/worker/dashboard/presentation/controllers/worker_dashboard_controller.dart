import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_icons.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/features/attendance/domain/entities/attendance_entity.dart';
import 'package:trackyond/features/attendance/domain/usecases/end_attendance_usecase.dart';
import 'package:trackyond/features/attendance/domain/usecases/get_attendance_status_usecase.dart';
import 'package:trackyond/features/attendance/domain/usecases/start_attendance_usecase.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';
import 'package:trackyond/features/worker/dashboard/domain/entities/attendance_info_item.dart';

class WorkerDashboardController extends GetxController {
  final StartAttendanceUseCase _startAttendanceUseCase;
  final EndAttendanceUseCase _endAttendanceUseCase;
  final GetAttendanceStatusUseCase _getAttendanceStatusUseCase;

  WorkerDashboardController({
    required StartAttendanceUseCase startAttendanceUseCase,
    required EndAttendanceUseCase endAttendanceUseCase,
    required GetAttendanceStatusUseCase getAttendanceStatusUseCase,
  }) : _startAttendanceUseCase = startAttendanceUseCase,
       _endAttendanceUseCase = endAttendanceUseCase,
       _getAttendanceStatusUseCase = getAttendanceStatusUseCase;

  AppLifecycleListener? _lifecycleListener;
  Timer? _timer;

  // UI Observables
  final title = AppStrings.workerDashboard.title.obs;
  final _workerName = 'Worker'.obs;
  final _workerImage = RxnString();

  String get workerName => _workerName.value;

  String? get workerImage => _workerImage.value;

  // Workday State
  final attendanceStatus = AttendanceStatus.notStarted.obs;
  final attendanceInfo = Rxn<AttendanceEntity>();
  final punchInTime = Rxn<DateTime>();
  final currentLocation = RxnString();
  final elapsedTime = '00:00:00'.obs;
  final isActionLoading = false.obs;

  // Location Status
  final isLocationEnabled = false.obs;
  final locationPermission = LocationPermission.denied.obs;

  @override
  void onInit() {
    super.onInit();
    _initLifecycleListener();
    _checkAndRequestLocationPermission();

    _checkInitialStatus();
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

  Future<void> _checkInitialStatus() async {
    final profile = await Get.find<AuthController>().profile;
    if (profile == null) return;

    _workerName.value = profile.name;
    _workerImage.value = profile.image;

    final result = await _getAttendanceStatusUseCase(
      GetAttendanceStatusParams(accountUid: profile.accountUid),
    );

    result.fold((failure) => AppSnackbar.destructive(failure.message), (
      statusEntity,
    ) {
      attendanceStatus.value = statusEntity.status;
      attendanceInfo.value = statusEntity.attendance;

      if (statusEntity.status == AttendanceStatus.working &&
          statusEntity.attendance != null) {
        punchInTime.value = statusEntity.attendance!.startAt;
        currentLocation.value = statusEntity.attendance!.address;
        _startTimer();
      }
    });
  }

  void startMyDay() async {
    final profile = await Get.find<AuthController>().profile;
    final accountUid = profile?.accountUid;
    if (accountUid == null) return;

    isActionLoading.value = true;

    try {
      final permission = await Geolocator.checkPermission();
      locationPermission.value = permission;

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _requestLocationPermission();
        isActionLoading.value = false;
        return;
      }

      final isEnabled = await Geolocator.isLocationServiceEnabled();
      isLocationEnabled.value = isEnabled;
      if (!isEnabled) {
        AppSnackbar.warn(AppStrings.workerDashboard.locationDisabledMessage);
        isActionLoading.value = false;
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      );

      final address = await _getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      final result = await _startAttendanceUseCase(
        StartAttendanceParams(
          accountUid: accountUid,
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
        punchInTime.value = attendance.startAt;
        currentLocation.value =
            address ?? '${position.latitude}, ${position.longitude}';
        _startTimer();
        AppSnackbar.success(AppStrings.workerDashboard.workDayStarted);
      });
    } catch (e) {
      AppSnackbar.destructive(e.toString());
    } finally {
      isActionLoading.value = false;
    }
  }

  void endMyDay() async {
    final profile = await Get.find<AuthController>().profile;
    final accountUid = profile?.accountUid;
    if (accountUid == null) return;

    isActionLoading.value = true;

    try {
      final permission = await Geolocator.checkPermission();
      locationPermission.value = permission;

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _requestLocationPermission();
        isActionLoading.value = false;
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      );

      final address = await _getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      final result = await _endAttendanceUseCase(
        EndAttendanceParams(
          accountUid: accountUid,
          latitude: position.latitude,
          longitude: position.longitude,
          address: address,
        ),
      );

      result.fold((failure) => AppSnackbar.destructive(failure.message), (
        attendance,
      ) {
        attendanceStatus.value = AttendanceStatus.ended;
        attendanceInfo.value = attendance;
        _timer?.cancel();
      });
    } catch (e) {
      AppSnackbar.destructive(e.toString());
    } finally {
      isActionLoading.value = false;
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

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (punchInTime.value != null) {
        final duration = DateTime.now().difference(punchInTime.value!);
        final hours = duration.inHours.toString().padLeft(2, '0');
        final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
        final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
        elapsedTime.value = '$hours:$minutes:$seconds';
      }
    });
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

  void navigateToProfile() => Get.toNamed(AppRoutes.worker.profile);

  Future<void> logout() async => await Get.find<AuthController>().logout();
}
