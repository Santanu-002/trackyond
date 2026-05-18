import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';

part 'filled_button.dart';
part 'outlined_button.dart';
part 'ghost_button.dart';
part 'custom_button.dart';
part 'icon_button.dart';
part 'button_content.dart';

enum AppButtonType { filled, outlined, ghost, custom, icon }

enum AppButtonShape { capsule, sharpEdge, roundEdge }

class AppButton extends StatelessWidget {
  final Widget _delegate;

  const AppButton._(this._delegate, {super.key});

  factory AppButton.icon({
    Key? key,
    required Widget icon,
    VoidCallback? onPressed,
    double size = 40,
    Color? color,
    Color? iconColor,
    double? borderRadius,
    String? tooltip,
    bool enableHaptic = true,
  }) {
    return AppButton._(
      _IconAppButton(
        key: key,
        icon: icon,
        onPressed: onPressed != null
            ? () {
                if (enableHaptic) HapticFeedback.lightImpact();
                onPressed();
              }
            : null,
        size: size,
        color: color,
        iconColor: iconColor,
        borderRadius: borderRadius,
        tooltip: tooltip,
      ),
      key: key,
    );
  }

  factory AppButton.filled({
    Key? key,
    String? text,
    Widget? child,
    VoidCallback? onPressed,
    double? width = double.infinity,
    double? height = 56,
    Color? color,
    double? borderRadius,
    List<Color>? gradientColors,
    Color? splashColor,
    AppButtonShape shape = AppButtonShape.capsule,
    Widget? leading,
    bool isLoading = false,
    bool enableHaptic = true,
  }) {
    return AppButton._(
      _FilledAppButton(
        key: key,
        text: text,
        leading: leading,
        onPressed: onPressed != null
            ? () {
                if (enableHaptic) HapticFeedback.lightImpact();
                onPressed();
              }
            : null,
        width: width,
        height: height,
        color: color,
        borderRadius: borderRadius,
        gradientColors: gradientColors,
        splashColor: splashColor,
        shape: shape,
        isLoading: isLoading,
        child: child,
      ),
      key: key,
    );
  }

  factory AppButton.outlined({
    Key? key,
    String? text,
    Widget? child,
    VoidCallback? onPressed,
    double? width = double.infinity,
    double? height = 56,
    Color? color,
    double? borderRadius,
    AppButtonShape shape = AppButtonShape.capsule,
    Widget? leading,
    bool isLoading = false,
    bool enableHaptic = true,
  }) {
    return AppButton._(
      _OutlinedAppButton(
        key: key,
        text: text,
        leading: leading,
        onPressed: onPressed != null
            ? () {
                if (enableHaptic) HapticFeedback.lightImpact();
                onPressed();
              }
            : null,
        width: width,
        height: height,
        color: color,
        borderRadius: borderRadius,
        shape: shape,
        isLoading: isLoading,
        child: child,
      ),
      key: key,
    );
  }

  factory AppButton.ghost({
    Key? key,
    String? text,
    Widget? child,
    VoidCallback? onPressed,
    double? width = double.infinity,
    double? height = 56,
    Color? color,
    double? borderRadius,
    AppButtonShape shape = AppButtonShape.capsule,
    Widget? leading,
    bool isLoading = false,
    EdgeInsetsGeometry? padding,
    VisualDensity? visualDensity,
    bool enableHaptic = true,
  }) {
    return AppButton._(
      _GhostAppButton(
        key: key,
        text: text,
        leading: leading,
        onPressed: onPressed != null
            ? () {
                if (enableHaptic) HapticFeedback.lightImpact();
                onPressed();
              }
            : null,
        width: width,
        height: height,
        color: color,
        borderRadius: borderRadius,
        shape: shape,
        isLoading: isLoading,
        padding: padding ?? (width != null && height != null ? padding : EdgeInsets.symmetric(horizontal: AppUIConstants.spacing.space$8, vertical: AppUIConstants.spacing.space$2)),
        visualDensity: visualDensity ?? (width != null && height != null ? visualDensity : const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity)),
        child: child,
      ),
      key: key,
    );
  }

  factory AppButton.custom({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    double? width = double.infinity,
    double? height = 56,
    Color? color,
    double? borderRadius,
    AppButtonShape shape = AppButtonShape.capsule,
    bool enableHaptic = true,
  }) {
    return AppButton._(
      _CustomAppButton(
        key: key,
        onPressed: onPressed != null
            ? () {
                if (enableHaptic) HapticFeedback.lightImpact();
                onPressed();
              }
            : null,
        width: width,
        height: height,
        color: color,
        borderRadius: borderRadius,
        shape: shape,
        child: child,
      ),
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) => _delegate;
}

BorderRadius _getBorderRadius(AppButtonShape shape, double? customRadius) {
  if (customRadius != null) return BorderRadius.circular(customRadius);
  switch (shape) {
    case AppButtonShape.capsule:
      return BorderRadius.circular(9999);
    case AppButtonShape.sharpEdge:
      return BorderRadius.zero;
    case AppButtonShape.roundEdge:
      return BorderRadius.circular(AppUIConstants.radius.radius$12);
  }
}
