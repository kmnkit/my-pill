import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:kusuridoki/data/models/subscription_status.dart';

class SubscriptionService {
  static const String monthlyProductId = 'premium_monthly';
  static const String yearlyProductId = 'premium_yearly';

  final _statusController = StreamController<SubscriptionStatus>.broadcast();
  Stream<SubscriptionStatus> get statusStream => _statusController.stream;

  final _productsController = StreamController<void>.broadcast();
  Stream<void> get productsLoadedStream => _productsController.stream;

  bool _productsLoaded = false;
  bool get productsLoaded => _productsLoaded;
  final SubscriptionStatus _status = const SubscriptionStatus();

  void Function(SubscriptionStatus status)? onStatusChanged;
  void Function(String error)? onPurchaseError;

  SubscriptionStatus get status => _status;
  bool get isPremium => _status.isPremium;
  int get maxCaregivers => isPremium ? 999 : 1;
  int get maxPatients => isPremium ? 999 : 1;

  Future<void> initialize() async {
    debugPrint('SubscriptionService: IAP disabled');
    _productsLoaded = true;
    _productsController.add(null);
  }

  Future<bool> purchaseMonthly() async => false;

  Future<bool> purchaseYearly() async => false;

  Future<void> restorePurchases() async {}

  void dispose() {
    _statusController.close();
    _productsController.close();
  }
}
