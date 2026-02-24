import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/providers/iap_provider.dart';
import 'package:my_pill/data/services/iap_service.dart';

void main() {
  group('iapServiceProvider', () {
    test('provider exists and has correct name', () {
      expect(iapServiceProvider.name, 'iapServiceProvider');
    });
  });

  group('adsRemovedProvider', () {
    test('provider exists and has correct name', () {
      expect(adsRemovedProvider.name, 'adsRemovedProvider');
    });

    test('can be overridden directly with true', () {
      final container = ProviderContainer(
        overrides: [
          adsRemovedProvider.overrideWithValue(true),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(adsRemovedProvider), isTrue);
    });

    test('can be overridden directly with false', () {
      final container = ProviderContainer(
        overrides: [
          adsRemovedProvider.overrideWithValue(false),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(adsRemovedProvider), isFalse);
    });
  });

  group('IapService static constants', () {
    test('product IDs are correct', () {
      expect(IapService.removeAdsProductId, 'remove_ads');
      expect(IapService.monthlyProductId, 'premium_monthly');
      expect(IapService.yearlyProductId, 'premium_yearly');
    });
  });
}
