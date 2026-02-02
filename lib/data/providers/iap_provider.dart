import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/services/iap_service.dart';
import 'package:my_pill/data/providers/ad_provider.dart';

part 'iap_provider.g.dart';

@riverpod
IapService iapService(Ref ref) {
  final service = IapService();
  final adService = ref.watch(adServiceProvider);

  service.onPurchaseStateChanged = (adsRemoved) {
    adService.setAdsRemoved(adsRemoved);
  };

  service.initialize();
  ref.onDispose(() => service.dispose());
  return service;
}

@riverpod
bool adsRemoved(Ref ref) {
  final iap = ref.watch(iapServiceProvider);
  return iap.adsRemoved;
}
