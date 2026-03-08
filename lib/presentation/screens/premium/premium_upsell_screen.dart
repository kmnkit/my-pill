import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusuridoki/data/models/subscription_status.dart';
import 'package:kusuridoki/data/providers/subscription_provider.dart';
import 'package:kusuridoki/data/services/subscription_service.dart';
import 'package:kusuridoki/data/services/ad_service.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_button.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/core/constants/feature_flags.dart';
import 'package:kusuridoki/presentation/shared/widgets/gradient_scaffold.dart';

class PremiumUpsellScreen extends ConsumerStatefulWidget {
  const PremiumUpsellScreen({super.key});

  @override
  ConsumerState<PremiumUpsellScreen> createState() =>
      _PremiumUpsellScreenState();
}

class _PremiumUpsellScreenState extends ConsumerState<PremiumUpsellScreen> {
  bool _isYearly = true; // Default to yearly plan (best value)
  bool _isLoading = false;
  bool _productsLoading = false;
  bool _awaitingPurchaseResult = false;
  StreamSubscription<SubscriptionStatus>? _statusSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _setupSubscriptionCallbacks(),
    );
  }

  void _setupSubscriptionCallbacks() {
    final service = ref.read(subscriptionServiceProvider);

    if (!service.productsLoaded) {
      setState(() => _productsLoading = true);
      service.productsLoadedStream.first.then((_) {
        if (mounted) setState(() => _productsLoading = false);
      });
    }

    service.onPurchaseError = (error) {
      if (!mounted || !_awaitingPurchaseResult) return;
      _awaitingPurchaseResult = false;
      setState(() => _isLoading = false);
      if (error != 'canceled') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.purchaseFailed),
            backgroundColor: AppColors.error,
          ),
        );
      }
    };

    _statusSubscription = service.statusStream.listen((status) {
      if (!mounted || !_awaitingPurchaseResult || !status.isPremium) return;
      _awaitingPurchaseResult = false;
      AdService().setAdsRemoved(true);
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.alreadyPremium),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    final service = ref.read(subscriptionServiceProvider);
    service.onPurchaseError = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!kPremiumEnabled) {
      return GradientScaffold(
        appBar: AppBar(
          title: Text(l10n.premium),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.diamond_outlined,
                  size: 80,
                  color: AppColors.primary,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  l10n.premiumComingSoon,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.premiumComingSoonMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final subscriptionService = ref.watch(subscriptionServiceProvider);
    final isPremium = ref.watch(isPremiumProvider);
    final status = ref.watch(subscriptionStatusProvider);

    return GradientScaffold(
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
              _buildFreeTrialBadge(l10n),
              _buildPurchaseButton(l10n, subscriptionService),
              _buildSubscriptionTerms(l10n),
              _buildAdPrivacyNotice(l10n),
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
              color: context.appColors.textMuted,
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
        description: l10n.noAdsDescription,
      ),
      _FeatureItem(
        icon: Icons.people,
        title: l10n.unlimitedCaregivers,
        description: l10n.unlimitedCaregiversDescription,
      ),
      _FeatureItem(
        icon: Icons.picture_as_pdf,
        title: l10n.pdfReports,
        description: l10n.pdfReportsDescription,
      ),
      _FeatureItem(
        icon: Icons.notifications_active,
        title: l10n.customSounds,
        description: l10n.customSoundsDescription,
      ),
      _FeatureItem(
        icon: Icons.palette,
        title: l10n.premiumThemes,
        description: l10n.premiumThemesDescription,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.premiumFeatures,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
                    color: context.appColors.textMuted,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
              badge: l10n.off,
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
                      Flexible(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
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
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusSm,
                            ),
                          ),
                          child: Text(
                            badge,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
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

  Widget _buildPurchaseButton(
    AppLocalizations l10n,
    SubscriptionService service,
  ) {
    final busy = _isLoading || _productsLoading;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: KdButton(
        label: busy ? l10n.loading : l10n.unlockPremium,
        onPressed: busy ? null : () => _handlePurchase(service),
        variant: MpButtonVariant.primary,
        icon: Icons.diamond,
      ),
    );
  }

  Widget _buildFreeTrialBadge(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, size: 16, color: AppColors.success),
            const SizedBox(width: AppSpacing.xs),
            Text(
              l10n.freeTrial,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionTerms(AppLocalizations l10n) {
    final terms = Platform.isIOS ? l10n.subscriptionTerms : l10n.subscriptionTermsAndroid;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Text(
        terms,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: context.appColors.textMuted),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAdPrivacyNotice(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 14,
            color: context.appColors.textMuted,
          ),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              l10n.adPrivacyNotice,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.appColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestoreButton(
    AppLocalizations l10n,
    SubscriptionService service,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: TextButton(
        onPressed: _isLoading ? null : () => _handleRestore(service),
        child: Text(
          l10n.restorePurchases,
          style: TextStyle(
            color: _isLoading ? context.appColors.textMuted : AppColors.primary,
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
                  color: context.appColors.textMuted,
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
      final initiated = _isYearly
          ? await service.purchaseYearly()
          : await service.purchaseMonthly();

      if (!initiated && mounted) {
        // Failed to initiate: product not loaded or store unavailable
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.purchaseFailed),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      // Purchase sheet shown — wait for stream result via callbacks.
      // _awaitingPurchaseResult = true tells the listeners to react.
      if (mounted) setState(() => _awaitingPurchaseResult = true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _awaitingPurchaseResult = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorWithMessage(e.toString()),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _handleRestore(SubscriptionService service) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      await service.restorePurchases();
      // Allow the purchase stream time to process restored transactions.
      await Future<void>.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;
      setState(() => _isLoading = false);

      if (service.isPremium) {
        AdService().setAdsRemoved(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.purchasesRestored),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.noPurchasesFound)));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorWithMessage(e.toString()),
            ),
            backgroundColor: AppColors.error,
          ),
        );
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
