import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class IapService {
  static const String removeAdsProductId = 'remove_ads';
  static const String monthlyProductId = 'premium_monthly';
  static const String yearlyProductId = 'premium_yearly';

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  bool _available = false;
  bool _adsRemoved = false;
  ProductDetails? _removeAdsProduct;

  // Callback when purchase state changes
  void Function(bool adsRemoved)? onPurchaseStateChanged;

  bool get adsRemoved => _adsRemoved;
  ProductDetails? get removeAdsProduct => _removeAdsProduct;

  Future<void> initialize() async {
    _available = await _iap.isAvailable();
    if (!_available) {
      debugPrint('IAP not available');
      return;
    }

    // Listen for purchase updates
    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (error) => debugPrint('IAP error: $error'),
    );

    // Load product details (including subscription products)
    final response = await _iap.queryProductDetails({
      removeAdsProductId,
      monthlyProductId,
      yearlyProductId,
    });
    for (final product in response.productDetails) {
      if (product.id == removeAdsProductId) {
        _removeAdsProduct = product;
        break;
      }
    }

    // Check for previous purchases (restore)
    await restorePurchases();
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      // Handle both legacy remove_ads and new subscription products
      if (purchase.productID == removeAdsProductId ||
          purchase.productID == monthlyProductId ||
          purchase.productID == yearlyProductId) {
        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          _adsRemoved = true;
          onPurchaseStateChanged?.call(true);
        }

        if (purchase.pendingCompletePurchase) {
          _iap.completePurchase(purchase);
        }
      }
    }
  }

  Future<bool> purchaseRemoveAds() async {
    if (!_available || _removeAdsProduct == null) return false;

    final purchaseParam = PurchaseParam(productDetails: _removeAdsProduct!);
    return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    if (!_available) return;
    await _iap.restorePurchases();
  }

  void dispose() {
    _subscription?.cancel();
  }
}
