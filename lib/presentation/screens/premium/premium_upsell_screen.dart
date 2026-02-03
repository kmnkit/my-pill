import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/data/models/subscription_status.dart';
import 'package:my_pill/data/providers/subscription_provider.dart';
import 'package:my_pill/data/services/subscription_service.dart';
import 'package:my_pill/data/services/ad_service.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';
import 'package:my_pill/l10n/app_localizations.dart';

class PremiumUpsellScreen extends ConsumerStatefulWidget {
  const PremiumUpsellScreen({super.key});

  @override
  ConsumerState<PremiumUpsellScreen> createState() => _PremiumUpsellScreenState();
}

class _PremiumUpsellScreenState extends ConsumerState<PremiumUpsellScreen> {
  bool _isYearly = true; // Default to yearly plan (best value)
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final subscriptionService = ref.watch(subscriptionServiceProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final status = ref.watch(subscriptionStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.premium),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(l10n),
            _buildFeaturesList(l10n),
            if (!isPremium) ...[
              _buildPlanToggle(l10n),
              _buildPurchaseButton(l10n, subscriptionService),
              _buildRestoreButton(l10n, subscriptionService),
            ] else ...[
              _buildPremiumStatus(l10n, status),
            ],
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primaryBright.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.diamond,
              size: 40,
              color: AppColors.textOnPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.unlockPremium,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.upgradeMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList(AppLocalizations l10n) {
    final features = [
      _FeatureItem(
        icon: Icons.block,
        title: l10n.noAds,
        description: 'Enjoy an ad-free experience',
      ),
      _FeatureItem(
        icon: Icons.people,
        title: l10n.unlimitedCaregivers,
        description: 'Connect with unlimited family members',
      ),
      _FeatureItem(
        icon: Icons.picture_as_pdf,
        title: l10n.pdfReports,
        description: 'Export detailed medication reports',
      ),
      _FeatureItem(
        icon: Icons.notifications_active,
        title: l10n.customSounds,
        description: 'Personalize notification sounds',
      ),
      _FeatureItem(
        icon: Icons.palette,
        title: l10n.premiumThemes,
        description: 'Access exclusive themes',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.premiumFeatures,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...features.map((feature) => _buildFeatureItem(feature)),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(_FeatureItem feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              feature.icon,
              color: AppColors.success,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  feature.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanToggle(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardLight,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          children: [
            _buildPlanOption(
              isSelected: !_isYearly,
              title: l10n.premiumMonthly,
              price: l10n.premiumMonthlyPrice,
              onTap: () => setState(() => _isYearly = false),
            ),
            Divider(height: 1, color: AppColors.borderLight),
            _buildPlanOption(
              isSelected: _isYearly,
              title: l10n.premiumYearly,
              price: l10n.premiumYearlyPrice,
              badge: '34% OFF',
              onTap: () => setState(() => _isYearly = true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanOption({
    required bool isSelected,
    required String title,
    required String price,
    String? badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.borderLight,
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: AppColors.textOnPrimary,
                    )
                  : null,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: Text(
                            badge,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.textOnPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchaseButton(AppLocalizations l10n, SubscriptionService service) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: MpButton(
        label: _isLoading ? l10n.loading : l10n.unlockPremium,
        onPressed: _isLoading ? null : () => _handlePurchase(service),
        variant: MpButtonVariant.primary,
        icon: Icons.diamond,
      ),
    );
  }

  Widget _buildRestoreButton(AppLocalizations l10n, SubscriptionService service) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: TextButton(
        onPressed: _isLoading ? null : () => _handleRestore(service),
        child: Text(
          l10n.restorePurchases,
          style: TextStyle(
            color: _isLoading ? AppColors.textMuted : AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumStatus(AppLocalizations l10n, SubscriptionStatus status) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.success),
        ),
        child: Column(
          children: [
            Icon(
              Icons.check_circle,
              size: AppSpacing.iconXl,
              color: AppColors.success,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.alreadyPremium,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
            ),
            if (status.expiresAt != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.premiumExpiresAt(
                  '${status.expiresAt!.year}-${status.expiresAt!.month.toString().padLeft(2, '0')}-${status.expiresAt!.day.toString().padLeft(2, '0')}',
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMuted,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handlePurchase(SubscriptionService service) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final success = _isYearly
          ? await service.purchaseYearly()
          : await service.purchaseMonthly();

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;

        if (success) {
          // Update ad service
          AdService().setAdsRemoved(true);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.accountLinked), // Reusing existing string
              backgroundColor: AppColors.success,
            ),
          );

          // Close screen after successful purchase
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Purchase failed. Please try again.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleRestore(SubscriptionService service) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      await service.restorePurchases();

      if (mounted) {
        final isPremium = ref.read(isPremiumProvider);

        if (isPremium) {
          AdService().setAdsRemoved(true);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Purchases restored successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No purchases found to restore.'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
