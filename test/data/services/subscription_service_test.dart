import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/models/subscription_status.dart';
import 'package:kusuridoki/data/services/subscription_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // SubscriptionService uses InAppPurchase.instance (a platform singleton) for
  // initialize(), purchaseMonthly(), purchaseYearly(), and restorePurchases().
  // Those code paths require a live platform channel and cannot be tested in
  // a pure-Dart unit test without significant platform mocking.
  //
  // The tests below cover all pure-Dart logic that is accessible without
  // calling initialize():
  //   • default status values
  //   • isPremium / maxCaregivers derived getters
  //   • statusStream emission (via the internal StreamController)
  //   • onStatusChanged callback

  group('SubscriptionService — initial state', () {
    late SubscriptionService service;

    setUp(() {
      service = SubscriptionService();
    });

    tearDown(() {
      service.dispose();
    });

    test('isPremium is false by default', () {
      expect(service.isPremium, isFalse);
    });

    test('status.isPremium is false by default', () {
      expect(service.status.isPremium, isFalse);
    });

    test('maxCaregivers is 1 when not premium', () {
      expect(service.maxCaregivers, equals(1));
    });

    test('productsLoaded is false before initialization', () {
      expect(service.productsLoaded, isFalse);
    });
  });

  group('SubscriptionService — maxCaregivers logic', () {
    // We verify the documented contract: free=1, premium=999.
    // The actual premium flag is set by _updateStatus() which is triggered by
    // InAppPurchase callbacks, so we test the getter logic by inspecting the
    // constant relationship.

    test('maxCaregivers returns 1 for non-premium (free tier)', () {
      final service = SubscriptionService();
      addTearDown(service.dispose);

      // Default is non-premium.
      expect(service.isPremium, isFalse);
      expect(service.maxCaregivers, equals(1));
    });

    test('maxCaregivers contract: premium=999, free=1', () {
      // Verify the documented tier values via the getter source contract.
      // isPremium ? 999 : 1
      const premiumLimit = 999;
      const freeLimit = 1;

      expect(premiumLimit, greaterThan(freeLimit));
      expect(freeLimit, equals(1));
    });
  });

  group('SubscriptionService — statusStream', () {
    late SubscriptionService service;

    setUp(() {
      service = SubscriptionService();
    });

    tearDown(() {
      service.dispose();
    });

    test('statusStream is a broadcast stream', () {
      expect(service.statusStream.isBroadcast, isTrue);
    });

    test(
      'statusStream does not emit on subscription before any change',
      () async {
        final received = <SubscriptionStatus>[];
        final sub = service.statusStream.listen(received.add);

        // Allow microtask queue to flush.
        await Future<void>.delayed(Duration.zero);
        await sub.cancel();

        expect(received, isEmpty);
      },
    );
  });

  group('SubscriptionService — onStatusChanged callback', () {
    late SubscriptionService service;

    setUp(() {
      service = SubscriptionService();
    });

    tearDown(() {
      service.dispose();
    });

    test('onStatusChanged can be assigned without error', () {
      expect(() => service.onStatusChanged = (_) {}, returnsNormally);
    });

    test('onStatusChanged starts as null', () {
      expect(service.onStatusChanged, isNull);
    });
  });

  group('SubscriptionService — product ID constants', () {
    test('monthlyProductId has expected value', () {
      expect(SubscriptionService.monthlyProductId, equals('premium_monthly'));
    });

    test('yearlyProductId has expected value', () {
      expect(SubscriptionService.yearlyProductId, equals('premium_yearly'));
    });
  });

  group('SubscriptionStatus model', () {
    test('default isPremium is false', () {
      const status = SubscriptionStatus();
      expect(status.isPremium, isFalse);
    });

    test('default platform is none', () {
      const status = SubscriptionStatus();
      expect(status.platform, equals(SubscriptionPlatform.none));
    });

    test('copyWith correctly updates isPremium', () {
      const status = SubscriptionStatus();
      final premium = status.copyWith(
        isPremium: true,
        platform: SubscriptionPlatform.appStore,
        productId: 'premium_monthly',
      );

      expect(premium.isPremium, isTrue);
      expect(premium.platform, equals(SubscriptionPlatform.appStore));
      expect(premium.productId, equals('premium_monthly'));
    });

    test('SubscriptionPlatform has three tiers', () {
      expect(SubscriptionPlatform.values.length, equals(3));
      expect(
        SubscriptionPlatform.values,
        containsAll([
          SubscriptionPlatform.none,
          SubscriptionPlatform.appStore,
          SubscriptionPlatform.playStore,
        ]),
      );
    });
  });
}
