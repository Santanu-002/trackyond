import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/common/widgets/button/app_button.dart';

class AppSection extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? childPadding;
  final EdgeInsetsGeometry? headerPadding;
  final VoidCallback? onActionPressed;
  final String? actionLabel;
  final Widget? trailing;
  final double? spacing;

  const AppSection({
    super.key,
    required this.title,
    required this.child,
    this.padding,
    this.childPadding,
    this.headerPadding,
    this.onActionPressed,
    this.actionLabel,
    this.trailing,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: spacing ?? AppUIConstants.spacing.space$12,
        children: [
          Padding(
            padding: headerPadding ??
                EdgeInsets.symmetric(
                  horizontal: AppUIConstants.spacing.space$24,
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (trailing != null)
                  trailing!
                else if (onActionPressed != null && actionLabel != null)
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
          Padding(
            padding: childPadding ?? EdgeInsets.zero,
            child: child,
          ),
        ],
      ),
    );
  }
}
