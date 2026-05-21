import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/entities/attendance/attendance_entity.dart';
import 'package:trackyond/core/common/enums/attendance_status.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';
import 'package:trackyond/features/worker/attendance/domain/usecases/end_attendance_usecase.dart';
import 'package:trackyond/features/worker/attendance/domain/usecases/get_attendance_status_usecase.dart';
import 'package:trackyond/features/worker/attendance/domain/usecases/start_attendance_usecase.dart';

class AttendanceController extends GetxController {
  final StartAttendanceUseCase _startAttendanceUseCase;
  final EndAttendanceUseCase _endAttendanceUseCase;
  final GetAttendanceStatusUseCase _getAttendanceStatusUseCase;

  AttendanceController({
    required StartAttendanceUseCase startAttendanceUseCase,
    required EndAttendanceUseCase endAttendanceUseCase,
    required GetAttendanceStatusUseCase getAttendanceStatusUseCase,
  })  : _startAttendanceUseCase = startAttendanceUseCase,
        _endAttendanceUseCase = endAttendanceUseCase,
        _getAttendanceStatusUseCase = getAttendanceStatusUseCase;

  Timer? _timer;

  // Observables
  final attendanceStatus = AttendanceStatus.notStarted.obs;
  final attendanceInfo = Rxn<AttendanceEntity>();
  final punchInTime = Rxn<DateTime>();
  final currentLocation = RxnString();
  final elapsedTime = '00:00:00'.obs;
  final isActionLoading = false.obs;
  final actionLoadingMessage = RxnString();

  // Location Status
  final isLocationEnabled = false.obs;
  final locationPermission = LocationPermission.denied.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAndRequestLocationPermission();
    fetchAttendanceStatus();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _checkAndRequestLocationPermission() async {
    final isEnabled = await Geolocator.isLocationServiceEnabled();
    isLocationEnabled.value = isEnabled;

    final permission = await Geolocator.checkPermission();
    locationPermission.value = permission;
  }

  Future<void> _requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    locationPermission.value = permission;

    final isEnabled = await Geolocator.isLocationServiceEnabled();
    isLocationEnabled.value = isEnabled;
  }

  Future<void> fetchAttendanceStatus() async {
    final profile = await Get.find<AuthController>().profile;
    final profileUid = profile?.uid;
    if (profileUid == null) {
      debugPrint("profileUid is null in fetchAttendanceStatus");
      return;
    }
    final result = await _getAttendanceStatusUseCase(
      GetAttendanceStatusParams(profileUid: profileUid),
    );
    result.fold(
      (failure) => AppSnackbar.destructive(failure.message),
      (data) {
        attendanceStatus.value = data.status;
        attendanceInfo.value = data.attendance;

        if (data.status == AttendanceStatus.working && data.attendance != null) {
          currentLocation.value = data.attendance!.startAddress;
          startTimer(data.attendance!.startAt);
        } else {
          stopTimer();
          currentLocation.value = null;
        }
      },
    );
  }

  Future<void> _setPhase(String message) async {
    actionLoadingMessage.value = message;
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> startMyDay() async {
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
        await _requestLocationPermission();
        if (locationPermission.value == LocationPermission.denied ||
            locationPermission.value == LocationPermission.deniedForever) {
          isActionLoading.value = false;
          actionLoadingMessage.value = null;
          return;
        }
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
      final position = await Geolocator.getCurrentPosition(
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

      result.fold(
        (failure) => AppSnackbar.destructive(failure.message),
        (attendance) {
          attendanceStatus.value = AttendanceStatus.working;
          attendanceInfo.value = attendance;
          currentLocation.value = attendance.startAddress;
          startTimer(DateTime.now());
          AppSnackbar.success(AppStrings.workerDashboard.workDayStarted);
        },
      );
    } catch (e) {
      AppSnackbar.destructive(e.toString());
    } finally {
      isActionLoading.value = false;
      actionLoadingMessage.value = null;
    }
  }

  Future<void> endMyDay() async {
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
        await _requestLocationPermission();
        if (locationPermission.value == LocationPermission.denied ||
            locationPermission.value == LocationPermission.deniedForever) {
          isActionLoading.value = false;
          actionLoadingMessage.value = null;
          return;
        }
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

      result.fold(
        (failure) => AppSnackbar.destructive(failure.message),
        (attendance) {
          attendanceStatus.value = AttendanceStatus.notStarted;
          attendanceInfo.value = attendance;
          stopTimer();
          currentLocation.value = null;
          AppSnackbar.success(AppStrings.workerDashboard.workDayEnded);
        },
      );
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
    punchInTime.value = startTime;

    void tick() {
      final now = DateTime.now().toUtc();
      final start = startTime.toUtc();
      final duration = now.difference(start);

      final totalSeconds = (duration.inMilliseconds / 1000).round();
      final displaySeconds = totalSeconds < 0 ? 0 : totalSeconds;

      final hours = (displaySeconds ~/ 3600).toString().padLeft(2, '0');
      final minutes = ((displaySeconds % 3600) ~/ 60).toString().padLeft(2, '0');
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
}
