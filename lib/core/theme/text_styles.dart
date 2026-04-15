import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const LightTextStyles light = LightTextStyles();
  static const DarkTextStyles dark = DarkTextStyles();
}

class LightTextStyles {
  const LightTextStyles();

  // The Editorial Voice: Manrope for Display & Headlines
  TextStyle get displayLarge => GoogleFonts.manrope(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.light.textDefault,
        letterSpacing: -1.0,
      );

  TextStyle get headlineLarge => GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.light.textDefault,
      );

  TextStyle get titleLarge => GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.light.textDefault,
      );

  // The Editorial Voice: Inter for Body & Labels
  TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.light.textDefault,
      );

  TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.light.textDefault,
      );

  TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.light.textDefault,
      );

  TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.light.textSubtle,
      );
}

class DarkTextStyles {
  const DarkTextStyles();

  TextStyle get displayLarge => GoogleFonts.manrope(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.dark.textDefault,
      );

  TextStyle get headlineLarge => GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.dark.textDefault,
      );

  TextStyle get titleLarge => GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.dark.textDefault,
      );

  TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.dark.textDefault,
      );

  TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.dark.textDefault,
      );
      
  TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.dark.textDefault,
      );

  TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.dark.textSubtle,
      );
}
