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
}
