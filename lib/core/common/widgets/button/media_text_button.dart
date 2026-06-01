import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MediaTextButton extends StatelessWidget {
  final Widget leading;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const MediaTextButton({
    super.key,
    required this.leading,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;
    final colorScheme = context.theme.colorScheme;
    final effectiveBgColor = colorScheme.onPrimary.withValues(alpha: 0.15);
    final effectiveFgColor = isEnabled ? colorScheme.onPrimary : colorScheme.onPrimary.withValues(alpha: 0.35);

    return Material(
      color: effectiveBgColor,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isEnabled
            ? () {
                HapticFeedback.lightImpact();
                onPressed!();
              }
            : null,
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: isLoading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: effectiveFgColor,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconTheme(
                      data: IconThemeData(
                        color: effectiveFgColor,
                        size: 20,
                      ),
                      child: leading,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: context.textTheme.labelLarge?.copyWith(
                            color: effectiveFgColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
