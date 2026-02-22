import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/core/theme/glass_decoration.dart';

enum MpButtonVariant { primary, secondary, text }

class MpButton extends StatelessWidget {
  const MpButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = MpButtonVariant.primary,
    this.isFullWidth = true,
    this.icon,
    this.iconWidget,
  });

  final String label;
  final VoidCallback? onPressed;
  final MpButtonVariant variant;
  final bool isFullWidth;
  final IconData? icon;
  final Widget? iconWidget;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isHighContrast = MediaQuery.of(context).highContrast;

    switch (variant) {
      case MpButtonVariant.primary:
        return Semantics(
          button: true,
          label: label,
          enabled: onPressed != null,
          child: SizedBox(
            width: isFullWidth ? double.infinity : null,
            height: AppSpacing.buttonHeight,
            child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: iconWidget ??
                  (icon != null
                      ? Icon(icon, size: AppSpacing.iconMd)
                      : const SizedBox.shrink()),
              label: Text(
                label,
                style: textTheme.labelLarge
                    ?.copyWith(color: AppColors.textOnPrimary),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
            ),
          ),
        );

      case MpButtonVariant.secondary:
        // Use glass effect for secondary buttons (unless high contrast)
        if (isHighContrast) {
          return _buildSolidSecondary(context, textTheme);
        }
        return _buildGlassSecondary(context, textTheme, isDark);

      case MpButtonVariant.text:
        return Semantics(
          button: true,
          label: label,
          enabled: onPressed != null,
          child: SizedBox(
            height: AppSpacing.minTapTarget,
            child: TextButton.icon(
              onPressed: onPressed,
              icon: iconWidget ??
                  (icon != null
                      ? Icon(icon, size: AppSpacing.iconMd)
                      : const SizedBox.shrink()),
              label: Text(
                label,
                style:
                    textTheme.labelLarge?.copyWith(color: AppColors.textMuted),
              ),
              style: TextButton.styleFrom(foregroundColor: AppColors.textMuted),
            ),
          ),
        );
    }
  }

  Widget _buildGlassSecondary(
      BuildContext context, TextTheme textTheme, bool isDark) {
    final blurAmount = GlassDecoration.getBlurAmount(context);

    return Semantics(
      button: true,
      label: label,
      enabled: onPressed != null,
      child: SizedBox(
        width: isFullWidth ? double.infinity : null,
        height: AppSpacing.buttonHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.glassDark : AppColors.glassWhite,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize:
                        isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (iconWidget != null || icon != null) ...[
                        iconWidget ?? Icon(icon, size: AppSpacing.iconMd, color: AppColors.primary),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Text(
                        label,
                        style: textTheme.labelLarge
                            ?.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSolidSecondary(BuildContext context, TextTheme textTheme) {
    return Semantics(
      button: true,
      label: label,
      enabled: onPressed != null,
      child: SizedBox(
        width: isFullWidth ? double.infinity : null,
        height: AppSpacing.buttonHeight,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: iconWidget ??
              (icon != null
                  ? Icon(icon, size: AppSpacing.iconMd)
                  : const SizedBox.shrink()),
          label: Text(
            label,
            style: textTheme.labelLarge?.copyWith(color: AppColors.primary),
          ),
          style: OutlinedButton.styleFrom(
            elevation: 0,
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
          ),
        ),
      ),
    );
  }
}
