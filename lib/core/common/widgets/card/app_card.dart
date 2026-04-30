import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final Color? splashColor;
  final BorderRadiusGeometry? borderRadius;
  final Clip? clipBehavior;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.onTap,
    this.splashColor,
    this.borderRadius,
    this.clipBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      shape: borderRadius != null
          ? RoundedRectangleBorder(borderRadius: borderRadius!)
          : null,
      child: InkWell(
        borderRadius: borderRadius as BorderRadius?,
        onTap: onTap,
        splashFactory: onTap == null
            ? NoSplash.splashFactory
            : InkRipple.splashFactory,
        splashColor: onTap != null
            ? splashColor ??
                  context.theme.colorScheme.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        highlightColor: onTap != null
            ? splashColor ??
                  context.theme.colorScheme.primary.withValues(alpha: 0.2)
            : Colors.transparent,
        child: Padding(
          padding: padding ?? EdgeInsets.all(AppUIConstants.spacing.space$16),
          child: SizedBox(width: width, height: height, child: child),
        ),
      ),
    );
  }
}
