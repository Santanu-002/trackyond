import 'package:flutter/material.dart';
import 'package:trackyond/core/theme/app_colors.dart';
import 'package:trackyond/core/theme/text_styles.dart';

class AppTheme {
const AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.light.brandBlue,
      scaffoldBackgroundColor: AppColors.light.background,
      
      // Tonal Architecture: Surface Hierarchy
      colorScheme: ColorScheme.light(
        primary: AppColors.light.brandBlue,
        onPrimary: Colors.white,
        primaryContainer: AppColors.light.brandAccent,
        secondary: AppColors.light.brandAccent,
        surface: AppColors.light.cardSurface,
        onSurface: AppColors.light.textDefault,
        error: AppColors.light.error,
        outlineVariant: AppColors.light.ghostBorder.withValues(alpha: 0.15),
      ),

      // Editorial Voice: Typography Mapping
      textTheme: TextTheme(
        displayLarge: AppTextStyles.light.displayLarge,
        headlineLarge: AppTextStyles.light.headlineLarge,
        titleLarge: AppTextStyles.light.titleLarge,
        bodyLarge: AppTextStyles.light.bodyLarge,
        bodyMedium: AppTextStyles.light.bodyMedium,
        labelLarge: AppTextStyles.light.labelLarge,
        labelSmall: AppTextStyles.light.labelSmall,
      ),

      // The No-Line Rule: Zero default borders
      dividerTheme: const DividerThemeData(
        color: Colors.transparent,
        thickness: 0,
        space: 24,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.light.tonalSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.light.ghostBorder.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTextStyles.light.titleLarge,
        iconTheme: IconThemeData(color: AppColors.light.textDefault),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.dark.brandBlue,
      scaffoldBackgroundColor: AppColors.dark.background,
      colorScheme: ColorScheme.dark(
        primary: AppColors.dark.brandBlue,
        secondary: AppColors.dark.brandAccent,
        surface: AppColors.dark.cardSurface,
        onSurface: AppColors.dark.textDefault,
        error: AppColors.dark.error,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.dark.displayLarge,
        headlineLarge: AppTextStyles.dark.headlineLarge,
        titleLarge: AppTextStyles.dark.titleLarge,
        bodyLarge: AppTextStyles.dark.bodyLarge,
        bodyMedium: AppTextStyles.dark.bodyMedium,
        labelLarge: AppTextStyles.dark.labelLarge,
        labelSmall: AppTextStyles.dark.labelSmall,
      ),
    );
  }
}
