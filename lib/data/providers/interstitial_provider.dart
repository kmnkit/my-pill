import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/services/interstitial_controller.dart';

part 'interstitial_provider.g.dart';

@Riverpod(keepAlive: true)
InterstitialController interstitialController(Ref ref) {
  return InterstitialController();
}
