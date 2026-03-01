// SC-SUB-001 through SC-SUB-006
// Additional SubscriptionService tests: initialize, purchase stubs, dispose
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/services/subscription_service.dart';

void main() {
  // ---------------------------------------------------------------------------
  // SC-SUB-001: initialize sets productsLoaded=true and emits on productsLoadedStream
  // ---------------------------------------------------------------------------
  group('SubscriptionService.initialize — SC-SUB-001', () {
    test('sets productsLoaded to true and emits on productsLoadedStream',
        () async {
      final service = SubscriptionService();
      addTearDown(service.dispose);

      expect(service.productsLoaded, isFalse,
          reason: 'productsLoaded should be false before initialize');

      final emissions = <void>[];
      final sub = service.productsLoadedStream.listen((_) => emissions.add(null));

      await service.initialize();

      // Flush microtasks
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(service.productsLoaded, isTrue);
      expect(emissions, hasLength(1));
    });
  });

  // ---------------------------------------------------------------------------
  // SC-SUB-002: purchaseMonthly returns false
  // ---------------------------------------------------------------------------
  group('SubscriptionService.purchaseMonthly — SC-SUB-002', () {
    test('returns false without throwing', () async {
      final service = SubscriptionService();
      addTearDown(service.dispose);

      final result = await service.purchaseMonthly();

      expect(result, isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // SC-SUB-003: purchaseYearly returns false
  // ---------------------------------------------------------------------------
  group('SubscriptionService.purchaseYearly — SC-SUB-003', () {
    test('returns false without throwing', () async {
      final service = SubscriptionService();
      addTearDown(service.dispose);

      final result = await service.purchaseYearly();

      expect(result, isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // SC-SUB-004: restorePurchases completes without error
  // ---------------------------------------------------------------------------
  group('SubscriptionService.restorePurchases — SC-SUB-004', () {
    test('completes normally without throwing', () async {
      final service = SubscriptionService();
      addTearDown(service.dispose);

      await expectLater(service.restorePurchases(), completes);
    });
  });

  // ---------------------------------------------------------------------------
  // SC-SUB-005: dispose closes both StreamControllers
  // ---------------------------------------------------------------------------
  group('SubscriptionService.dispose — SC-SUB-005', () {
    test('closes statusStream and productsLoadedStream on dispose', () async {
      final service = SubscriptionService();

      final statusDone = <void>[];
      final productsDone = <void>[];

      service.statusStream.listen(
        (_) {},
        onDone: () => statusDone.add(null),
      );
      service.productsLoadedStream.listen(
        (_) {},
        onDone: () => productsDone.add(null),
      );

      service.dispose();

      // Allow done events to propagate
      await Future<void>.delayed(Duration.zero);

      expect(statusDone, hasLength(1), reason: 'statusStream should be closed');
      expect(productsDone, hasLength(1),
          reason: 'productsLoadedStream should be closed');
    });
  });

  // ---------------------------------------------------------------------------
  // SC-SUB-006: maxPatients returns 1 for non-premium
  // ---------------------------------------------------------------------------
  group('SubscriptionService.maxPatients — SC-SUB-006', () {
    test('returns 1 when isPremium is false (default)', () {
      final service = SubscriptionService();
      addTearDown(service.dispose);

      expect(service.isPremium, isFalse);
      expect(service.maxPatients, equals(1));
    });
  });
}
