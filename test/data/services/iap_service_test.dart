import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/services/iap_service.dart';

void main() {
  // IapService constructor accesses InAppPurchase.instance which requires
  // a platform channel. We can only test static constants without instantiation.

  group('IapService constants', () {
    test('removeAdsProductId is correct', () {
      expect(IapService.removeAdsProductId, 'remove_ads');
    });

    test('monthlyProductId is correct', () {
      expect(IapService.monthlyProductId, 'premium_monthly');
    });

    test('yearlyProductId is correct', () {
      expect(IapService.yearlyProductId, 'premium_yearly');
    });

    test('product ID constants are distinct', () {
      final ids = {
        IapService.removeAdsProductId,
        IapService.monthlyProductId,
        IapService.yearlyProductId,
      };
      expect(ids.length, 3);
    });

    test('removeAdsProductId is non-empty', () {
      expect(IapService.removeAdsProductId.isNotEmpty, isTrue);
    });

    test('monthlyProductId is non-empty', () {
      expect(IapService.monthlyProductId.isNotEmpty, isTrue);
    });

    test('yearlyProductId is non-empty', () {
      expect(IapService.yearlyProductId.isNotEmpty, isTrue);
    });
  });
}
