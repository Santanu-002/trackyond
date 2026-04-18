import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class AppOtpInput extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool autofocus;
  final int length;

  const AppOtpInput({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged,
    this.onCompleted,
    this.autofocus = false,
    this.length = 6,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 52,
      height: 60,
      textStyle: context.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.theme.colorScheme.onSurface,
      ),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$12),
        border: Border.all(
          color: context.theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
    );

    return Pinput(
      controller: controller,
      autofocus: autofocus,
      length: length,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      forceErrorState: errorText != null,
      errorText: errorText,
      onChanged: onChanged,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyWith(
        textStyle: defaultPinTheme.textStyle?.copyWith(
          color: context.theme.colorScheme.primary,
        ),
        decoration: defaultPinTheme.decoration?.copyWith(
          color: context.theme.colorScheme.surface,
          border: Border.all(
            color: context.theme.colorScheme.primary,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: context.theme.colorScheme.primary.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ) as BoxDecoration,
      ),
      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration?.copyWith(
          color: context.theme.colorScheme.surfaceContainerHighest
              .withValues(alpha: 0.3),
          border: Border.all(
            color: context.theme.colorScheme.primary.withValues(alpha: 0.5),
            width: 1.0,
          ),
        ) as BoxDecoration,
      ),
      errorPinTheme: defaultPinTheme.copyWith(
        textStyle: defaultPinTheme.textStyle?.copyWith(
          color: context.theme.colorScheme.error,
        ),
        decoration: defaultPinTheme.decoration?.copyWith(
          color: context.theme.colorScheme.errorContainer
              .withValues(alpha: 0.1),
          border: Border.all(
            color: context.theme.colorScheme.error,
            width: 1.0,
          ),
        ) as BoxDecoration,
      ),
      hapticFeedbackType: HapticFeedbackType.mediumImpact,
      onCompleted: onCompleted,
      cursor: Center(
        child: Container(
          width: 2,
          height: 24,
          color: context.theme.colorScheme.primary,
        ),
      ),
    );
  }
}
