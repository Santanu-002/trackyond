import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';

class AppSection extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  const AppSection({
    super.key,
    required this.title,
    required this.child,
    this.padding,
    this.onActionPressed,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppUIConstants.spacing.space$12,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppUIConstants.spacing.space$24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (onActionPressed != null && actionLabel != null)
                  AppButton.ghost(
                    text: actionLabel,
                    onPressed: onActionPressed,
                    width: null,
                    height: null,
                    color: context.theme.colorScheme.primary,
                  ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}
