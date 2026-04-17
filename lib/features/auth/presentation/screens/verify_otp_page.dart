import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/auth/presentation/controllers/verify_otp_controller.dart';

class VerifyOtpPage extends GetView<VerifyOtpController> {
  const VerifyOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.verifyOtp;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.theme.colorScheme.onSurface,
            size: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppUIConstants.spacing.space$24),
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
                    () => Pinput(
                      controller: controller.otpController,
                      length: 6,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      forceErrorState: controller.isOtpInvalid.value,
                      errorText: AppStrings.admin.enterOtp,
                      // Or more specific error
                      onChanged: (_) {
                        if (controller.isOtpInvalid.value) {
                          controller.isOtpInvalid.value = false;
                        }
                      },
                      defaultPinTheme: PinTheme(
                        width: 52,
                        height: 60,
                        textStyle: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.onSurface,
                        ),
                        decoration: BoxDecoration(
                          color: context
                              .theme
                              .colorScheme
                              .surfaceContainerHighest
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(
                            AppUIConstants.radius.radius$12,
                          ),
                          border: Border.all(
                            color: context.theme.colorScheme.outline.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 52,
                        height: 60,
                        textStyle: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.primary,
                        ),
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(
                            AppUIConstants.radius.radius$12,
                          ),
                          border: Border.all(
                            color: context.theme.colorScheme.primary,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: context.theme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      submittedPinTheme: PinTheme(
                        width: 52,
                        height: 60,
                        textStyle: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.onSurface,
                        ),
                        decoration: BoxDecoration(
                          color: context
                              .theme
                              .colorScheme
                              .surfaceContainerHighest
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(
                            AppUIConstants.radius.radius$12,
                          ),
                          border: Border.all(
                            color: context.theme.colorScheme.primary.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      ),
                      errorPinTheme: PinTheme(
                        width: 52,
                        height: 60,
                        textStyle: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.error,
                        ),
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.errorContainer
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            AppUIConstants.radius.radius$12,
                          ),
                          border: Border.all(
                            color: context.theme.colorScheme.error,
                          ),
                        ),
                      ),
                      hapticFeedbackType: HapticFeedbackType.mediumImpact,
                      onCompleted: (pin) => controller.verifyOtp(),
                      cursor: Center(
                        child: Container(
                          width: 2,
                          height: 24,
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  AppUIConstants.widgets.verticalBox$16,
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
                child: Column(
                  spacing: AppUIConstants.spacing.space$8,
                  children: [
                    Text(
                      strings.resendText,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                    Obx(() {
                      final seconds = controller.remainingSeconds.value;
                      if (seconds > 0) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            strings.resendIn(seconds),
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return TextButton(
                        onPressed: () => controller.resendOtp(),
                        child: Text(
                          strings.resendButton,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
