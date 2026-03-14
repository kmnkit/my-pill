import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:kusuridoki/core/constants/revenuecat_config.dart';
import 'package:kusuridoki/data/models/subscription_status.dart';

class SubscriptionService {
  static const String monthlyProductId = 'premium_monthly';
  static const String yearlyProductId = 'premium_yearly';

  /// Free trial duration offered before subscription billing begins.
  /// Configured in RevenueCat during Phase 2 activation.
  static const int kTrialDays = 7;

  final _statusController = StreamController<SubscriptionStatus>.broadcast();
  Stream<SubscriptionStatus> get statusStream => _statusController.stream;

  final _productsController = StreamController<void>.broadcast();
  Stream<void> get productsLoadedStream => _productsController.stream;

  bool _productsLoaded = false;
  bool get productsLoaded => _productsLoaded;
  SubscriptionStatus _status = const SubscriptionStatus();

  void Function(SubscriptionStatus status)? onStatusChanged;
  void Function(String error)? onPurchaseError;

  SubscriptionStatus get status => _status;
  bool get isPremium => _status.isPremium;
  int get maxCaregivers => isPremium ? 999 : 1;
  int get maxPatients => isPremium ? 999 : 1;

  Offerings? _offerings;
  String? _lastUserId;

  Future<void> initialize() async {
    if (RevenueCatConfig.apiKey.isEmpty) {
      debugPrint(
        'SubscriptionService: REVENUECAT_API_KEY is empty. '
        'Skipping initialization. '
        'Set keys in .env and run build_runner.',
      );
      _productsController.add(null);
      return;
    }

    try {
      if (kDebugMode) {
        await Purchases.setLogLevel(LogLevel.debug);
      }

      await Purchases.configure(
        PurchasesConfiguration(RevenueCatConfig.apiKey),
      );

      Purchases.addCustomerInfoUpdateListener((customerInfo) {
        _updateStatus(customerInfo);
      });

      final results = await Future.wait([
        Purchases.getCustomerInfo(),
        Purchases.getOfferings(),
      ]);
      _updateStatus(results[0] as CustomerInfo);
      _offerings = results[1] as Offerings;
      _productsLoaded = true;
      _productsController.add(null);
    } catch (e, stackTrace) {
      debugPrint('SubscriptionService: initialize failed — $e');
      debugPrintStack(stackTrace: stackTrace);
      _productsController.add(null);
    }
  }

  void _updateStatus(CustomerInfo customerInfo) {
    final active = customerInfo.entitlements.active;
    final entitlement = active[RevenueCatConfig.entitlementId];

    final SubscriptionStatus newStatus;
    if (entitlement == null) {
      newStatus = const SubscriptionStatus();
    } else {
      final expiresAt = DateTime.tryParse(entitlement.expirationDate ?? '');
      final isOnTrial = entitlement.periodType == PeriodType.trial;

      newStatus = SubscriptionStatus(
        isPremium: true,
        isOnTrial: isOnTrial,
        productId: entitlement.productIdentifier,
        expiresAt: expiresAt,
        trialEndsAt: isOnTrial ? expiresAt : null,
        platform: _mapStore(entitlement.store),
      );
    }

    if (newStatus == _status) return;
    _status = newStatus;
    _statusController.add(_status);
    onStatusChanged?.call(_status);
  }

  SubscriptionPlatform _mapStore(Store store) {
    switch (store) {
      case Store.appStore:
      case Store.macAppStore:
        return SubscriptionPlatform.appStore;
      case Store.playStore:
        return SubscriptionPlatform.playStore;
      default:
        return SubscriptionPlatform.none;
    }
  }

  Future<bool> purchaseMonthly() async {
    final package = _offerings?.current?.monthly;
    if (package == null) return false;
    return _purchase(package);
  }

  Future<bool> purchaseYearly() async {
    final package = _offerings?.current?.annual;
    if (package == null) return false;
    return _purchase(package);
  }

  Future<bool> _purchase(Package package) async {
    try {
      final params = PurchaseParams.package(package);
      final result = await Purchases.purchase(params);
      _updateStatus(result.customerInfo);
      return true;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        onPurchaseError?.call('canceled');
      } else {
        onPurchaseError?.call('purchase_failed');
      }
      return false;
    } catch (e) {
      onPurchaseError?.call('purchase_failed');
      return false;
    }
  }

  Future<void> setUserId(String? userId) async {
    if (userId == _lastUserId) return;
    _lastUserId = userId;
    try {
      if (userId != null) {
        final result = await Purchases.logIn(userId);
        _updateStatus(result.customerInfo);
      } else {
        final customerInfo = await Purchases.logOut();
        _updateStatus(customerInfo);
      }
    } catch (e, stackTrace) {
      debugPrint('SubscriptionService: setUserId failed — $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      _updateStatus(customerInfo);
    } on PlatformException catch (e) {
      debugPrint('SubscriptionService: restorePurchases failed — $e');
      onPurchaseError?.call(e.message ?? 'restore_failed');
    } catch (e) {
      debugPrint('SubscriptionService: restorePurchases failed — $e');
      onPurchaseError?.call('restore_failed');
    }
  }

  void dispose() {
    _statusController.close();
    _productsController.close();
  }
}
