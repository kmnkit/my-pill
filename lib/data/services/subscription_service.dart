import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:my_pill/data/models/subscription_status.dart';
import 'package:my_pill/data/services/iap_service.dart';

class SubscriptionService {
  static const String monthlyProductId = 'premium_monthly';
  static const String yearlyProductId = 'premium_yearly';

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  final _statusController = StreamController<SubscriptionStatus>.broadcast();
  Stream<SubscriptionStatus> get statusStream => _statusController.stream;

  bool _available = false;
  SubscriptionStatus _status = const SubscriptionStatus();
  ProductDetails? _monthlyProduct;
  ProductDetails? _yearlyProduct;

  // Callback when subscription state changes
  void Function(SubscriptionStatus status)? onStatusChanged;

  SubscriptionStatus get status => _status;
  bool get isPremium => _status.isPremium;
  int get maxCaregivers => isPremium ? 999 : 1;
  ProductDetails? get monthlyProduct => _monthlyProduct;
  ProductDetails? get yearlyProduct => _yearlyProduct;

  Future<void> initialize() async {
    _available = await _iap.isAvailable();
    if (!_available) {
      debugPrint('IAP not available');
      return;
    }

    // Listen for purchase updates
    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (error) => debugPrint('Subscription IAP error: $error'),
    );

    // Load product details
    final response = await _iap.queryProductDetails({
      monthlyProductId,
      yearlyProductId,
      IapService.removeAdsProductId, // Legacy support
    });

    for (final product in response.productDetails) {
      if (product.id == monthlyProductId) {
        _monthlyProduct = product;
      } else if (product.id == yearlyProductId) {
        _yearlyProduct = product;
      }
    }

    // Check for previous purchases (restore)
    await restorePurchases();
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.productID == monthlyProductId ||
          purchase.productID == yearlyProductId ||
          purchase.productID == IapService.removeAdsProductId) {
        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          _updateStatus(purchase);
        }

        if (purchase.pendingCompletePurchase) {
          _iap.completePurchase(purchase);
        }
      }
    }
  }

  void _updateStatus(PurchaseDetails purchase) {
    final isPremium = purchase.productID == monthlyProductId ||
        purchase.productID == yearlyProductId ||
        purchase.productID == IapService.removeAdsProductId; // Legacy support

    SubscriptionPlatform platform = SubscriptionPlatform.none;
    if (isPremium) {
      // Determine platform from purchase details
      if (purchase.verificationData.source == 'app_store') {
        platform = SubscriptionPlatform.appStore;
      } else if (purchase.verificationData.source == 'google_play') {
        platform = SubscriptionPlatform.playStore;
      }
    }

    _status = SubscriptionStatus(
      isPremium: isPremium,
      productId: purchase.productID,
      expiresAt: null, // Would need server-side verification for actual expiry
      platform: platform,
    );

    _statusController.add(_status);
    onStatusChanged?.call(_status);
  }

  Future<bool> purchaseMonthly() async {
    if (!_available || _monthlyProduct == null) return false;

    final purchaseParam = PurchaseParam(productDetails: _monthlyProduct!);
    return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<bool> purchaseYearly() async {
    if (!_available || _yearlyProduct == null) return false;

    final purchaseParam = PurchaseParam(productDetails: _yearlyProduct!);
    return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    if (!_available) return;
    await _iap.restorePurchases();
  }

  void dispose() {
    _subscription?.cancel();
    _statusController.close();
  }
}
