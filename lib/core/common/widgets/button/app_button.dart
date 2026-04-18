import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

part 'filled_button.dart';
part 'outlined_button.dart';
part 'ghost_button.dart';
part 'custom_button.dart';
part 'button_content.dart';

enum AppButtonType { filled, outlined, ghost, custom }

class AppButton extends StatelessWidget {
  final Widget _delegate;

  const AppButton._(this._delegate, {super.key});

  factory AppButton.filled({
    Key? key,
    String? text,
    Widget? child,
    VoidCallback? onPressed,
    double width = double.infinity,
    double height = 56,
    Color? color,
    double? borderRadius,
    List<Color>? gradientColors,
    bool isLoading = false,
  }) {
    return AppButton._(
      _FilledAppButton(
        key: key,
        text: text,
        onPressed: onPressed != null
            ? () {
                HapticFeedback.lightImpact();
                onPressed();
              }
            : null,
        width: width,
        height: height,
        color: color,
        borderRadius: borderRadius,
        gradientColors: gradientColors,
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
    double width = double.infinity,
    double height = 56,
    Color? color,
    double? borderRadius,
    bool isLoading = false,
  }) {
    return AppButton._(
      _OutlinedAppButton(
        key: key,
        text: text,
        onPressed: onPressed != null
            ? () {
                HapticFeedback.lightImpact();
                onPressed();
              }
            : null,
        width: width,
        height: height,
        color: color,
        borderRadius: borderRadius,
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
    double width = double.infinity,
    double height = 56,
    Color? color,
    double? borderRadius,
    bool isLoading = false,
  }) {
    return AppButton._(
      _GhostAppButton(
        key: key,
        text: text,
        onPressed: onPressed != null
            ? () {
                HapticFeedback.lightImpact();
                onPressed();
              }
            : null,
        width: width,
        height: height,
        color: color,
        borderRadius: borderRadius,
        isLoading: isLoading,
        child: child,
      ),
      key: key,
    );
  }

  factory AppButton.custom({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    double width = double.infinity,
    double height = 56,
    Color? color,
    double? borderRadius,
  }) {
    return AppButton._(
      _CustomAppButton(
        key: key,
        onPressed: onPressed != null
            ? () {
                HapticFeedback.lightImpact();
                onPressed();
              }
            : null,
        width: width,
        height: height,
        color: color,
        borderRadius: borderRadius,
        child: child,
      ),
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) => _delegate;
}
