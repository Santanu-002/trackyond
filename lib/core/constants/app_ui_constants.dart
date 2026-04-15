import 'package:flutter/material.dart';

class AppUIConstants {
  static const AppRadius radius = AppRadius();
  static const AppSpacing spacing = AppSpacing();
  static const AppWidgets widgets = AppWidgets();
}

class AppRadius {
  const AppRadius();
  final double radius$8 = 8.0;
  final double radius$12 = 12.0;
  final double radius$16 = 16.0;
  final double radius$24 = 24.0;
}

class AppSpacing {
  const AppSpacing();
  final double space$4 = 4.0;
  final double space$8 = 8.0;
  final double space$12 = 12.0;
  final double space$16 = 16.0;
  final double space$24 = 24.0;
  final double space$32 = 32.0;
}

class AppWidgets {
  const AppWidgets();
  final SizedBox verticalBox$8 = const SizedBox(height: 8.0);
  final SizedBox verticalBox$16 = const SizedBox(height: 16.0);
  final SizedBox verticalBox$24 = const SizedBox(height: 24.0);

  final SizedBox horizontalBox$8 = const SizedBox(width: 8.0);
  final SizedBox horizontalBox$16 = const SizedBox(width: 16.0);
  final SizedBox horizontalBox$24 = const SizedBox(width: 24.0);
}
