import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/core/constants/app_typography.dart';

/// Configuration for building a theme variant.
class _ThemeConfig {
  final Brightness brightness;
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color surface;
  final Color onSurface;
  final Color background;
  final Color card;
  final Color textPrimary;
  final Color textMuted;
  final Color border;
  final Color navSelected;
  final Color navUnselected;
  final Color textButtonForeground;
  final BorderSide? cardBorder;
  final BorderSide? dialogBorder;
  final BorderSide? inputBorder;
  final double borderThickness;

  const _ThemeConfig({
    required this.brightness,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.surface,
    required this.onSurface,
    required this.background,
    required this.card,
    required this.textPrimary,
    required this.textMuted,
    required this.border,
    required this.navSelected,
    required this.navUnselected,
    required this.textButtonForeground,
    this.cardBorder,
    this.dialogBorder,
    this.inputBorder,
    this.borderThickness = 1.0,
  });
}

abstract final class AppTheme {
  // Light theme config
  static const _lightConfig = _ThemeConfig(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.textOnPrimary,
    secondary: AppColors.primaryBright,
    surface: AppColors.surfaceLight,
    onSurface: AppColors.textPrimary,
    background: AppColors.backgroundLight,
    card: AppColors.cardLight,
    textPrimary: AppColors.textPrimary,
    textMuted: AppColors.textMuted,
    border: AppColors.borderLight,
    navSelected: AppColors.primary,
    navUnselected: AppColors.textMuted,
    textButtonForeground: AppColors.primary,
  );

  // Dark theme config
  static const _darkConfig = _ThemeConfig(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.textOnPrimary,
    secondary: AppColors.primaryBright,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.textPrimaryDark,
    background: AppColors.backgroundDark,
    card: AppColors.cardDark,
    textPrimary: AppColors.textPrimaryDark,
    textMuted: AppColors.textMutedDark,
    border: AppColors.borderDark,
    navSelected: AppColors.primaryBright,
    navUnselected: AppColors.textMutedDark,
    textButtonForeground: AppColors.primaryBright,
  );

  // High contrast light config
  static const _hcLightConfig = _ThemeConfig(
    brightness: Brightness.light,
    primary: AppColors.hcPrimary,
    onPrimary: AppColors.textOnPrimary,
    secondary: AppColors.hcPrimary,
    surface: AppColors.hcSurfaceLight,
    onSurface: AppColors.hcTextPrimary,
    background: AppColors.hcBackgroundLight,
    card: AppColors.hcCardLight,
    textPrimary: AppColors.hcTextPrimary,
    textMuted: AppColors.hcTextMuted,
    border: AppColors.hcBorderLight,
    navSelected: AppColors.hcPrimary,
    navUnselected: AppColors.hcTextMuted,
    textButtonForeground: AppColors.hcPrimary,
    cardBorder: BorderSide(color: AppColors.hcBorderLight, width: 2.0),
    dialogBorder: BorderSide(color: AppColors.hcBorderLight, width: 2.0),
    inputBorder: BorderSide(color: AppColors.hcBorderLight, width: 2.0),
    borderThickness: 2.0,
  );

  // High contrast dark config
  static const _hcDarkConfig = _ThemeConfig(
    brightness: Brightness.dark,
    primary: AppColors.hcPrimaryDark,
    onPrimary: AppColors.hcBackgroundDark,
    secondary: AppColors.hcPrimaryDark,
    surface: AppColors.hcSurfaceDark,
    onSurface: AppColors.hcTextPrimaryDark,
    background: AppColors.hcBackgroundDark,
    card: AppColors.hcCardDark,
    textPrimary: AppColors.hcTextPrimaryDark,
    textMuted: AppColors.hcTextMutedDark,
    border: AppColors.hcBorderDark,
    navSelected: AppColors.hcPrimaryDark,
    navUnselected: AppColors.hcTextMutedDark,
    textButtonForeground: AppColors.hcPrimaryDark,
    cardBorder: BorderSide(color: AppColors.hcBorderDark, width: 2.0),
    dialogBorder: BorderSide(color: AppColors.hcBorderDark, width: 2.0),
    inputBorder: BorderSide(color: AppColors.hcBorderDark, width: 2.0),
    borderThickness: 2.0,
  );

  static ThemeData get light => _buildTheme(_lightConfig);
  static ThemeData get dark => _buildTheme(_darkConfig);

  /// Resolve the correct theme based on user settings.
  static ThemeData resolve({
    required bool highContrast,
    required String textSize,
    required Brightness brightness,
  }) {
    final scale = AppTypography.scaleForTextSize(textSize);
    if (highContrast) {
      return brightness == Brightness.light
          ? _buildTheme(_hcLightConfig, scale: scale, bold: true)
          : _buildTheme(_hcDarkConfig, scale: scale, bold: true);
    }
    if (scale != 1.0) {
      return brightness == Brightness.light
          ? _buildTheme(_lightConfig, scale: scale)
          : _buildTheme(_darkConfig, scale: scale);
    }
    return brightness == Brightness.light ? light : dark;
  }

  /// Build a complete theme from configuration.
  static ThemeData _buildTheme(
    _ThemeConfig config, {
    double scale = 1.0,
    bool bold = false,
  }) {
    final textTheme = (scale != 1.0 || bold)
        ? AppTypography.scaledTextTheme(scaleFactor: scale, bold: bold).apply(
            bodyColor: config.textPrimary,
            displayColor: config.textPrimary,
          )
        : AppTypography.textTheme.apply(
            bodyColor: config.textPrimary,
            displayColor: config.textPrimary,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: config.brightness,
      colorScheme: config.brightness == Brightness.light
          ? ColorScheme.light(
              primary: config.primary,
              onPrimary: config.onPrimary,
              secondary: config.secondary,
              onSecondary: config.onPrimary,
              error: AppColors.error,
              onError: AppColors.textOnPrimary,
              surface: config.surface,
              onSurface: config.onSurface,
            )
          : ColorScheme.dark(
              primary: config.primary,
              onPrimary: config.onPrimary,
              secondary: config.secondary,
              onSecondary: config.onPrimary,
              error: AppColors.error,
              onError: AppColors.textOnPrimary,
              surface: config.surface,
              onSurface: config.onSurface,
            ),
      scaffoldBackgroundColor: config.background,
      textTheme: textTheme,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: config.surface,
        foregroundColor: config.textPrimary,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: config.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: config.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          side: config.cardBorder ?? BorderSide.none,
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: config.primary,
          foregroundColor: config.onPrimary,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: config.primary,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          side: BorderSide(color: config.primary, width: config.cardBorder != null ? 2.0 : 1.0),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: config.textButtonForeground,
          textStyle: textTheme.labelLarge,
          minimumSize: const Size(0, AppSpacing.minTapTarget),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: config.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: config.inputBorder ?? BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: config.inputBorder ?? BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: config.primary, width: config.cardBorder != null ? 2.0 : 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: config.textMuted),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: config.brightness == Brightness.light ? Colors.white : config.surface,
        selectedItemColor: config.navSelected,
        unselectedItemColor: config.navUnselected,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      dividerTheme: DividerThemeData(
        color: config.border,
        thickness: config.borderThickness,
        space: 0,
      ),
      dialogTheme: DialogThemeData(
        elevation: 0,
        backgroundColor: config.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: config.dialogBorder ?? BorderSide.none,
        ),
      ),
      chipTheme: ChipThemeData(
        elevation: 0,
        pressElevation: 0,
        backgroundColor: config.card,
        selectedColor: config.brightness == Brightness.light
            ? AppColors.primaryLight
            : AppColors.primaryDark,
        labelStyle: textTheme.labelMedium!,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        side: BorderSide.none,
      ),
    );
  }
}
