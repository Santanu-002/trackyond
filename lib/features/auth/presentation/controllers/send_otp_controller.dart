import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
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
      phoneError.value = AppStrings.sendOtp.invalidPhone;
      return;
    }

    final phone = '+91$phoneRaw';

    isLoading.value = true;
    phoneError.value = null;
    final result = await _sendOtpUseCase(
      SendOtpParams(phone: phone, role: role),
    );

    isLoading.value = false;

    result.fold((failure) => AppSnackbar.destructive(failure.message), (
      response,
    ) {
      Get.toNamed(
        AppRoutes.common.auth.verifyOtp,
        arguments: {'phone': phone, 'sendOtpResponse': response, 'role': role},
      );
    });
  }
}
