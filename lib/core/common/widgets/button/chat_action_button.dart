import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ChatActionButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool enableHaptic;

  const ChatActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 40,
    this.backgroundColor,
    this.iconColor,
    this.enableHaptic = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final isEnabled = onPressed != null;

    final effectiveBgColor = backgroundColor ?? colorScheme.outlineVariant.withValues(alpha: 0.2);
    final effectiveIconColor = iconColor ?? colorScheme.onPrimary;
    final finalIconColor = isEnabled ? effectiveIconColor : effectiveIconColor.withValues(alpha: 0.35);

    return IconButton.filled(
      onPressed: onPressed != null
          ? () {
              if (enableHaptic) HapticFeedback.lightImpact();
              onPressed!();
            }
          : null,
      icon: icon,
      style: IconButton.styleFrom(
        backgroundColor: effectiveBgColor,
        foregroundColor: finalIconColor,
        disabledBackgroundColor: effectiveBgColor,
        disabledForegroundColor: finalIconColor,
        minimumSize: Size(size, size),
        fixedSize: Size(size, size),
        padding: EdgeInsets.zero,
        shape: const CircleBorder(),
      ),
    );
  }
}
