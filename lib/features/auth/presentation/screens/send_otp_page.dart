import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/app_text_field.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/auth/presentation/controllers/send_otp_controller.dart';

class SendOtpPage extends GetView<SendOtpController> {
  const SendOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.sendOtp;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppUIConstants.spacing.space$24,
                children: [
                  AppTextField(
                    label: strings.phoneLabel,
                    hintText: strings.phoneHint,
                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(10),
                    ],
                    prefix: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppUIConstants.spacing.space$12,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 20,
                            color: context.theme.colorScheme.primary,
                          ),
                          AppUIConstants.widgets.horizontalBox$8,
                          Text(
                            '+91',
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          AppUIConstants.widgets.horizontalBox$8,
                          Container(
                            height: 20,
                            width: 1,
                            color: context.theme.colorScheme.outline.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppButton.filled(
                    text: strings.buttonText,
                    onPressed: controller.sendOtp,
                  ),
                ],
              ),

              // Footer Section
              Center(
                child: Text(
                  strings.footerText,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.theme.colorScheme.onSurface.withValues(
                      alpha: 0.4,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
