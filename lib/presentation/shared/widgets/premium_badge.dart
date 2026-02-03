import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/l10n/app_localizations.dart';

/// Premium badge widget
///
/// Displays a small "PRO" or crown icon badge next to premium features.
/// Usage:
/// ```dart
/// Row(
///   children: [
///     Text('Unlimited Caregivers'),
///     SizedBox(width: 4),
///     PremiumBadge(),
///   ],
/// )
/// ```
class PremiumBadge extends StatelessWidget {
  final bool mini;
  final bool showIcon;
  final bool showText;

  const PremiumBadge({
    super.key,
    this.mini = false,
    this.showIcon = true,
    this.showText = true,
  });

  /// Compact version with icon only
  const PremiumBadge.iconOnly({
    super.key,
    this.mini = true,
  }) : showIcon = true,
       showText = false;

  /// Compact version with text only
  const PremiumBadge.textOnly({
    super.key,
    this.mini = false,
  }) : showIcon = false,
       showText = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (mini && showIcon && !showText) {
      // Icon-only mini badge
      return Semantics(
        label: l10n.premium,
        child: Icon(
          Icons.workspace_premium,
          size: AppSpacing.iconSm,
          color: AppColors.warning,
        ),
      );
    }

    return Semantics(
      label: l10n.premium,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: mini ? AppSpacing.xs : AppSpacing.sm,
          vertical: mini ? 2.0 : AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFD700), // Gold
              Color(0xFFFFA500), // Orange
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(
                Icons.workspace_premium,
                size: mini ? AppSpacing.iconSm : AppSpacing.iconMd,
                color: Colors.white,
              ),
              if (showText) const SizedBox(width: 4),
            ],
            if (showText)
              Text(
                'PRO',
                style: TextStyle(
                  fontSize: mini ? 10 : 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Premium tag for feature lists
///
/// Larger badge for use in feature lists or settings.
class PremiumTag extends StatelessWidget {
  const PremiumTag({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFD700), // Gold
            Color(0xFFFFA500), // Orange
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.workspace_premium,
            size: AppSpacing.iconSm,
            color: Colors.white,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            l10n.premium,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
