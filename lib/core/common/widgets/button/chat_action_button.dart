import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';

class ChatActionButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool enableHaptic;
  final bool disabled;

  const ChatActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 40,
    this.backgroundColor,
    this.iconColor,
    this.enableHaptic = true,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = !disabled && onPressed != null;
    final colorScheme = context.colorScheme;

    final effectiveBgColor = backgroundColor ?? colorScheme.onPrimary.withValues(alpha: 0.15);
    final effectiveIconColor = iconColor ?? colorScheme.onPrimary;
    final finalIconColor = isEnabled ? effectiveIconColor : effectiveIconColor.withValues(alpha: 0.35);

    return IconButton.filled(
      onPressed: isEnabled
          ? () {
              if (enableHaptic) HapticFeedback.lightImpact();
              onPressed!();
            }
          : null,
      icon: IconTheme(
        data: IconThemeData(
          color: finalIconColor,
          size: size * 0.5,
        ),
        child: icon,
      ),
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
