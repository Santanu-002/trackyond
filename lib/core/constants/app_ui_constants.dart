import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppUIConstants {
  const AppUIConstants._();

  static const radius = _AppRadius();
  static const spacing = _AppSpacing();
  static const widgets = _AppWidgets();
  static const colors = _RandomAvatarBackgroundColors();
  static const shadows = _AppShadows();
}

class _RandomAvatarBackgroundColors {
  const _RandomAvatarBackgroundColors();

  List<Color> get avatarColors => const [
    Color(0xFF6366F1), // Indigo
    Color(0xFFEC4899), // Pink
    Color(0xFFF59E0B), // Amber
    Color(0xFF10B981), // Emerald
    Color(0xFF3B82F6), // Blue
    Color(0xFF8B5CF6), // Violet
    Color(0xFFEF4444), // Red
  ];
}

class _AppRadius {
  const _AppRadius();

  double get radius$4 => 4.0;

  double get radius$8 => 8.0;

  double get radius$12 => 12.0;

  double get radius$16 => 16.0;

  double get radius$24 => 24.0;

  double get radius$32 => 32.0;

  double get radius$48 => 48.0;

  double get radius$56 => 56.0;
}

class _AppSpacing {
  const _AppSpacing();

  double get space$2 => 2.0;

  double get space$4 => 4.0;

  double get space$6 => 6.0;

  double get space$8 => 8.0;

  double get space$12 => 12.0;

  double get space$16 => 16.0;

  double get space$20 => 20.0;

  double get space$24 => 24.0;

  double get space$28 => 28.0;

  double get space$32 => 32.0;

  double get space$40 => 40.0;

  double get space$48 => 48.0;
}

class _AppWidgets {
  const _AppWidgets();

  SizedBox get verticalBox$4 => const SizedBox(height: 4.0);

  SizedBox get verticalBox$8 => const SizedBox(height: 8.0);

  SizedBox get verticalBox$12 => const SizedBox(height: 12.0);

  SizedBox get verticalBox$16 => const SizedBox(height: 16.0);

  SizedBox get verticalBox$24 => const SizedBox(height: 24.0);

  SizedBox get verticalBox$32 => const SizedBox(height: 32.0);

  SizedBox get verticalBox$48 => const SizedBox(height: 48.0);

  SizedBox get horizontalBox$4 => const SizedBox(width: 4.0);

  SizedBox get horizontalBox$8 => const SizedBox(width: 8.0);

  SizedBox get horizontalBox$12 => const SizedBox(width: 12.0);

  SizedBox get horizontalBox$16 => const SizedBox(width: 16.0);

  SizedBox get horizontalBox$24 => const SizedBox(width: 24.0);

  SizedBox get horizontalBox$32 => const SizedBox(width: 32.0);
}

class _AppShadows {
  const _AppShadows();

  List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Get.theme.colorScheme.onSurface.withValues(alpha: 0.05),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
}
