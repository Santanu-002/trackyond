import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/app_colors.dart';
import 'package:trackyond/core/theme/text_styles.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      primary: AppColors.light.brandBlue,
      onPrimary: AppColors.light.onPrimary,
      primaryContainer: AppColors.light.brandAccent,
      secondary: AppColors.light.brandAccent,
      surface: AppColors.light.cardSurface,
      onSurface: AppColors.light.textDefault,
      error: AppColors.light.error,
      tertiary: AppColors.light.completed,
      outlineVariant: AppColors.light.ghostBorder.withValues(alpha: 0.15),
      onSurfaceVariant: AppColors.light.textSubtle,
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
        indent: 0,
        endIndent: 0,
      ),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      searchBarTheme: _searchBarTheme(
        colorScheme,
        AppTextStyles.light.bodyMedium,
      ),
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
      menuTheme: _menuTheme(colorScheme),
      dropdownMenuTheme: _dropdownMenuTheme(colorScheme),
      menuButtonTheme: _menuButtonTheme(colorScheme),
      listTileTheme: ListTileThemeData(
        selectedTileColor: colorScheme.primary,
        selectedColor: colorScheme.onPrimary,
        iconColor: colorScheme.onSurfaceVariant,
        titleTextStyle: AppTextStyles.light.bodyLarge,
        subtitleTextStyle: AppTextStyles.light.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$12),
        ),
      ),
      cardTheme: _cardTheme(colorScheme),
      bottomSheetTheme: _bottomSheetTheme(colorScheme),
      badgeTheme: _badgeTheme(colorScheme),
      tooltipTheme: _tooltipTheme(colorScheme),
      dialogTheme: _dialogTheme(colorScheme),
      checkboxTheme: _checkboxTheme(colorScheme),
      radioTheme: _radioTheme(colorScheme),
      switchTheme: _switchTheme(colorScheme),
      drawerTheme: _drawerTheme(colorScheme),
      snackBarTheme: _snackBarTheme(colorScheme),
      floatingActionButtonTheme: _fabTheme(colorScheme),
      tabBarTheme: _tabBarTheme(colorScheme, AppTextStyles.light.labelLarge),
      chipTheme: _chipTheme(colorScheme),
      progressIndicatorTheme: _progressIndicatorTheme(colorScheme),
      bottomNavigationBarTheme: _bottomNavTheme(colorScheme),
      segmentedButtonTheme: _segmentedButtonTheme(colorScheme),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.dark.brandBlue,
      onPrimary: AppColors.dark.onPrimary,
      primaryContainer: AppColors.dark.brandAccent,
      secondary: AppColors.dark.brandAccent,
      surface: AppColors.dark.cardSurface,
      onSurface: AppColors.dark.textDefault,
      error: AppColors.dark.error,
      tertiary: AppColors.dark.completed,
      outlineVariant: AppColors.dark.ghostBorder.withValues(alpha: 0.15),
      onSurfaceVariant: AppColors.dark.textSubtle,
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
      searchBarTheme: _searchBarTheme(
        colorScheme,
        AppTextStyles.dark.bodyMedium,
      ),
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
      menuTheme: _menuTheme(colorScheme),
      dropdownMenuTheme: _dropdownMenuTheme(colorScheme),
      menuButtonTheme: _menuButtonTheme(colorScheme),
      listTileTheme: ListTileThemeData(
        selectedTileColor: colorScheme.primary,
        selectedColor: colorScheme.onPrimary,
        iconColor: colorScheme.onSurfaceVariant,
        titleTextStyle: AppTextStyles.dark.bodyLarge,
        subtitleTextStyle: AppTextStyles.dark.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$12),
        ),
      ),
      cardTheme: _cardTheme(colorScheme),
      bottomSheetTheme: _bottomSheetTheme(colorScheme),
      badgeTheme: _badgeTheme(colorScheme),
      tooltipTheme: _tooltipTheme(colorScheme),
      dialogTheme: _dialogTheme(colorScheme),
      checkboxTheme: _checkboxTheme(colorScheme),
      radioTheme: _radioTheme(colorScheme),
      switchTheme: _switchTheme(colorScheme),
      drawerTheme: _drawerTheme(colorScheme),
      snackBarTheme: _snackBarTheme(colorScheme),
      floatingActionButtonTheme: _fabTheme(colorScheme),
      tabBarTheme: _tabBarTheme(colorScheme, AppTextStyles.dark.labelLarge),
      chipTheme: _chipTheme(colorScheme),
      progressIndicatorTheme: _progressIndicatorTheme(colorScheme),
      bottomNavigationBarTheme: _bottomNavTheme(colorScheme),
      segmentedButtonTheme: _segmentedButtonTheme(colorScheme),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(ColorScheme colors) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$12),
      borderSide: BorderSide(
        color: colors.outline.withValues(alpha: 0.2),
        width: 1,
      ),
    );

    return InputDecorationTheme(
      filled: true,
      fillColor: colors.surface,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppUIConstants.spacing.space$16,
        vertical: AppUIConstants.spacing.space$16,
      ),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: BorderSide(color: colors.primary, width: 1.5),
      ),
      errorBorder: border.copyWith(
        borderSide: BorderSide(color: colors.error, width: 1),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: BorderSide(color: colors.error, width: 1.5),
      ),
    );
  }

  static MenuThemeData _menuTheme(ColorScheme colors) {
    return MenuThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(colors.surface),
        elevation: WidgetStateProperty.all(8),
        shadowColor: WidgetStateProperty.all(
          colors.primary.withValues(alpha: 0.2),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.all(AppUIConstants.spacing.space$6),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppUIConstants.radius.radius$12,
            ),
          ),
        ),
        surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }

  static MenuButtonThemeData _menuButtonTheme(ColorScheme colors) {
    return MenuButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return null;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.onPrimary;
          }
          return colors.onSurface;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return colors.primary.withValues(alpha: 0.08);
          }
          if (states.contains(WidgetState.focused) ||
              states.contains(WidgetState.pressed)) {
            return colors.primary.withValues(alpha: 0.12);
          }
          return null;
        }),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: AppUIConstants.spacing.space$16,
            vertical: AppUIConstants.spacing.space$12,
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppUIConstants.radius.radius$12,
            ),
          ),
        ),
      ),
    );
  }

  static CardThemeData _cardTheme(ColorScheme colors) {
    return CardThemeData(
      color: colors.surface,
      elevation: 4,
      margin: EdgeInsets.zero,
      shadowColor: colors.primary.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$24),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }

  static DialogThemeData _dialogTheme(ColorScheme colors) {
    return DialogThemeData(
      backgroundColor: colors.surface,
      elevation: 8,
      shadowColor: colors.primary.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$24),
      ),
    );
  }

  static CheckboxThemeData _checkboxTheme(ColorScheme colors) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors.primary;
        }
        return null;
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$4),
      ),
      side: BorderSide(
        color: colors.outline.withValues(alpha: 0.4),
        width: 1.5,
      ),
    );
  }

  static RadioThemeData _radioTheme(ColorScheme colors) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors.primary;
        }
        return null;
      }),
    );
  }

  static SwitchThemeData _switchTheme(ColorScheme colors) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors.surface;
        }
        return colors.outline.withValues(alpha: 0.4);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colors.primary;
        }
        return colors.surfaceContainerHighest;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.transparent;
        }
        return colors.outline.withValues(alpha: 0.2);
      }),
      trackOutlineWidth: WidgetStateProperty.all(1.0),
    );
  }

  static DrawerThemeData _drawerTheme(ColorScheme colors) {
    return DrawerThemeData(
      backgroundColor: colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(AppUIConstants.radius.radius$16),
        ),
      ),
    );
  }

  static SnackBarThemeData _snackBarTheme(ColorScheme colors) {
    return SnackBarThemeData(
      backgroundColor: colors.onSurface,
      contentTextStyle: TextStyle(color: colors.surface),
      behavior: SnackBarBehavior.fixed,
    );
  }

  static FloatingActionButtonThemeData _fabTheme(ColorScheme colors) {
    return FloatingActionButtonThemeData(
      backgroundColor: colors.primary,
      foregroundColor: colors.onPrimary,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$16),
      ),
    );
  }

  static TabBarThemeData _tabBarTheme(
    ColorScheme colors,
    TextStyle labelStyle,
  ) {
    return TabBarThemeData(
      labelColor: colors.primary,
      unselectedLabelColor: colors.onSurfaceVariant,
      labelStyle: labelStyle.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: labelStyle.copyWith(fontWeight: FontWeight.w500),
      indicatorColor: colors.primary,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: Colors.transparent,
    );
  }

  static ChipThemeData _chipTheme(ColorScheme colors) {
    return ChipThemeData(
      backgroundColor: colors.surface,
      disabledColor: colors.surface,
      selectedColor: colors.primary,
      secondarySelectedColor: colors.primary,
      padding: EdgeInsets.symmetric(
        horizontal: AppUIConstants.spacing.space$12,
        vertical: AppUIConstants.spacing.space$4,
      ),
      labelStyle:
          (colors.brightness == Brightness.light
                  ? AppTextStyles.light.labelSmall
                  : AppTextStyles.dark.labelSmall)
              .copyWith(color: colors.onSurface),
      secondaryLabelStyle:
          (colors.brightness == Brightness.light
                  ? AppTextStyles.light.labelSmall
                  : AppTextStyles.dark.labelSmall)
              .copyWith(color: colors.onPrimary, fontWeight: FontWeight.w600),
      brightness: Brightness.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$8),
        side: BorderSide(color: colors.outline.withValues(alpha: 0.1)),
      ),
      side: BorderSide(color: colors.outline.withValues(alpha: 0.1)),
      showCheckmark: false,
    );
  }

  static ProgressIndicatorThemeData _progressIndicatorTheme(
    ColorScheme colors,
  ) {
    return ProgressIndicatorThemeData(
      color: colors.primary,
      circularTrackColor: colors.primary.withValues(alpha: 0.1),
      refreshBackgroundColor: colors.surface,
    );
  }

  static BottomNavigationBarThemeData _bottomNavTheme(ColorScheme colors) {
    return BottomNavigationBarThemeData(
      backgroundColor: colors.surface,
      selectedItemColor: colors.primary,
      unselectedItemColor: colors.onSurfaceVariant,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    );
  }

  static SegmentedButtonThemeData _segmentedButtonTheme(ColorScheme colors) {
    return SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return colors.surface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.onPrimary;
          }
          return colors.onSurface;
        }),
        side: WidgetStateProperty.all(
          BorderSide(color: colors.outline.withValues(alpha: 0.2)),
        ),
        textStyle: WidgetStatePropertyAll(
          (colors.brightness == Brightness.light
              ? AppTextStyles.light.labelSmall
              : AppTextStyles.dark.labelSmall),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppUIConstants.radius.radius$12,
            ),
          ),
        ),
      ),
    );
  }

  static DropdownMenuThemeData _dropdownMenuTheme(ColorScheme colors) {
    return DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(colors.surface),
        elevation: WidgetStateProperty.all(8),
        shadowColor: WidgetStateProperty.all(
          colors.primary.withValues(alpha: 0.2),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppUIConstants.radius.radius$16,
            ),
          ),
        ),
        surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
      ),
      inputDecorationTheme: _inputDecorationTheme(colors),
    );
  }

  static SearchBarThemeData _searchBarTheme(
    ColorScheme colors,
    TextStyle textStyle,
  ) {
    return SearchBarThemeData(
      elevation: WidgetStateProperty.all(0),
      backgroundColor: WidgetStateProperty.all(colors.surface),
      shape: WidgetStateProperty.all(const StadiumBorder()),
      side: WidgetStateProperty.resolveWith<BorderSide?>((states) {
        if (states.contains(WidgetState.focused)) {
          return BorderSide(color: colors.primary, width: 1.5);
        }
        return BorderSide(
          color: colors.outline.withValues(alpha: 0.2),
          width: 1,
        );
      }),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16),
      ),
      textStyle: WidgetStateProperty.all(textStyle),
      hintStyle: WidgetStateProperty.all(
        textStyle.copyWith(color: colors.onSurface.withValues(alpha: 0.4)),
      ),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
    );
  }

  static BottomSheetThemeData _bottomSheetTheme(ColorScheme colors) {
    return BottomSheetThemeData(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppUIConstants.radius.radius$32),
        ),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }

  static BadgeThemeData _badgeTheme(ColorScheme colors) {
    return BadgeThemeData(
      backgroundColor: colors.primary,
      textColor: colors.onPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
    );
  }

  static TooltipThemeData _tooltipTheme(ColorScheme colors) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: colors.onSurface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppUIConstants.radius.radius$8),
      ),
      textStyle: TextStyle(color: colors.surface, fontSize: 12),
    );
  }
}
