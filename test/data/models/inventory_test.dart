import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/models/inventory.dart';

void main() {
  group('Inventory', () {
    Inventory buildFull() => const Inventory(
          medicationId: 'med-001',
          total: 60,
          remaining: 45,
          lowStockThreshold: 10,
        );

    Inventory buildMinimal() => const Inventory(
          medicationId: 'med-002',
          total: 30,
          remaining: 30,
        );

    group('fromJson/toJson', () {
      test('roundtrip preserves all fields', () {
        final original = buildFull();
        final json = original.toJson();
        final restored = Inventory.fromJson(json);

        expect(restored.medicationId, original.medicationId);
        expect(restored.total, original.total);
        expect(restored.remaining, original.remaining);
        expect(restored.lowStockThreshold, original.lowStockThreshold);
      });

      test('roundtrip with default lowStockThreshold', () {
        final original = buildMinimal();
        final json = original.toJson();
        final restored = Inventory.fromJson(json);

        expect(restored.lowStockThreshold, 5);
      });

      test('toJson contains all expected keys', () {
        final json = buildFull().toJson();

        expect(json.containsKey('medicationId'), isTrue);
        expect(json.containsKey('total'), isTrue);
        expect(json.containsKey('remaining'), isTrue);
        expect(json.containsKey('lowStockThreshold'), isTrue);
      });

      test('roundtrip with zero remaining', () {
        const original = Inventory(
          medicationId: 'med-003',
          total: 30,
          remaining: 0,
        );
        final restored = Inventory.fromJson(original.toJson());

        expect(restored.remaining, 0);
        expect(restored.total, 30);
      });

      test('roundtrip with zero total', () {
        const original = Inventory(
          medicationId: 'med-004',
          total: 0,
          remaining: 0,
        );
        final restored = Inventory.fromJson(original.toJson());

        expect(restored.total, 0);
        expect(restored.remaining, 0);
      });
    });

    group('copyWith', () {
      test('copies with modified remaining leaves other fields unchanged', () {
        final original = buildFull();
        final copied = original.copyWith(remaining: 5);

        expect(copied.remaining, 5);
        expect(copied.medicationId, original.medicationId);
        expect(copied.total, original.total);
        expect(copied.lowStockThreshold, original.lowStockThreshold);
      });

      test('copies with modified total', () {
        final original = buildFull();
        final copied = original.copyWith(total: 90);

        expect(copied.total, 90);
        expect(copied.remaining, original.remaining);
      });

      test('copies with modified lowStockThreshold', () {
        final original = buildFull();
        final copied = original.copyWith(lowStockThreshold: 15);

        expect(copied.lowStockThreshold, 15);
        expect(copied.total, original.total);
      });

      test('copies with modified medicationId', () {
        final original = buildFull();
        final copied = original.copyWith(medicationId: 'med-999');

        expect(copied.medicationId, 'med-999');
        expect(copied.total, original.total);
      });

      test('copies with remaining set to zero', () {
        final original = buildFull();
        final copied = original.copyWith(remaining: 0);

        expect(copied.remaining, 0);
        expect(copied.total, original.total);
      });
    });

    group('equality', () {
      test('two instances with same fields are equal', () {
        final a = buildFull();
        final b = buildFull();

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('instances with different medicationId are not equal', () {
        final a = buildFull();
        final b = a.copyWith(medicationId: 'med-999');

        expect(a, isNot(equals(b)));
      });

      test('instances with different total are not equal', () {
        final a = buildFull();
        final b = a.copyWith(total: 90);

        expect(a, isNot(equals(b)));
      });

      test('instances with different remaining are not equal', () {
        final a = buildFull();
        final b = a.copyWith(remaining: 3);

        expect(a, isNot(equals(b)));
      });

      test('instances with different lowStockThreshold are not equal', () {
        final a = buildFull();
        final b = a.copyWith(lowStockThreshold: 20);

        expect(a, isNot(equals(b)));
      });
    });

    group('defaults', () {
      test('lowStockThreshold defaults to 5', () {
        expect(buildMinimal().lowStockThreshold, 5);
      });
    });

    group('isLowStock getter', () {
      test('returns true when remaining equals lowStockThreshold', () {
        const inventory = Inventory(
          medicationId: 'med-001',
          total: 30,
          remaining: 5,
          lowStockThreshold: 5,
        );

        expect(inventory.isLowStock, isTrue);
      });

      test('returns true when remaining is below lowStockThreshold', () {
        const inventory = Inventory(
          medicationId: 'med-001',
          total: 30,
          remaining: 3,
          lowStockThreshold: 5,
        );

        expect(inventory.isLowStock, isTrue);
      });

      test('returns false when remaining is above lowStockThreshold', () {
        const inventory = Inventory(
          medicationId: 'med-001',
          total: 30,
          remaining: 6,
          lowStockThreshold: 5,
        );

        expect(inventory.isLowStock, isFalse);
      });

      test('returns true when remaining is zero', () {
        const inventory = Inventory(
          medicationId: 'med-001',
          total: 30,
          remaining: 0,
          lowStockThreshold: 5,
        );

        expect(inventory.isLowStock, isTrue);
      });

      test('returns false when fully stocked with default threshold', () {
        expect(buildMinimal().isLowStock, isFalse);
      });

      test('returns true after copyWith reduces remaining to threshold', () {
        final inventory = buildFull().copyWith(remaining: 10);

        expect(inventory.isLowStock, isTrue);
      });

      test('boundary: remaining one above threshold is not low stock', () {
        const inventory = Inventory(
          medicationId: 'med-001',
          total: 100,
          remaining: 11,
          lowStockThreshold: 10,
        );

        expect(inventory.isLowStock, isFalse);
      });
    });

    group('percentage getter', () {
      test('returns correct percentage when total > 0', () {
        const inventory = Inventory(
          medicationId: 'med-001',
          total: 100,
          remaining: 75,
        );

        expect(inventory.percentage, closeTo(0.75, 0.0001));
      });

      test('returns 1.0 when fully stocked', () {
        const inventory = Inventory(
          medicationId: 'med-001',
          total: 30,
          remaining: 30,
        );

        expect(inventory.percentage, closeTo(1.0, 0.0001));
      });

      test('returns 0.0 when remaining is zero', () {
        const inventory = Inventory(
          medicationId: 'med-001',
          total: 30,
          remaining: 0,
        );

        expect(inventory.percentage, closeTo(0.0, 0.0001));
      });

      test('returns 0 when total is zero', () {
        const inventory = Inventory(
          medicationId: 'med-001',
          total: 0,
          remaining: 0,
        );

        expect(inventory.percentage, 0);
      });

      test('returns 0.5 when half remaining', () {
        const inventory = Inventory(
          medicationId: 'med-001',
          total: 60,
          remaining: 30,
        );

        expect(inventory.percentage, closeTo(0.5, 0.0001));
      });

      test('calculates correctly for non-round numbers', () {
        const inventory = Inventory(
          medicationId: 'med-001',
          total: 60,
          remaining: 45,
          lowStockThreshold: 10,
        );

        expect(inventory.percentage, closeTo(0.75, 0.0001));
      });
    });

    group('isLowStock and percentage combined', () {
      test('low stock inventory has low percentage', () {
        const inventory = Inventory(
          medicationId: 'med-001',
          total: 30,
          remaining: 3,
          lowStockThreshold: 5,
        );

        expect(inventory.isLowStock, isTrue);
        expect(inventory.percentage, closeTo(0.1, 0.0001));
      });

      test('empty inventory is low stock with 0 percentage', () {
        const inventory = Inventory(
          medicationId: 'med-001',
          total: 30,
          remaining: 0,
        );

        expect(inventory.isLowStock, isTrue);
        expect(inventory.percentage, 0.0);
      });
    });
  });
}
