import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/models/subscription_status.dart';
import 'package:kusuridoki/data/providers/subscription_provider.dart';
import 'package:kusuridoki/data/services/subscription_service.dart';

void main() {
  group('subscriptionServiceProvider', () {
    test('provider exists and has correct name', () {
      expect(subscriptionServiceProvider.name, 'subscriptionServiceProvider');
    });

    test('can be overridden with a value', () {
      final service = SubscriptionService();
      final container = ProviderContainer(
        overrides: [subscriptionServiceProvider.overrideWithValue(service)],
      );
      addTearDown(container.dispose);

      final result = container.read(subscriptionServiceProvider);
      expect(result, isA<SubscriptionService>());
      expect(result, same(service));
    });
  });

  group('isPremium provider', () {
    test('provider exists and has correct name', () {
      expect(isPremiumProvider.name, 'isPremiumProvider');
    });

    test('returns false for stub service (no IAP)', () {
      final service = SubscriptionService();
      final container = ProviderContainer(
        overrides: [subscriptionServiceProvider.overrideWithValue(service)],
      );
      addTearDown(container.dispose);

      // kPremiumEnabled = true → reads from SubscriptionService (stub → false)
      expect(container.read(isPremiumProvider), isFalse);
    });

    test('can be overridden directly with true', () {
      final container = ProviderContainer(
        overrides: [isPremiumProvider.overrideWithValue(true)],
      );
      addTearDown(container.dispose);

      expect(container.read(isPremiumProvider), isTrue);
    });

    test('can be overridden directly with false', () {
      final container = ProviderContainer(
        overrides: [isPremiumProvider.overrideWithValue(false)],
      );
      addTearDown(container.dispose);

      expect(container.read(isPremiumProvider), isFalse);
    });
  });

  group('maxCaregivers provider', () {
    test('provider exists and has correct name', () {
      expect(maxCaregiversProvider.name, 'maxCaregiversProvider');
    });

    test('returns 1 for stub service (free tier)', () {
      final service = SubscriptionService();
      final container = ProviderContainer(
        overrides: [subscriptionServiceProvider.overrideWithValue(service)],
      );
      addTearDown(container.dispose);

      // kPremiumEnabled = true → reads from SubscriptionService (stub → 1)
      expect(container.read(maxCaregiversProvider), 1);
    });

    test('can be overridden directly with premium value', () {
      final container = ProviderContainer(
        overrides: [maxCaregiversProvider.overrideWithValue(999)],
      );
      addTearDown(container.dispose);

      expect(container.read(maxCaregiversProvider), 999);
    });
  });

  group('maxPatients provider', () {
    test('provider exists and has correct name', () {
      expect(maxPatientsProvider.name, 'maxPatientsProvider');
    });

    test('returns 1 for stub service (free tier)', () {
      final service = SubscriptionService();
      final container = ProviderContainer(
        overrides: [subscriptionServiceProvider.overrideWithValue(service)],
      );
      addTearDown(container.dispose);

      // kPremiumEnabled = true → reads from SubscriptionService (stub → 1)
      expect(container.read(maxPatientsProvider), 1);
    });

    test('can be overridden directly with premium value', () {
      final container = ProviderContainer(
        overrides: [maxPatientsProvider.overrideWithValue(999)],
      );
      addTearDown(container.dispose);

      expect(container.read(maxPatientsProvider), 999);
    });

    test('can be overridden directly with free value', () {
      final container = ProviderContainer(
        overrides: [maxPatientsProvider.overrideWithValue(1)],
      );
      addTearDown(container.dispose);

      expect(container.read(maxPatientsProvider), 1);
    });
  });

  group('subscriptionStatus provider', () {
    test('provider exists and has correct name', () {
      expect(subscriptionStatusProvider.name, 'subscriptionStatusProvider');
    });

    test('returns default status for new service', () {
      final service = SubscriptionService();
      final container = ProviderContainer(
        overrides: [subscriptionServiceProvider.overrideWithValue(service)],
      );
      addTearDown(container.dispose);

      final status = container.read(subscriptionStatusProvider);
      expect(status, isA<SubscriptionStatus>());
      expect(status.isPremium, isFalse);
      expect(status.productId, isNull);
      expect(status.expiresAt, isNull);
      expect(status.platform, SubscriptionPlatform.none);
    });

    test('can be overridden with premium status', () {
      const premiumStatus = SubscriptionStatus(
        isPremium: true,
        productId: 'premium_monthly',
        platform: SubscriptionPlatform.appStore,
      );

      final container = ProviderContainer(
        overrides: [
          subscriptionStatusProvider.overrideWithValue(premiumStatus),
        ],
      );
      addTearDown(container.dispose);

      final status = container.read(subscriptionStatusProvider);
      expect(status.isPremium, isTrue);
      expect(status.productId, 'premium_monthly');
      expect(status.platform, SubscriptionPlatform.appStore);
    });

    test('can be overridden with yearly premium status', () {
      final expiryDate = DateTime(2027, 1, 1);
      final yearlyStatus = SubscriptionStatus(
        isPremium: true,
        productId: 'premium_yearly',
        expiresAt: expiryDate,
        platform: SubscriptionPlatform.playStore,
      );

      final container = ProviderContainer(
        overrides: [subscriptionStatusProvider.overrideWithValue(yearlyStatus)],
      );
      addTearDown(container.dispose);

      final status = container.read(subscriptionStatusProvider);
      expect(status.isPremium, isTrue);
      expect(status.productId, 'premium_yearly');
      expect(status.expiresAt, expiryDate);
      expect(status.platform, SubscriptionPlatform.playStore);
    });
  });

  group('Feature flag regression — kPremiumEnabled = true', () {
    // REG-MONET-001: When kPremiumEnabled is true, isPremiumProvider reads
    // from SubscriptionService. Stub service returns false (free tier).
    test(
      'REG-MONET-001: isPremiumProvider returns false for stub service',
      () {
        final container = ProviderContainer(
          overrides: [
            subscriptionServiceProvider.overrideWithValue(SubscriptionService()),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(isPremiumProvider), isFalse);
      },
    );

    // REG-MONET-002: When kPremiumEnabled is true, caregiver and patient
    // limits come from SubscriptionService. Stub returns free-tier limits (1).
    test(
      'REG-MONET-002: maxCaregiversProvider returns 1 for stub service',
      () {
        final container = ProviderContainer(
          overrides: [
            subscriptionServiceProvider.overrideWithValue(SubscriptionService()),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(maxCaregiversProvider), 1);
      },
    );

    test(
      'REG-MONET-002: maxPatientsProvider returns 1 for stub service',
      () {
        final container = ProviderContainer(
          overrides: [
            subscriptionServiceProvider.overrideWithValue(SubscriptionService()),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(maxPatientsProvider), 1);
      },
    );
  });

  group('SubscriptionService properties', () {
    test('new service has isPremium false', () {
      final service = SubscriptionService();
      expect(service.isPremium, isFalse);
    });

    test('new service has maxCaregivers 1', () {
      final service = SubscriptionService();
      expect(service.maxCaregivers, 1);
    });

    test('new service has default status', () {
      final service = SubscriptionService();
      expect(service.status.isPremium, isFalse);
      expect(service.status.platform, SubscriptionPlatform.none);
    });

    test('onStatusChanged callback can be set', () {
      final service = SubscriptionService();
      SubscriptionStatus? receivedStatus;

      service.onStatusChanged = (status) {
        receivedStatus = status;
      };

      expect(service.onStatusChanged, isNotNull);
      // Verify the callback is callable
      service.onStatusChanged!(const SubscriptionStatus(isPremium: true));
      expect(receivedStatus, isNotNull);
      expect(receivedStatus!.isPremium, isTrue);
    });

    test('product IDs are correct', () {
      expect(SubscriptionService.monthlyProductId, 'premium_monthly');
      expect(SubscriptionService.yearlyProductId, 'premium_yearly');
    });
  });
}
