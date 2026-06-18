import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/app/routes/app_routes.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/common/widgets/snackbar/app_snackbar.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/features/auth/domain/entities/send_otp_response_entity.dart';
import 'package:trackyond/features/auth/domain/usecases/send_otp_use_case.dart';
import 'package:trackyond/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:trackyond/features/auth/domain/usecases/connect_websocket_usecase.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';

class VerifyOtpController extends GetxController {
  final VerifyOtpUseCase _verifyOtpUseCase;
  final SendOtpUseCase _sendOtpUseCase;
  final ConnectWebSocketUseCase _connectWebSocketUseCase;

  VerifyOtpController({
    required VerifyOtpUseCase verifyOtpUseCase,
    required SendOtpUseCase sendOtpUseCase,
    required ConnectWebSocketUseCase connectWebSocketUseCase,
  }) : _verifyOtpUseCase = verifyOtpUseCase,
       _sendOtpUseCase = sendOtpUseCase,
       _connectWebSocketUseCase = connectWebSocketUseCase;

  late final String phone;
  late Rx<SendOtpResponseEntity> _session;

  SendOtpResponseEntity get session => _session.value;

  late final UserRole role;

  final otpController = TextEditingController();
  final isLoading = false.obs;
  final otpErrorText = RxnString();
  final remainingSeconds = 0.obs;
  Timer? _timer;
  late final TapGestureRecognizer resendRecognizer;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args == null) {
      Get.back();
      return;
    }

    _session = (args['sendOtpResponse'] as SendOtpResponseEntity).obs;
    role = args['role'] as UserRole;
    phone = _session.value.phone;

    resendRecognizer = TapGestureRecognizer()..onTap = resendOtp;
    _startTimer();
  }

  @override
  void onClose() {
    resendRecognizer.dispose();
    otpController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    _timer?.cancel();

    final now = DateTime.now().toUtc();
    // Ensure resendAt is treated as UTC
    final resendAt = session.resendableAt?.toUtc();

    if (resendAt == null) {
      remainingSeconds.value = 0;
      return;
    }

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

  String get formattedRemainingTime {
    final minutes = remainingSeconds.value ~/ 60;
    final seconds = remainingSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get title => AppStrings.verifyOtp.title;

  String get subtitle => AppStrings.verifyOtp.subtitle(maskedPhone);

  String get maskedPhone {
    final cleaned = phone.replaceAll(RegExp(r'\s+'), '');
    final countryCode = AppStrings.common.countryCode;

    if (cleaned.startsWith(countryCode) && cleaned.length == 13) {
      final last3 = cleaned.substring(10);
      return '$countryCode XXXXXXX$last3';
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
        AppSnackbar.destructive(failure.message);
      },
      (newSession) {
        isLoading.value = false;
        _session.value = newSession;
        otpController.clear();
        otpErrorText.value = null;
        _startTimer();
        AppSnackbar.success(AppStrings.sendOtp.otpResent);
      },
    );
  }

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();
    if (otp.isEmpty || otp.length < 6) {
      otpErrorText.value = AppStrings.verifyOtp.incompleteOtp;
      return;
    }

    isLoading.value = true;
    otpErrorText.value = null;

    final result = await _verifyOtpUseCase(
      VerifyOtpParams(phone: phone, otpId: session.otpId, otp: otp, role: role),
    );

    result.fold(
      (failure) {
        isLoading.value = false;
        final msg = failure.message.toLowerCase();
        if (msg.contains('otp') ||
            msg.contains('code') ||
            msg.contains('invalid')) {
          otpErrorText.value = AppStrings.verifyOtp.invalidOtp;
        } else {
          AppSnackbar.destructive(failure.message);
        }
      },
      (entity) async {
        isLoading.value = false;

        _connectWebSocketUseCase(const NoParams());

        if (entity.role == UserRole.owner) {
          if (entity.isNewUser) {
            Get.offAllNamed(
              AppRoutes.owner.setupCompany,
              arguments: <String, dynamic>{'phone': phone},
            );
          } else {
            Get.offAllNamed(AppRoutes.owner.addTeamMember);
          }
        } else {
          Get.offAllNamed(AppRoutes.worker.dashboard);
        }

        AppSnackbar.success(AppStrings.verifyOtp.loginSuccess);
      },
    );
  }
}
