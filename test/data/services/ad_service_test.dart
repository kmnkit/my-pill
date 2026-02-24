import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/services/ad_service.dart';

void main() {
  group('AdService', () {
    test('factory constructor returns singleton', () {
      final a = AdService();
      final b = AdService();
      expect(identical(a, b), isTrue);
    });

    test('initial adsRemoved is false', () {
      final service = AdService();
      expect(service.adsRemoved, isFalse);
    });

    test('setAdsRemoved updates adsRemoved state', () {
      final service = AdService();
      service.setAdsRemoved(true);
      expect(service.adsRemoved, isTrue);
      // Reset for other tests (singleton)
      service.setAdsRemoved(false);
    });

    test('getHomeBannerAd returns null when not initialized', () {
      final service = AdService();
      // Not initialized + _hideAdsForScreenshots = true → should return null
      expect(service.getHomeBannerAd(), isNull);
    });

    test('getMedicationsBannerAd returns null when not initialized', () {
      final service = AdService();
      expect(service.getMedicationsBannerAd(), isNull);
    });

    test('disposeAll does not throw', () {
      final service = AdService();
      expect(() => service.disposeAll(), returnsNormally);
    });

    test('setAdsRemoved(true) calls disposeAll internally', () {
      final service = AdService();
      // Should not throw even when no ads are loaded
      expect(() => service.setAdsRemoved(true), returnsNormally);
      expect(service.adsRemoved, isTrue);
      // Reset
      service.setAdsRemoved(false);
    });

    test('disposeAll is idempotent', () {
      final service = AdService();
      service.disposeAll();
      service.disposeAll(); // Second call should not throw
      expect(service.getHomeBannerAd(), isNull);
    });

    test('getHomeBannerAd returns null when adsRemoved', () {
      final service = AdService();
      service.setAdsRemoved(true);
      expect(service.getHomeBannerAd(), isNull);
      service.setAdsRemoved(false);
    });

    test('getMedicationsBannerAd returns null when adsRemoved', () {
      final service = AdService();
      service.setAdsRemoved(true);
      expect(service.getMedicationsBannerAd(), isNull);
      service.setAdsRemoved(false);
    });

    test('setAdsRemoved toggles correctly', () {
      final service = AdService();
      expect(service.adsRemoved, isFalse);
      service.setAdsRemoved(true);
      expect(service.adsRemoved, isTrue);
      service.setAdsRemoved(false);
      expect(service.adsRemoved, isFalse);
    });

    test('initialize completes without throwing (swallows platform exception)', () async {
      final service = AdService();
      // MobileAds.instance.initialize() throws in unit tests (no platform channel).
      // initialize() must swallow the error and not propagate it.
      await expectLater(service.initialize(), completes);
    });

    test('initialize called multiple times completes without throwing', () async {
      final service = AdService();
      await expectLater(service.initialize(), completes);
      await expectLater(service.initialize(), completes);
      await expectLater(service.initialize(), completes);
    });

    test('setAdsRemoved(false) when already false does not throw and state remains false', () {
      final service = AdService();
      expect(service.adsRemoved, isFalse);
      // Calling with false when already false: the if(removed) branch is skipped,
      // disposeAll() is NOT called, state remains false.
      service.setAdsRemoved(false);
      expect(service.adsRemoved, isFalse);
    });

    test('setAdsRemoved(true) then setAdsRemoved(true) again is safe', () {
      final service = AdService();
      service.setAdsRemoved(true);
      expect(service.adsRemoved, isTrue);
      // Second call with true: disposeAll() is called again on already-null ads.
      service.setAdsRemoved(true);
      expect(service.adsRemoved, isTrue);
      // Reset
      service.setAdsRemoved(false);
    });

    test('getHomeBannerAd returns null on repeated calls', () {
      final service = AdService();
      // _hideAdsForScreenshots = true guarantees null every time.
      expect(service.getHomeBannerAd(), isNull);
      expect(service.getHomeBannerAd(), isNull);
      expect(service.getHomeBannerAd(), isNull);
    });

    test('getMedicationsBannerAd returns null on repeated calls', () {
      final service = AdService();
      expect(service.getMedicationsBannerAd(), isNull);
      expect(service.getMedicationsBannerAd(), isNull);
      expect(service.getMedicationsBannerAd(), isNull);
    });

    test('disposeAll then banner getters still return null', () {
      final service = AdService();
      service.disposeAll();
      expect(service.getHomeBannerAd(), isNull);
      expect(service.getMedicationsBannerAd(), isNull);
    });

    test('setAdsRemoved(false) after setAdsRemoved(true) restores false state', () {
      final service = AdService();
      service.setAdsRemoved(true);
      expect(service.adsRemoved, isTrue);
      service.setAdsRemoved(false);
      expect(service.adsRemoved, isFalse);
      // Banner methods still return null (hideAdsForScreenshots = true).
      expect(service.getHomeBannerAd(), isNull);
      expect(service.getMedicationsBannerAd(), isNull);
    });

    test('all methods callable in sequence without error', () async {
      final service = AdService();
      await service.initialize();
      service.setAdsRemoved(false);
      expect(service.getHomeBannerAd(), isNull);
      expect(service.getMedicationsBannerAd(), isNull);
      service.disposeAll();
      service.setAdsRemoved(true);
      expect(service.adsRemoved, isTrue);
      service.setAdsRemoved(false);
    });

    test('adsRemoved getter reflects current state accurately', () {
      final service = AdService();
      // Verify getter returns live state, not a snapshot.
      service.setAdsRemoved(true);
      final snapshot = service.adsRemoved;
      service.setAdsRemoved(false);
      expect(snapshot, isTrue);
      expect(service.adsRemoved, isFalse);
    });

    test('disposeAll resets state so subsequent disposeAll is still safe', () {
      final service = AdService();
      service.disposeAll();
      service.disposeAll();
      service.disposeAll();
      // All ad references are null; getters still return null.
      expect(service.getHomeBannerAd(), isNull);
      expect(service.getMedicationsBannerAd(), isNull);
    });
  });
}
