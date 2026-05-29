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

  Color get black => brightness == Brightness.light
      ? AppColors.light.black
      : AppColors.dark.black;

  Color get attachmentCamera => brightness == Brightness.light
      ? AppColors.light.attachmentCamera
      : AppColors.dark.attachmentCamera;

  Color get attachmentImage => brightness == Brightness.light
      ? AppColors.light.attachmentImage
      : AppColors.dark.attachmentImage;

  Color get attachmentVideo => brightness == Brightness.light
      ? AppColors.light.attachmentVideo
      : AppColors.dark.attachmentVideo;

  Color get attachmentDocs => brightness == Brightness.light
      ? AppColors.light.attachmentDocs
      : AppColors.dark.attachmentDocs;

  Color get attachmentPdf => brightness == Brightness.light
      ? AppColors.light.attachmentPdf
      : AppColors.dark.attachmentPdf;
}
extension BuildContextThemeExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
