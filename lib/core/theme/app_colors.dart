import 'package:flutter/material.dart';

class AppColors {
  static const LightColors light = LightColors();
  static const DarkColors dark = DarkColors();
}

class LightColors {
  const LightColors();

  // Luminous Curator: The Base
  final Color background = const Color(0xFFFAF8FF);

  // Tonal Architecture
  final Color tonalSurface = const Color(0xFFF3F3FE); // surface-container-low
  final Color cardSurface = const Color(0xFFFFFFFF); // surface-container-lowest

  // Branding
  final Color brandBlue = const Color(0xFF004AC6); // primary
  final Color brandAccent = const Color(0xFF2563EB); // primary_container

  // Semantic
  final Color error = const Color(0xFFB00020);
  final Color pending = const Color(0xFFFEA619);
  final Color inProgress = const Color(0xFF2563EB);
  final Color completed = const Color(0xFF007D55);
  final Color cancelled = const Color(0xFFB00020);
  final Color ghostBorder = const Color(0xFFC3C6D7); // outline-variant
  final Color black = const Color(0xFF000000);

  // Shimmer
  final Color shimmerBase = const Color(0xFFE0E0E0); // Colors.grey[300]
  final Color shimmerHighlight = const Color(0xFFF5F5F5); // Colors.grey[100]

  // Typography
  final Color textDefault = const Color(
    0xFF191B23,
  ); // on-surface (No pure black)
  final Color textSubtle = const Color(0xFF757575);
  final Color onPrimary = const Color(0xFFFFFFFF);
}

class DarkColors {
  const DarkColors();

  // Fallback dark palette (Maintaining high-clarity)
  final Color background = const Color(0xFF121212);
  final Color tonalSurface = const Color(0xFF1E1E1E);
  final Color cardSurface = const Color(0xFF2C2C2C);

  final Color brandBlue = const Color(0xFF004AC6);
  final Color brandAccent = const Color(0xFF2563EB);

  final Color error = const Color(0xFFB00020);
  final Color pending = const Color(0xFFFEA619);
  final Color inProgress = const Color(0xFF2563EB);
  final Color completed = const Color(0xFF007D55);
  final Color cancelled = const Color(0xFFB00020);
  final Color ghostBorder = const Color(0xFFC3C6D7);
  final Color black = const Color(0xFF000000);

  final Color shimmerBase = const Color(0xFF424242); // Colors.grey[800]
  final Color shimmerHighlight = const Color(0xFF616161); // Colors.grey[700]

  final Color textDefault = const Color(0xFFFFFFFF);
  final Color textSubtle = const Color(0xB3FFFFFF);
  final Color onPrimary = const Color(0xFFFFFFFF);
}
