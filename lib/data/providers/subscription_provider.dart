import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kusuridoki/core/constants/feature_flags.dart';
import 'package:kusuridoki/data/services/subscription_service.dart';
import 'package:kusuridoki/data/providers/ad_provider.dart';
import 'package:kusuridoki/data/models/subscription_status.dart';

part 'subscription_provider.g.dart';

@riverpod
SubscriptionService subscriptionService(Ref ref) {
  final service = SubscriptionService();

  if (!kPremiumEnabled) {
    return service;
  }

  final adService = ref.watch(adServiceProvider);

  service.onStatusChanged = (status) {
    if (status.isPremium) {
      adService.setAdsRemoved(true);
    }
  };

  service.initialize();
  ref.onDispose(() => service.dispose());
  return service;
}

@riverpod
bool isPremium(Ref ref) {
  if (!kPremiumEnabled) return true;
  final subscription = ref.watch(subscriptionServiceProvider);
  return subscription.isPremium;
}

@riverpod
int maxCaregivers(Ref ref) {
  if (!kPremiumEnabled) return 999;
  final subscription = ref.watch(subscriptionServiceProvider);
  return subscription.maxCaregivers;
}

@riverpod
int maxPatients(Ref ref) {
  if (!kPremiumEnabled) return 999;
  final subscription = ref.watch(subscriptionServiceProvider);
  return subscription.maxPatients;
}

@riverpod
SubscriptionStatus subscriptionStatus(Ref ref) {
  final subscription = ref.watch(subscriptionServiceProvider);
  return subscription.status;
}
