import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/dosage_unit.dart';

void main() {
  group('DosageUnit', () {
    test('has exactly 5 values', () {
      expect(DosageUnit.values.length, 5);
    });

    group('enum names', () {
      test('mg has correct name', () {
        expect(DosageUnit.mg.name, 'mg');
      });

      test('ml has correct name', () {
        expect(DosageUnit.ml.name, 'ml');
      });

      test('pills has correct name', () {
        expect(DosageUnit.pills.name, 'pills');
      });

      test('units has correct name', () {
        expect(DosageUnit.units.name, 'units');
      });

      test('packs has correct name', () {
        expect(DosageUnit.packs.name, 'packs');
      });
    });

    group('label metadata', () {
      test('mg label is mg', () {
        expect(DosageUnit.mg.label, 'mg');
      });

      test('ml label is ml', () {
        expect(DosageUnit.ml.label, 'ml');
      });

      test('pills label is pills', () {
        expect(DosageUnit.pills.label, 'pills');
      });

      test('units label is units', () {
        expect(DosageUnit.units.label, 'units');
      });

      test('packs label is packs', () {
        expect(DosageUnit.packs.label, 'packs');
      });
    });

    group('label matches name', () {
      test('every DosageUnit label equals its enum name', () {
        for (final unit in DosageUnit.values) {
          expect(
            unit.label,
            unit.name,
            reason: '${unit.name} label should equal its enum name',
          );
        }
      });
    });

    group('all values have non-empty labels', () {
      test('every value has a non-empty label', () {
        for (final unit in DosageUnit.values) {
          expect(
            unit.label,
            isNotEmpty,
            reason: '${unit.name} should have a non-empty label',
          );
        }
      });
    });
  });
}
