import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class TermsAndPrivacyText extends StatefulWidget {
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  const TermsAndPrivacyText({
    super.key,
    this.onTermsTap,
    this.onPrivacyTap,
  });

  @override
  State<TermsAndPrivacyText> createState() => _TermsAndPrivacyTextState();
}

class _TermsAndPrivacyTextState extends State<TermsAndPrivacyText> {
  late TapGestureRecognizer _termsRecognizer;
  late TapGestureRecognizer _privacyRecognizer;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()..onTap = widget.onTermsTap;
    _privacyRecognizer = TapGestureRecognizer()..onTap = widget.onPrivacyTap;
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commonStrings = AppStrings.common;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppUIConstants.spacing.space$32,
        ),
        child: Text.rich(
          TextSpan(
            text: commonStrings.agreementPrefix,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.theme.colorScheme.onSurface.withValues(
                alpha: 0.5,
              ),
            ),
            children: [
              TextSpan(
                text: commonStrings.termsOfService,
                recognizer: _termsRecognizer,
                style: TextStyle(
                  color: context.theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(text: commonStrings.and),
              TextSpan(
                text: commonStrings.privacyPolicy,
                recognizer: _privacyRecognizer,
                style: TextStyle(
                  color: context.theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
