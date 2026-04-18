import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/entities/user/user_role.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/services/token/token_service.dart';
import 'package:trackyond/core/services/user/user_service.dart';
import 'package:trackyond/core/snackbar/app_snackbar.dart';
import 'package:trackyond/features/auth/domain/entities/send_otp_response_entity.dart';
import 'package:trackyond/features/auth/domain/usecases/send_otp_use_case.dart';
import 'package:trackyond/features/auth/domain/usecases/verify_otp_use_case.dart';

class VerifyOtpController extends GetxController {
  final VerifyOtpUseCase _verifyOtpUseCase;
  final SendOtpUseCase _sendOtpUseCase;
  final TokenService _tokenService;
  final UserService _userService;

  VerifyOtpController(
    this._verifyOtpUseCase,
    this._sendOtpUseCase,
    this._tokenService,
    this._userService,
  );

  late final String phone;
  late Rx<SendOtpResponseEntity> _session;
  SendOtpResponseEntity get session => _session.value;

  late final UserRole role;

  final otpController = TextEditingController();
  final isLoading = false.obs;
  final isOtpInvalid = false.obs;
  final remainingSeconds = 0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) {
      Get.back();
      return;
    }
    phone = args['phone'] as String;
    _session = (args['sendOtpResponse'] as SendOtpResponseEntity).obs;
    role = args['role'] as UserRole;

    _startTimer();
  }

  @override
  void onClose() {
    otpController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    _timer?.cancel();
    final now = DateTime.now();
    final resendAt =
        session.resendableAt ?? now.add(const Duration(seconds: 30));
    final diff = resendAt.difference(now).inSeconds;

    if (diff <= 0) {
      remainingSeconds.value = 0;
      return;
    }

    remainingSeconds.value = diff;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  String get title => AppStrings.verifyOtp.title;

  String get subtitle => AppStrings.verifyOtp.subtitle(maskedPhone);

  String get maskedPhone {
    final cleaned = phone.replaceAll(RegExp(r'\s+'), '');

    if (cleaned.startsWith('+91') && cleaned.length == 13) {
      final last3 = cleaned.substring(10); // last 3 digits
      return '+91 XXXXXXX$last3';
    }

    return phone;
  }

  Future<void> resendOtp() async {
    if (remainingSeconds.value > 0) return;

    isLoading.value = true;
    final result = await _sendOtpUseCase(
      SendOtpParams(phone: phone, role: role),
    );

    result.fold(
      (failure) {
        isLoading.value = false;
        AppSnackbar.error(failure.message);
      },
      (newSession) {
        isLoading.value = false;
        _session.value = newSession;
        otpController.clear();
        isOtpInvalid.value = false;
        _startTimer();
        AppSnackbar.success('OTP resent successfully');
      },
    );
  }

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();
    if (otp.isEmpty || otp.length < 6) {
      AppSnackbar.error('Please enter a valid 6-digit OTP');
      return;
    }

    isLoading.value = true;
    isOtpInvalid.value = false;

    final result = await _verifyOtpUseCase(
      VerifyOtpParams(phone: phone, otpId: session.otpId, otp: otp, role: role),
    );

    result.fold(
      (failure) {
        isLoading.value = false;
        // Check for specific OTP errors to trigger Pinput error state
        final msg = failure.message.toLowerCase();
        if (msg.contains('otp') || msg.contains('code') || msg.contains('verification')) {
          isOtpInvalid.value = true;
          // Optionally show a snackbar if it's more than just "Invalid OTP"
          if (!msg.contains('invalid')) {
             AppSnackbar.error(failure.message);
          }
        } else {
          AppSnackbar.error(failure.message);
        }
      },

      (tokens) async {
        // Save tokens and user role
        await _tokenService.saveTokens(tokens);
        await _userService.saveUserRole(role);

        isLoading.value = false;

        // Navigate to dashboard based on role
        if (role == UserRole.owner) {
          Get.offAllNamed(AppRoutes.owner.dashboard);
        } else {
          Get.offAllNamed(AppRoutes.worker.dashboard);
        }

        AppSnackbar.success('Logged in successfully');
      },
    );
  }
}
