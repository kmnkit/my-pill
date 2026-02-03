import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/models/subscription_status.dart';
import 'package:my_pill/data/providers/subscription_provider.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';
import 'package:my_pill/l10n/app_localizations.dart';

class PremiumBanner extends ConsumerWidget {
  const PremiumBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isPremium = ref.watch(isPremiumProvider);
    final status = ref.watch(subscriptionStatusProvider);

    if (isPremium) {
      // Show premium status for premium users
      return _buildPremiumStatus(context, l10n, status);
    } else {
      // Show upgrade banner for free users
      return _buildUpgradeBanner(context, l10n);
    }
  }

  Widget _buildUpgradeBanner(BuildContext context, AppLocalizations l10n) {
    return MpCard(
      color: AppColors.primary.withValues(alpha: 0.1),
      borderColor: AppColors.primary,
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.diamond,
                size: AppSpacing.iconLg,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.premium,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.upgradeMessage,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textMuted,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          MpButton(
            label: l10n.unlockPremium,
            onPressed: () => context.push('/premium'),
            variant: MpButtonVariant.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumStatus(
    BuildContext context,
    AppLocalizations l10n,
    SubscriptionStatus status,
  ) {
    return MpCard(
      color: AppColors.success.withValues(alpha: 0.1),
      borderColor: AppColors.success,
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                size: AppSpacing.iconLg,
                color: AppColors.success,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.alreadyPremium,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (status.expiresAt != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.premiumExpiresAt(
                          '${status.expiresAt!.year}-${status.expiresAt!.month.toString().padLeft(2, '0')}-${status.expiresAt!.day.toString().padLeft(2, '0')}',
                        ),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textMuted,
                            ),
                      ),
                    ] else ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.currentPlan,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textMuted,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          MpButton(
            label: 'Manage Subscription',
            onPressed: () => context.push('/premium'),
            variant: MpButtonVariant.secondary,
          ),
        ],
      ),
    );
  }
}
