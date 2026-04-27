import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackyond/core/theme/app_colors.dart';
import 'package:trackyond/core/theme/text_styles.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      primary: AppColors.light.brandBlue,
      onPrimary: Colors.white,
      primaryContainer: AppColors.light.brandAccent,
      secondary: AppColors.light.brandAccent,
      surface: AppColors.light.cardSurface,
      onSurface: AppColors.light.textDefault,
      error: AppColors.light.error,
      tertiary: AppColors.light.completed,
      outlineVariant: AppColors.light.ghostBorder.withValues(alpha: 0.15),
    );

    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.light.brandBlue,
      scaffoldBackgroundColor: AppColors.light.background,
      colorScheme: colorScheme,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.light.displayLarge,
        headlineLarge: AppTextStyles.light.headlineLarge,
        titleLarge: AppTextStyles.light.titleLarge,
        bodyLarge: AppTextStyles.light.bodyLarge,
        bodyMedium: AppTextStyles.light.bodyMedium,
        labelLarge: AppTextStyles.light.labelLarge,
        labelSmall: AppTextStyles.light.labelSmall,
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.transparent,
        thickness: 0,
        space: 24,
      ),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTextStyles.light.titleLarge,
        iconTheme: IconThemeData(color: AppColors.light.textDefault),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.dark.brandBlue,
      onPrimary: Colors.white,
      primaryContainer: AppColors.dark.brandAccent,
      secondary: AppColors.dark.brandAccent,
      surface: AppColors.dark.cardSurface,
      onSurface: AppColors.dark.textDefault,
      error: AppColors.dark.error,
      tertiary: AppColors.dark.completed,
      outlineVariant: AppColors.dark.ghostBorder.withValues(alpha: 0.15),
    );

    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.dark.brandBlue,
      scaffoldBackgroundColor: AppColors.dark.background,
      colorScheme: colorScheme,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.dark.displayLarge,
        headlineLarge: AppTextStyles.dark.headlineLarge,
        titleLarge: AppTextStyles.dark.titleLarge,
        bodyLarge: AppTextStyles.dark.bodyLarge,
        bodyMedium: AppTextStyles.dark.bodyMedium,
        labelLarge: AppTextStyles.dark.labelLarge,
        labelSmall: AppTextStyles.dark.labelSmall,
      ),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTextStyles.dark.titleLarge,
        iconTheme: IconThemeData(color: AppColors.dark.textDefault),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(ColorScheme colors) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: colors.outline.withValues(alpha: 0.2),
        width: 1,
      ),
    );

    return InputDecorationTheme(
      filled: true,
      fillColor: colors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: BorderSide(
          color: colors.primary,
          width: 1.5,
        ),
      ),
      errorBorder: border.copyWith(
        borderSide: BorderSide(
          color: colors.error,
          width: 1,
        ),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: BorderSide(
          color: colors.error,
          width: 1.5,
        ),
      ),
      hintStyle: TextStyle(
        color: colors.onSurface.withValues(alpha: 0.3),
      ),
    );
  }
}
