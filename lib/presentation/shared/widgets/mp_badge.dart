import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';

enum MpBadgeVariant { taken, missed, upcoming, lowStock, connected, snoozed }

class MpBadge extends StatelessWidget {
  const MpBadge({
    super.key,
    required this.label,
    required this.variant,
  });

  final String label;
  final MpBadgeVariant variant;

  Color get _backgroundColor {
    switch (variant) {
      case MpBadgeVariant.taken:
        return AppColors.success.withValues(alpha: 0.15);
      case MpBadgeVariant.missed:
        return AppColors.error.withValues(alpha: 0.15);
      case MpBadgeVariant.upcoming:
        return AppColors.info.withValues(alpha: 0.15);
      case MpBadgeVariant.lowStock:
        return AppColors.warning.withValues(alpha: 0.15);
      case MpBadgeVariant.connected:
        return AppColors.primary.withValues(alpha: 0.15);
      case MpBadgeVariant.snoozed:
        return AppColors.warningDark.withValues(alpha: 0.15);
    }
  }

  Color get _textColor {
    switch (variant) {
      case MpBadgeVariant.taken:
        return AppColors.success;
      case MpBadgeVariant.missed:
        return AppColors.error;
      case MpBadgeVariant.upcoming:
        return AppColors.info;
      case MpBadgeVariant.lowStock:
        return AppColors.warning;
      case MpBadgeVariant.connected:
        return AppColors.primary;
      case MpBadgeVariant.snoozed:
        return AppColors.warningDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Status: $label',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: ExcludeSemantics(
          child: Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: _textColor)),
        ),
      ),
    );
  }
}
