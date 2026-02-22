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
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final MpButtonVariant variant;
  final bool isFullWidth;
  final IconData? icon;
  final Widget? iconWidget;
  final bool isLoading;

  Widget _buildIconOrLoading({required Color color}) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }
    if (iconWidget != null) return iconWidget!;
    if (icon != null) return Icon(icon, size: AppSpacing.iconMd);
    return const SizedBox.shrink();
  }

  VoidCallback? get _effectiveOnPressed => isLoading ? null : onPressed;

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
          enabled: _effectiveOnPressed != null,
          child: SizedBox(
            width: isFullWidth ? double.infinity : null,
            height: AppSpacing.buttonHeight,
            child: ElevatedButton.icon(
              onPressed: _effectiveOnPressed,
              icon: _buildIconOrLoading(color: AppColors.textOnPrimary),
              label: isLoading
                  ? const SizedBox.shrink()
                  : Text(
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
          enabled: _effectiveOnPressed != null,
          child: SizedBox(
            height: AppSpacing.minTapTarget,
            child: TextButton.icon(
              onPressed: _effectiveOnPressed,
              icon: _buildIconOrLoading(color: AppColors.textMuted),
              label: isLoading
                  ? const SizedBox.shrink()
                  : Text(
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
      enabled: _effectiveOnPressed != null,
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
                onTap: _effectiveOnPressed,
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
                  child: isLoading
                      ? _buildIconOrLoading(color: AppColors.primary)
                      : Row(
                          mainAxisSize:
                              isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (iconWidget != null) ...[
                              iconWidget!,
                              const SizedBox(width: AppSpacing.sm),
                            ] else if (icon != null) ...[
                              Icon(icon, size: AppSpacing.iconMd, color: AppColors.primary),
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
      enabled: _effectiveOnPressed != null,
      child: SizedBox(
        width: isFullWidth ? double.infinity : null,
        height: AppSpacing.buttonHeight,
        child: OutlinedButton.icon(
          onPressed: _effectiveOnPressed,
          icon: _buildIconOrLoading(color: AppColors.primary),
          label: isLoading
              ? const SizedBox.shrink()
              : Text(
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
