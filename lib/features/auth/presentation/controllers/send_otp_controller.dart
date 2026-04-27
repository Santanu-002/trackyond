import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/auth/domain/usecases/send_otp_use_case.dart';

class SendOtpController extends GetxController {
  final SendOtpUseCase _sendOtpUseCase;

  SendOtpController({required SendOtpUseCase sendOtpUseCase})
    : _sendOtpUseCase = sendOtpUseCase;

  late final UserRole role;
  final phoneController = TextEditingController();
  final isLoading = false.obs;
  final phoneError =
      RxnString(); // null = no error, non-null = inline field error
  final showAccessDeniedBanner = false.obs;

  @override
  void onInit() {
    super.onInit();
    role = (Get.arguments as UserRole?) ?? UserRole.worker;
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  String get title => role == UserRole.owner
      ? AppStrings.sendOtp.ownerTitle
      : AppStrings.sendOtp.workerTitle;

  String get subtitle => role == UserRole.owner
      ? AppStrings.sendOtp.ownerSubtitle
      : AppStrings.sendOtp.workerSubtitle;

  void dismissBanner() => showAccessDeniedBanner.value = false;

  void switchRole() {
    dismissBanner();
    Get.offNamed(
      AppRoutes.common.auth.sendOtp,
      arguments: role == UserRole.owner ? UserRole.worker : UserRole.owner,
      preventDuplicates: false,
    );
  }

  Future<void> sendOtp() async {
    final phoneRaw = phoneController.text.trim();
    if (phoneRaw.isEmpty || phoneRaw.length < 10) {
      phoneError.value = AppStrings.sendOtp.invalidPhone;
      return;
    }

    final phone = '${AppStrings.common.countryCode}$phoneRaw';

    isLoading.value = true;
    phoneError.value = null;
    showAccessDeniedBanner.value = false;

    final result = await _sendOtpUseCase(
      SendOtpParams(phone: phone, role: role),
    );

    isLoading.value = false;

    result.fold((failure) {
      if (failure is AccessDeniedFailure) {
        showAccessDeniedBanner.value = true;
      } else {
        AppSnackbar.destructive(failure.message);
      }
    }, (response) {
      Get.toNamed(
        AppRoutes.common.auth.verifyOtp,
        arguments: {'sendOtpResponse': response, 'role': role},
      );
    });
  }
}
