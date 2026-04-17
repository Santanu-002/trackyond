import 'package:flutter/material.dart';

class AppUIConstants {
  const AppUIConstants._();

  static const radius = _AppRadius();
  static const spacing = _AppSpacing();
  static const widgets = _AppWidgets();
}

class _AppRadius {
  const _AppRadius();
  double get radius$8 => 8.0;
  double get radius$12 => 12.0;
  double get radius$16 => 16.0;
  double get radius$24 => 24.0;
}

class _AppSpacing {
  const _AppSpacing();
  double get space$4 => 4.0;
  double get space$8 => 8.0;
  double get space$12 => 12.0;
  double get space$16 => 16.0;
  double get space$24 => 24.0;
  double get space$32 => 32.0;
}

class _AppWidgets {
  const _AppWidgets();
  SizedBox get verticalBox$8 => const SizedBox(height: 8.0);
  SizedBox get verticalBox$16 => const SizedBox(height: 16.0);
  SizedBox get verticalBox$24 => const SizedBox(height: 24.0);

  SizedBox get horizontalBox$8 => const SizedBox(width: 8.0);
  SizedBox get horizontalBox$16 => const SizedBox(width: 16.0);
  SizedBox get horizontalBox$24 => const SizedBox(width: 24.0);
}
