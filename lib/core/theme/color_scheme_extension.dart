import 'package:flutter/material.dart';
import 'package:trackyond/core/theme/app_colors.dart';

extension ColorSchemeExtension on ColorScheme {
  Color get pending => brightness == Brightness.light
      ? AppColors.light.pending
      : AppColors.dark.pending;

  Color get inProgress => brightness == Brightness.light
      ? AppColors.light.inProgress
      : AppColors.dark.inProgress;

  Color get completed => brightness == Brightness.light
      ? AppColors.light.completed
      : AppColors.dark.completed;

  Color get cancelled => brightness == Brightness.light
      ? AppColors.light.cancelled
      : AppColors.dark.cancelled;

  Color get shimmerBase => brightness == Brightness.light
      ? AppColors.light.shimmerBase
      : AppColors.dark.shimmerBase;

  Color get shimmerHighlight => brightness == Brightness.light
      ? AppColors.light.shimmerHighlight
      : AppColors.dark.shimmerHighlight;
}
extension BuildContextThemeExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
