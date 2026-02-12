import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/subscription_provider.dart';
import 'package:my_pill/presentation/router/route_names.dart';
import 'package:my_pill/l10n/app_localizations.dart';

/// Premium feature gate widget
///
/// Wraps premium features and displays a locked state for free users.
/// Usage:
/// ```dart
/// PremiumGate(
///   featureName: 'Unlimited Caregivers',
///   child: CaregiverAddButton(),
/// )
/// ```
class PremiumGate extends ConsumerWidget {
  final Widget child;
  final Widget? lockedWidget;
  final String featureName;
  final VoidCallback? onLockedTap;

  const PremiumGate({
    super.key,
    required this.child,
    this.lockedWidget,
    required this.featureName,
    this.onLockedTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider);

    if (isPremium) {
      return child;
    }

    return lockedWidget ?? PremiumLockedCard(
      featureName: featureName,
      onTap: onLockedTap ?? () => _showUpgradeDialog(context),
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.workspace_premium,
              color: AppColors.warning,
              size: AppSpacing.iconLg,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(l10n.premiumFeature),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.unlockThisFeature),
              const SizedBox(height: AppSpacing.md),
              Text(
                featureName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              context.push(RouteNames.premium);
            },
            icon: const Icon(Icons.upgrade, size: AppSpacing.iconSm),
            label: Text(l10n.unlockPremium),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}

/// Premium locked card
///
/// Displays a card indicating that a feature is locked behind premium.
class PremiumLockedCard extends StatelessWidget {
  final String featureName;
  final VoidCallback? onTap;

  const PremiumLockedCard({
    super.key,
    required this.featureName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Semantics(
      label: '${l10n.premiumFeature}: $featureName',
      button: true,
      child: Material(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Premium icon
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.workspace_premium,
                    size: AppSpacing.iconXl * 1.5,
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Feature name
                Text(
                  featureName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),

                // Premium label
                Text(
                  l10n.premiumFeature,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),

                // Unlock button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.lock_open, size: AppSpacing.iconSm),
                    label: Text(l10n.unlockPremium),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.warning,
                      foregroundColor: AppColors.textOnPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Inline premium upsell widget
///
/// Displays a compact upsell message within a list or form.
class PremiumInlineUpsell extends StatelessWidget {
  final String message;
  final VoidCallback? onTap;

  const PremiumInlineUpsell({
    super.key,
    required this.message,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.workspace_premium,
            color: AppColors.warning,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          TextButton(
            onPressed: onTap ?? () => context.push(RouteNames.premium),
            child: Text(
              l10n.tryPremium,
              style: const TextStyle(
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
