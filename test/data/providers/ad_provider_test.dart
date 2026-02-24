import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/providers/ad_provider.dart';
import 'package:my_pill/data/services/ad_service.dart';

void main() {
  group('adServiceProvider', () {
    test('provider exists and has correct name', () {
      expect(adServiceProvider.name, 'adServiceProvider');
    });

    test('can be overridden with a value', () {
      final service = AdService();
      final container = ProviderContainer(
        overrides: [
          adServiceProvider.overrideWithValue(service),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(adServiceProvider);
      expect(result, isA<AdService>());
      expect(result, same(service));
    });

    test('returns AdService instance when overridden', () {
      final service = AdService();
      final container = ProviderContainer(
        overrides: [
          adServiceProvider.overrideWithValue(service),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(adServiceProvider);
      expect(result.adsRemoved, isFalse);
    });

    test('setAdsRemoved updates state on overridden service', () {
      final service = AdService();
      final container = ProviderContainer(
        overrides: [
          adServiceProvider.overrideWithValue(service),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(adServiceProvider);
      result.setAdsRemoved(true);
      expect(result.adsRemoved, isTrue);
    });
  });
}
