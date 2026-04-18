import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/otp_input/app_otp_input.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/auth/presentation/controllers/verify_otp_controller.dart';

import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';

class VerifyOtpPage extends GetView<VerifyOtpController> {
  const VerifyOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.verifyOtp;

    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppUIConstants.spacing.space$32,
        children: [
          // Header Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppUIConstants.spacing.space$12,
            children: [
              Text(
                controller.title,
                style: context.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              Text(
                controller.subtitle,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.theme.colorScheme.onSurface.withValues(
                    alpha: 0.6,
                  ),
                  height: 1.5,
                ),
              ),
            ],
          ),

          // Input Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: AppUIConstants.spacing.space$24,
            children: [
              Obx(
                () => AppOtpInput(
                  controller: controller.otpController,
                  autofocus: true,
                  errorText: controller.otpErrorText.value,
                  onChanged: (_) {
                    if (controller.otpErrorText.value != null) {
                      controller.otpErrorText.value = null;
                    }
                  },
                  onCompleted: (pin) => controller.verifyOtp(),
                ),
              ),
              Obx(
                () => AppButton.filled(
                  text: strings.buttonText,
                  isLoading: controller.isLoading.value,
                  onPressed: () => controller.verifyOtp(),
                ),
              ),
            ],
          ),

          // Resend Section
          Center(
            child: Obx(() {
              final seconds = controller.remainingSeconds.value;
              final isWaiting = seconds > 0;

              return Text.rich(
                TextSpan(
                  text: '${strings.resendText} ',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.theme.colorScheme.onSurface.withValues(
                      alpha: 0.5,
                    ),
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: isWaiting
                          ? strings.resendIn(controller.formattedRemainingTime)
                          : strings.resendButton,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: isWaiting
                          ? null
                          : controller.resendRecognizer,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              );
            }),
          ),
        ],
      ),
    );
  }
}
