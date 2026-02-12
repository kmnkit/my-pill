import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/core/theme/glass_decoration.dart';

class MpCard extends StatelessWidget {
  const MpCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.borderColor,
    this.onTap,
    this.useGlass = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? borderColor;
  final VoidCallback? onTap;

  /// Whether to use glassmorphism effect. Defaults to true.
  /// Set to false for solid card backgrounds (e.g., high contrast mode).
  final bool useGlass;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isHighContrast = MediaQuery.of(context).highContrast;

    // Use solid style for high contrast mode or when glass is disabled
    if (isHighContrast || !useGlass) {
      return _buildSolidCard(context, isDark);
    }

    return _buildGlassCard(context, isDark);
  }

  Widget _buildGlassCard(BuildContext context, bool isDark) {
    final blurAmount = GlassDecoration.getBlurAmount(context);

    final cardContent = Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color ?? (isDark ? AppColors.glassDark : AppColors.glassWhite),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: borderColor ??
              (isDark ? AppColors.glassBorderDark : AppColors.glassBorder),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    final glassCard = ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: cardContent,
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: glassCard);
    }
    return glassCard;
  }

  Widget _buildSolidCard(BuildContext context, bool isDark) {
    final bgColor =
        color ?? (isDark ? AppColors.cardDark : AppColors.cardLight);

    final container = Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: container);
    }
    return container;
  }
}
