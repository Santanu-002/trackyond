import 'dart:async';
import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/services/user/user_service.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/auth/domain/usecases/logout_usecase.dart';

class WorkerDashboardController extends GetxController {
  final LogoutUseCase _logoutUseCase;
  final UserService _userService;

  WorkerDashboardController({
    required LogoutUseCase logoutUseCase,
    required UserService userService,
  })  : _logoutUseCase = logoutUseCase,
        _userService = userService;

  final title = AppStrings.workerDashboard.title.obs;

  String get workerName => _userService.getProfile()?.name ?? 'Worker';

  // Workday state
  final isWorkDayStarted = false.obs;
  final punchInTime = Rxn<DateTime>();
  final currentLocation = RxnString();
  final elapsedTime = '00:00:00'.obs;
  Timer? _timer;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return AppStrings.workerDashboard.goodMorning;
    } else if (hour < 17) {
      return AppStrings.workerDashboard.goodAfternoon;
    } else {
      return AppStrings.workerDashboard.goodEvening;
    }
  }

  void startMyDay() async {
    // Mock location permission request
    final permissionGranted = await _mockRequestLocationPermission();
    if (permissionGranted) {
      isWorkDayStarted.value = true;
      punchInTime.value = DateTime.now();
      currentLocation.value = '123 Main St, Springfield'; // Mock location
      _startTimer();
    } else {
      Get.snackbar(
        AppStrings.workerDashboard.permissionDenied,
        AppStrings.workerDashboard.locationPermissionRequired,
      );
    }
  }

  void endMyDay() {
    isWorkDayStarted.value = false;
    _timer?.cancel();
    elapsedTime.value = '00:00:00';
    punchInTime.value = null;
    currentLocation.value = null;
  }

  Future<bool> _mockRequestLocationPermission() async {
    // Simulate delay for asking permission
    await Future.delayed(const Duration(seconds: 1));
    return true;
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

  void navigateToProfile() {
    Get.toNamed(AppRoutes.worker.profile);
  }

  Future<void> logout() async {
    final result = await _logoutUseCase(NoParams());
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (_) => Get.offAllNamed(AppRoutes.common.auth.chooseRole),
    );
  }
}
