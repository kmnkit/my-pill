import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';

enum MpButtonVariant { primary, secondary, text }

class MpButton extends StatelessWidget {
  const MpButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = MpButtonVariant.primary,
    this.isFullWidth = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final MpButtonVariant variant;
  final bool isFullWidth;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
              icon: icon != null ? Icon(icon, size: AppSpacing.iconMd) : const SizedBox.shrink(),
              label: Text(label, style: textTheme.labelLarge?.copyWith(color: AppColors.textOnPrimary)),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
              ),
            ),
          ),
        );
      case MpButtonVariant.secondary:
        return Semantics(
          button: true,
          label: label,
          enabled: onPressed != null,
          child: SizedBox(
            width: isFullWidth ? double.infinity : null,
            height: AppSpacing.buttonHeight,
            child: OutlinedButton.icon(
              onPressed: onPressed,
              icon: icon != null ? Icon(icon, size: AppSpacing.iconMd) : const SizedBox.shrink(),
              label: Text(label, style: textTheme.labelLarge?.copyWith(color: AppColors.primary)),
              style: OutlinedButton.styleFrom(
                elevation: 0,
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
              ),
            ),
          ),
        );
      case MpButtonVariant.text:
        return Semantics(
          button: true,
          label: label,
          enabled: onPressed != null,
          child: SizedBox(
            height: AppSpacing.minTapTarget,
            child: TextButton.icon(
              onPressed: onPressed,
              icon: icon != null ? Icon(icon, size: AppSpacing.iconMd) : const SizedBox.shrink(),
              label: Text(label, style: textTheme.labelLarge?.copyWith(color: AppColors.textMuted)),
              style: TextButton.styleFrom(foregroundColor: AppColors.textMuted),
            ),
          ),
        );
    }
  }
}
