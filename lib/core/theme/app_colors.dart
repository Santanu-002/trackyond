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
  final Color cardSurface = const Color(0xFFFFFFFF);  // surface-container-lowest
  
  // Branding
  final Color brandBlue = const Color(0xFF004AC6);    // primary
  final Color brandAccent = const Color(0xFF2563EB);  // primary_container
  
  // Semantic
  final Color error = const Color(0xFFB00020);
  final Color pending = const Color(0xFFFEA619);
  final Color inProgress = const Color(0xFF2563EB);
  final Color completed = const Color(0xFF007D55);
  final Color ghostBorder = const Color(0xFFC3C6D7); // outline-variant

  // Typography
  final Color textDefault = const Color(0xFF191B23); // on-surface (No pure black)
  final Color textSubtle = const Color(0xFF757575);
}

class DarkColors {
  const DarkColors();
  
  // Fallback dark palette (Maintaining high-clarity)
  final Color background = const Color(0xFF121212);
  final Color tonalSurface = const Color(0xFF1E1E1E);
  final Color cardSurface = const Color(0xFF2C2C2C);
  
  final Color brandBlue = const Color(0xFF004AC6);
  final Color brandAccent = const Color(0xFF2563EB);
  
  final Color error = const Color(0xFFCF6679);
  final Color pending = const Color(0xFFFEA619);
  final Color inProgress = const Color(0xFF2563EB);
  final Color completed = const Color(0xFF007D55);
  final Color ghostBorder = const Color(0xFFC3C6D7);

  final Color textDefault = Colors.white;
  final Color textSubtle = Colors.white70;
}
