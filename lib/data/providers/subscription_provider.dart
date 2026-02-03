import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/services/subscription_service.dart';
import 'package:my_pill/data/providers/iap_provider.dart';
import 'package:my_pill/data/models/subscription_status.dart';

part 'subscription_provider.g.dart';

@riverpod
SubscriptionService subscriptionService(Ref ref) {
  final service = SubscriptionService();
  final iapService = ref.watch(iapServiceProvider);

  service.onStatusChanged = (status) {
    // Sync subscription status with IapService
    if (status.isPremium) {
      iapService.onPurchaseStateChanged?.call(true);
    }
  };

  service.initialize();
  ref.onDispose(() => service.dispose());
  return service;
}

@riverpod
bool isPremium(Ref ref) {
  final subscription = ref.watch(subscriptionServiceProvider);
  return subscription.isPremium;
}

@riverpod
int maxCaregivers(Ref ref) {
  final subscription = ref.watch(subscriptionServiceProvider);
  return subscription.maxCaregivers;
}

@riverpod
SubscriptionStatus subscriptionStatus(Ref ref) {
  final subscription = ref.watch(subscriptionServiceProvider);
  return subscription.status;
}
