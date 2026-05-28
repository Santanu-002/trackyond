import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


class AppIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? borderRadius;
  final String? tooltip;
  final bool enableHaptic;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 40,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius,
    this.tooltip,
    this.enableHaptic = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final effectiveBgColor = backgroundColor ?? colorScheme.surfaceContainerHighest;
    final effectiveIconColor = iconColor ?? colorScheme.primary;

    return IconButton.filled(
      onPressed: onPressed != null
          ? () {
              if (enableHaptic) HapticFeedback.lightImpact();
              onPressed!();
            }
          : null,
      icon: icon,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: effectiveBgColor,
        foregroundColor: effectiveIconColor,
        disabledBackgroundColor: effectiveBgColor,
        disabledForegroundColor: effectiveIconColor,
        minimumSize: Size(size, size),
        fixedSize: Size(size, size),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? 100,
          ),
        ),
      ),
    );
  }
}
