import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/services/interstitial_controller.dart';
import 'package:my_pill/data/providers/ad_provider.dart';
import 'package:my_pill/data/providers/iap_provider.dart';

part 'interstitial_provider.g.dart';

@Riverpod(keepAlive: true)
InterstitialController interstitialController(Ref ref) {
  return InterstitialController();
}

@riverpod
Future<void> maybeShowInterstitial(Ref ref) async {
  final adsRemoved = ref.read(adsRemovedProvider);
  if (adsRemoved) return;

  final controller = ref.read(interstitialControllerProvider);
  if (!controller.shouldShowInterstitial()) return;

  final adService = ref.read(adServiceProvider);
  await adService.showInterstitial();
  controller.onInterstitialShown();
}
