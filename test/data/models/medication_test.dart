import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/enums/dosage_unit.dart';
import 'package:my_pill/data/enums/pill_color.dart';
import 'package:my_pill/data/enums/pill_shape.dart';
import 'package:my_pill/data/models/medication.dart';

void main() {
  group('Medication', () {
    final createdAt = DateTime.utc(2024, 1, 15);
    final updatedAt = DateTime.utc(2024, 1, 20);

    Medication buildFull() => Medication(
          id: 'med-001',
          name: 'Aspirin',
          dosage: 100.0,
          dosageUnit: DosageUnit.mg,
          shape: PillShape.round,
          color: PillColor.white,
          photoPath: '/path/to/photo.png',
          scheduleId: 'sched-001',
          inventoryTotal: 60,
          inventoryRemaining: 45,
          lowStockThreshold: 10,
          isCritical: true,
          isIppoka: false,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

    Medication buildMinimal() => Medication(
          id: 'med-002',
          name: 'Vitamin C',
          dosage: 500.0,
          dosageUnit: DosageUnit.mg,
          createdAt: createdAt,
        );

    group('fromJson/toJson', () {
      test('roundtrip preserves all fields', () {
        final original = buildFull();
        final json = original.toJson();
        final restored = Medication.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.name, original.name);
        expect(restored.dosage, original.dosage);
        expect(restored.dosageUnit, original.dosageUnit);
        expect(restored.shape, original.shape);
        expect(restored.color, original.color);
        expect(restored.photoPath, original.photoPath);
        expect(restored.scheduleId, original.scheduleId);
        expect(restored.inventoryTotal, original.inventoryTotal);
        expect(restored.inventoryRemaining, original.inventoryRemaining);
        expect(restored.lowStockThreshold, original.lowStockThreshold);
        expect(restored.isCritical, original.isCritical);
        expect(restored.isIppoka, original.isIppoka);
        expect(restored.createdAt, original.createdAt);
        expect(restored.updatedAt, original.updatedAt);
      });

      test('roundtrip with null optional fields', () {
        final original = buildMinimal();
        final json = original.toJson();
        final restored = Medication.fromJson(json);

        expect(restored.photoPath, isNull);
        expect(restored.scheduleId, isNull);
        expect(restored.updatedAt, isNull);
      });

      test('toJson encodes enum values as strings', () {
        final med = buildFull();
        final json = med.toJson();

        expect(json['dosageUnit'], 'mg');
        expect(json['shape'], 'round');
        expect(json['color'], 'white');
      });

      test('toJson encodes DateTime as ISO8601 string', () {
        final med = buildFull();
        final json = med.toJson();

        expect(json['createdAt'], createdAt.toIso8601String());
        expect(json['updatedAt'], updatedAt.toIso8601String());
      });

      test('fromJson handles all DosageUnit values', () {
        for (final unit in DosageUnit.values) {
          final json = buildFull().toJson()..['dosageUnit'] = unit.name;
          final med = Medication.fromJson(json);
          expect(med.dosageUnit, unit);
        }
      });

      test('fromJson handles all PillShape values', () {
        for (final shape in PillShape.values) {
          final json = buildFull().toJson()..['shape'] = shape.name;
          final med = Medication.fromJson(json);
          expect(med.shape, shape);
        }
      });

      test('fromJson handles all PillColor values', () {
        for (final color in PillColor.values) {
          final json = buildFull().toJson()..['color'] = color.name;
          final med = Medication.fromJson(json);
          expect(med.color, color);
        }
      });
    });

    group('copyWith', () {
      test('copies with modified name leaves other fields unchanged', () {
        final original = buildFull();
        final copied = original.copyWith(name: 'Ibuprofen');

        expect(copied.name, 'Ibuprofen');
        expect(copied.id, original.id);
        expect(copied.dosage, original.dosage);
        expect(copied.dosageUnit, original.dosageUnit);
        expect(copied.shape, original.shape);
        expect(copied.color, original.color);
        expect(copied.photoPath, original.photoPath);
        expect(copied.scheduleId, original.scheduleId);
        expect(copied.inventoryTotal, original.inventoryTotal);
        expect(copied.inventoryRemaining, original.inventoryRemaining);
        expect(copied.lowStockThreshold, original.lowStockThreshold);
        expect(copied.isCritical, original.isCritical);
        expect(copied.isIppoka, original.isIppoka);
        expect(copied.createdAt, original.createdAt);
        expect(copied.updatedAt, original.updatedAt);
      });

      test('copies with modified dosage', () {
        final original = buildFull();
        final copied = original.copyWith(dosage: 200.0);

        expect(copied.dosage, 200.0);
        expect(copied.name, original.name);
      });

      test('copies with modified inventoryRemaining', () {
        final original = buildFull();
        final copied = original.copyWith(inventoryRemaining: 5);

        expect(copied.inventoryRemaining, 5);
        expect(copied.inventoryTotal, original.inventoryTotal);
      });

      test('copies with isCritical toggled', () {
        final original = buildFull();
        final copied = original.copyWith(isCritical: false);

        expect(copied.isCritical, false);
        expect(copied.isIppoka, original.isIppoka);
      });

      test('copies with null photoPath clears the field', () {
        final original = buildFull();
        final copied = original.copyWith(photoPath: null);

        expect(copied.photoPath, isNull);
        expect(copied.name, original.name);
      });

      test('copies with updated updatedAt', () {
        final original = buildMinimal();
        final newUpdatedAt = DateTime.utc(2024, 2, 1);
        final copied = original.copyWith(updatedAt: newUpdatedAt);

        expect(copied.updatedAt, newUpdatedAt);
        expect(copied.createdAt, original.createdAt);
      });
    });

    group('equality', () {
      test('two instances with same fields are equal', () {
        final a = buildFull();
        final b = buildFull();

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('instances with different id are not equal', () {
        final a = buildFull();
        final b = a.copyWith(id: 'different-id');

        expect(a, isNot(equals(b)));
      });

      test('instances with different name are not equal', () {
        final a = buildFull();
        final b = a.copyWith(name: 'Different Name');

        expect(a, isNot(equals(b)));
      });

      test('instances with different dosage are not equal', () {
        final a = buildFull();
        final b = a.copyWith(dosage: 999.0);

        expect(a, isNot(equals(b)));
      });

      test('instances with different dosageUnit are not equal', () {
        final a = buildFull();
        final b = a.copyWith(dosageUnit: DosageUnit.ml);

        expect(a, isNot(equals(b)));
      });

      test('instances with different isCritical are not equal', () {
        final a = buildFull();
        final b = a.copyWith(isCritical: false);

        expect(a, isNot(equals(b)));
      });
    });

    group('defaults', () {
      test('shape defaults to PillShape.round', () {
        expect(buildMinimal().shape, PillShape.round);
      });

      test('color defaults to PillColor.white', () {
        expect(buildMinimal().color, PillColor.white);
      });

      test('inventoryTotal defaults to 30', () {
        expect(buildMinimal().inventoryTotal, 30);
      });

      test('inventoryRemaining defaults to 30', () {
        expect(buildMinimal().inventoryRemaining, 30);
      });

      test('lowStockThreshold defaults to 5', () {
        expect(buildMinimal().lowStockThreshold, 5);
      });

      test('isCritical defaults to false', () {
        expect(buildMinimal().isCritical, false);
      });

      test('isIppoka defaults to false', () {
        expect(buildMinimal().isIppoka, false);
      });

      test('photoPath defaults to null', () {
        expect(buildMinimal().photoPath, isNull);
      });

      test('scheduleId defaults to null', () {
        expect(buildMinimal().scheduleId, isNull);
      });

      test('updatedAt defaults to null', () {
        expect(buildMinimal().updatedAt, isNull);
      });
    });
  });
}
