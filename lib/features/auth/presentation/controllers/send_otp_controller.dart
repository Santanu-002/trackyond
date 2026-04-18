import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/entities/user/user_role.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/snackbar/app_snackbar.dart';
import 'package:trackyond/features/auth/domain/usecases/send_otp_use_case.dart';

class SendOtpController extends GetxController {
  final SendOtpUseCase _sendOtpUseCase;

  SendOtpController(this._sendOtpUseCase);

  late final UserRole role;
  final phoneController = TextEditingController();
  final isLoading = false.obs;

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

  Future<void> sendOtp() async {
    final phoneRaw = phoneController.text.trim();
    if (phoneRaw.isEmpty || phoneRaw.length < 10) {
      AppSnackbar.error('Please enter a valid phone number');
      return;
    }

    final phone = '+91$phoneRaw';

    isLoading.value = true;
    final result = await _sendOtpUseCase(
      SendOtpParams(phone: phone, role: role),
    );
    isLoading.value = false;

    result.fold((failure) => AppSnackbar.error(failure.message), (response) {
      Get.toNamed(
        AppRoutes.common.auth.verifyOtp,
        arguments: {'phone': phone, 'sendOtpResponse': response, 'role': role},
      );
    });
  }
}
