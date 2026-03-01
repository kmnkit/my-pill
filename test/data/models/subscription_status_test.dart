import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/models/subscription_status.dart';

void main() {
  group('SubscriptionStatus', () {
    final expiresAt = DateTime.utc(2024, 12, 31);

    SubscriptionStatus buildFull() => SubscriptionStatus(
      isPremium: true,
      productId: 'com.ginger.mypill.premium.monthly',
      expiresAt: expiresAt,
      platform: SubscriptionPlatform.appStore,
    );

    SubscriptionStatus buildMinimal() => const SubscriptionStatus();

    group('fromJson/toJson', () {
      test('roundtrip preserves all fields', () {
        final original = buildFull();
        final json = original.toJson();
        final restored = SubscriptionStatus.fromJson(json);

        expect(restored.isPremium, original.isPremium);
        expect(restored.productId, original.productId);
        expect(restored.expiresAt, original.expiresAt);
        expect(restored.platform, original.platform);
      });

      test('roundtrip with null optional fields', () {
        final original = buildMinimal();
        final json = original.toJson();
        final restored = SubscriptionStatus.fromJson(json);

        expect(restored.productId, isNull);
        expect(restored.expiresAt, isNull);
      });

      test('toJson encodes platform as string', () {
        final status = buildFull();
        final json = status.toJson();

        expect(json['platform'], 'appStore');
      });

      test('toJson encodes expiresAt as ISO8601 string', () {
        final status = buildFull();
        final json = status.toJson();

        expect(json['expiresAt'], expiresAt.toIso8601String());
      });

      test('toJson encodes null expiresAt as null', () {
        final status = buildMinimal();
        final json = status.toJson();

        expect(json['expiresAt'], isNull);
      });

      test('fromJson handles all SubscriptionPlatform values', () {
        for (final platform in SubscriptionPlatform.values) {
          final json = buildFull().toJson()..['platform'] = platform.name;
          final status = SubscriptionStatus.fromJson(json);
          expect(status.platform, platform);
        }
      });

      test('roundtrip with playStore platform', () {
        final original = SubscriptionStatus(
          isPremium: true,
          productId: 'com.ginger.mypill.premium.annual',
          expiresAt: expiresAt,
          platform: SubscriptionPlatform.playStore,
        );
        final restored = SubscriptionStatus.fromJson(original.toJson());

        expect(restored.platform, SubscriptionPlatform.playStore);
        expect(restored.productId, 'com.ginger.mypill.premium.annual');
      });

      test('toJson contains all expected keys', () {
        final json = buildFull().toJson();

        expect(json.containsKey('isPremium'), isTrue);
        expect(json.containsKey('productId'), isTrue);
        expect(json.containsKey('expiresAt'), isTrue);
        expect(json.containsKey('platform'), isTrue);
      });
    });

    group('copyWith', () {
      test('copies with isPremium toggled leaves other fields unchanged', () {
        final original = buildFull();
        final copied = original.copyWith(isPremium: false);

        expect(copied.isPremium, false);
        expect(copied.productId, original.productId);
        expect(copied.expiresAt, original.expiresAt);
        expect(copied.platform, original.platform);
      });

      test('copies with modified productId', () {
        final original = buildFull();
        final copied = original.copyWith(
          productId: 'com.ginger.mypill.premium.annual',
        );

        expect(copied.productId, 'com.ginger.mypill.premium.annual');
        expect(copied.isPremium, original.isPremium);
      });

      test('copies with modified platform', () {
        final original = buildFull();
        final copied = original.copyWith(
          platform: SubscriptionPlatform.playStore,
        );

        expect(copied.platform, SubscriptionPlatform.playStore);
        expect(copied.isPremium, original.isPremium);
      });

      test('copies with null productId clears the field', () {
        final original = buildFull();
        final copied = original.copyWith(productId: null);

        expect(copied.productId, isNull);
        expect(copied.isPremium, original.isPremium);
      });

      test('copies with null expiresAt clears the field', () {
        final original = buildFull();
        final copied = original.copyWith(expiresAt: null);

        expect(copied.expiresAt, isNull);
        expect(copied.isPremium, original.isPremium);
      });

      test('copies with modified expiresAt', () {
        final original = buildFull();
        final newExpiry = DateTime.utc(2025, 12, 31);
        final copied = original.copyWith(expiresAt: newExpiry);

        expect(copied.expiresAt, newExpiry);
        expect(copied.productId, original.productId);
      });
    });

    group('equality', () {
      test('two instances with same fields are equal', () {
        final a = buildFull();
        final b = buildFull();

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('two default instances are equal', () {
        final a = buildMinimal();
        final b = buildMinimal();

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('instances with different isPremium are not equal', () {
        final a = buildFull();
        final b = a.copyWith(isPremium: false);

        expect(a, isNot(equals(b)));
      });

      test('instances with different platform are not equal', () {
        final a = buildFull();
        final b = a.copyWith(platform: SubscriptionPlatform.playStore);

        expect(a, isNot(equals(b)));
      });

      test('instances with different productId are not equal', () {
        final a = buildFull();
        final b = a.copyWith(productId: 'different.product.id');

        expect(a, isNot(equals(b)));
      });

      test('instances with different expiresAt are not equal', () {
        final a = buildFull();
        final b = a.copyWith(expiresAt: DateTime.utc(2025, 6, 30));

        expect(a, isNot(equals(b)));
      });

      test('premium and non-premium instances are not equal', () {
        final a = buildFull();
        final b = buildMinimal();

        expect(a, isNot(equals(b)));
      });
    });

    group('defaults', () {
      test('isPremium defaults to false', () {
        expect(buildMinimal().isPremium, false);
      });

      test('productId defaults to null', () {
        expect(buildMinimal().productId, isNull);
      });

      test('expiresAt defaults to null', () {
        expect(buildMinimal().expiresAt, isNull);
      });

      test('platform defaults to SubscriptionPlatform.none', () {
        expect(buildMinimal().platform, SubscriptionPlatform.none);
      });
    });

    group('SubscriptionPlatform enum', () {
      test('has none value', () {
        expect(
          SubscriptionPlatform.values,
          contains(SubscriptionPlatform.none),
        );
      });

      test('has appStore value', () {
        expect(
          SubscriptionPlatform.values,
          contains(SubscriptionPlatform.appStore),
        );
      });

      test('has playStore value', () {
        expect(
          SubscriptionPlatform.values,
          contains(SubscriptionPlatform.playStore),
        );
      });
    });
  });
}
