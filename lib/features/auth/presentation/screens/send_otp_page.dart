import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/widgets/text_field/app_text_field.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/features/auth/presentation/controllers/send_otp_controller.dart';

import 'package:trackyond/core/common/widgets/banner/app_banner.dart';
import 'package:trackyond/core/common/widgets/scaffold/app_scaffold.dart';

class SendOtpPage extends GetView<SendOtpController> {
  const SendOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.sendOtp;

    return AppScaffold(
      footer: Obx(() {
        if (!controller.showAccessDeniedBanner.value) {
          return const SizedBox.shrink();
        }
        return AppBanner(
          title: strings.accessDenied,
          subtitleWidget: RichText(
            text: TextSpan(
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              children: [
                TextSpan(text: strings.employeeAlreadyExists),
                const TextSpan(text: ' '),
                TextSpan(
                  text: strings.changeRoleAction,
                  style: TextStyle(
                    color: context.theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          type: AppBannerType.destructive,
          onDismiss: controller.dismissBanner,
          onTap: controller.switchRole,
        );
      }),
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
              Obx(
                () => AppTextField(
                  label: strings.phoneLabel,
                  hintText: strings.phoneHint,
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  errorText: controller.phoneError.value,
                  onChanged: (_) => controller.phoneError.value = null,
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
                          AppStrings.common.countryCode,
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
              ),
              Obx(
                () => AppButton.filled(
                  text: strings.buttonText,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.sendOtp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
