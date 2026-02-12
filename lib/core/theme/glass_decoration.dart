import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';

/// Helper class for glassmorphism decoration styles.
abstract final class GlassDecoration {
  /// Standard blur amount for glass effects.
  static const double blurAmount = 15.0;

  /// Strong blur amount for nav bar and prominent elements.
  static const double blurAmountStrong = 20.0;

  /// Glass card decoration for light/dark mode.
  static BoxDecoration card({required bool isDark}) => BoxDecoration(
        color: isDark ? AppColors.glassDark : AppColors.glassWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: isDark ? AppColors.glassBorderDark : AppColors.glassBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      );

  /// Strong glass card decoration (more opaque).
  static BoxDecoration cardStrong({required bool isDark}) => BoxDecoration(
        color: isDark ? AppColors.glassDarkStrong : AppColors.glassWhiteStrong,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: isDark ? AppColors.glassBorderDark : AppColors.glassBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      );

  /// Navigation bar glass decoration (floating pill style).
  static BoxDecoration navBar({required bool isDark}) => BoxDecoration(
        color: isDark ? AppColors.glassDarkStrong : AppColors.glassWhiteStrong,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.glassBorderDark : AppColors.glassBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      );

  /// ImageFilter for blur effect.
  static ImageFilter get blurFilter =>
      ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount);

  /// Strong ImageFilter for nav bar and prominent elements.
  static ImageFilter get blurFilterStrong =>
      ImageFilter.blur(sigmaX: blurAmountStrong, sigmaY: blurAmountStrong);

  /// Check if reduced motion is enabled for accessibility.
  static bool shouldReduceMotion(BuildContext context) =>
      MediaQuery.of(context).disableAnimations;

  /// Get blur amount based on accessibility settings.
  static double getBlurAmount(BuildContext context, {bool strong = false}) {
    if (shouldReduceMotion(context)) return 0.0;
    return strong ? blurAmountStrong : blurAmount;
  }

  /// Get blur filter based on accessibility settings.
  static ImageFilter getBlurFilter(BuildContext context, {bool strong = false}) {
    final amount = getBlurAmount(context, strong: strong);
    return ImageFilter.blur(sigmaX: amount, sigmaY: amount);
  }
}
