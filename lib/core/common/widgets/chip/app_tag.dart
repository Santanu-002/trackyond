import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class AppTag extends StatelessWidget {
  final String label;
  final Color? color;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? padding;
  final IconData? icon;
  final bool isCompact;

  const AppTag({
    super.key,
    this.label = '',
    this.color,
    this.labelStyle,
    this.padding,
    this.icon,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.theme.colorScheme.primary;

    return Container(
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: isCompact 
                ? AppUIConstants.spacing.space$8 
                : AppUIConstants.spacing.space$12,
            vertical: isCompact 
                ? AppUIConstants.spacing.space$2 
                : AppUIConstants.spacing.space$4,
          ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            effectiveColor.withValues(alpha: 0.15),
            effectiveColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$32),
        border: Border.all(
          color: effectiveColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isCompact ? 10 : 12, color: effectiveColor),
            SizedBox(
              width: isCompact 
                  ? AppUIConstants.spacing.space$4 
                  : AppUIConstants.spacing.space$8,
            ),
          ],
          Text(
            label,
            style:
                labelStyle ??
                context.textTheme.labelSmall?.copyWith(
                  color: effectiveColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  fontSize: isCompact ? 10 : null,
                ),
          ),
        ],
      ),
    );
  }
}
