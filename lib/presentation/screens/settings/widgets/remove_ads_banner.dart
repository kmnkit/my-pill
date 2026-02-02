import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/services/ad_service.dart';
import 'package:my_pill/data/services/iap_service.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';

class RemoveAdsBanner extends ConsumerStatefulWidget {
  const RemoveAdsBanner({super.key});

  @override
  ConsumerState<RemoveAdsBanner> createState() => _RemoveAdsBannerState();
}

class _RemoveAdsBannerState extends ConsumerState<RemoveAdsBanner> {
  final IapService _iapService = IapService();
  bool _isLoading = false;
  bool _adsRemoved = false;

  @override
  void initState() {
    super.initState();
    _initializeIap();
  }

  Future<void> _initializeIap() async {
    try {
      await _iapService.initialize();
      _iapService.onPurchaseStateChanged = (adsRemoved) {
        if (mounted) {
          setState(() {
            _adsRemoved = adsRemoved;
          });
        }
      };
      setState(() {
        _adsRemoved = _iapService.adsRemoved;
      });
    } catch (e) {
      debugPrint('Failed to initialize IAP: $e');
    }
  }

  Future<void> _purchaseRemoveAds() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _iapService.purchaseRemoveAds();
      if (mounted) {
        if (success) {
          AdService().setAdsRemoved(true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ads removed successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
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
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _restorePurchases() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _iapService.restorePurchases();
      if (mounted) {
        if (_iapService.adsRemoved) {
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
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Don't show banner if ads are already removed
    if (_adsRemoved) {
      return const SizedBox.shrink();
    }

    return MpCard(
      color: AppColors.primary.withValues(alpha: 0.1),
      borderColor: AppColors.primary,
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.diamond, size: AppSpacing.iconLg, color: AppColors.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Upgrade for a cleaner experience',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.primary,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          MpButton(
            label: _isLoading ? 'Processing...' : 'Remove Ads',
            onPressed: _isLoading ? null : _purchaseRemoveAds,
            variant: MpButtonVariant.primary,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: _isLoading ? null : _restorePurchases,
            child: Text(
              'Restore Purchases',
              style: TextStyle(
                color: _isLoading ? AppColors.textMuted : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
