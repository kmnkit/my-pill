import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/repositories/medication_repository.dart';
import 'package:my_pill/data/services/storage_service.dart';
import 'package:my_pill/data/models/medication.dart';
import 'package:my_pill/data/enums/pill_shape.dart';
import 'package:my_pill/data/enums/pill_color.dart';
import 'package:my_pill/data/enums/dosage_unit.dart';

// Test medication repository logic
void main() {
  group('MedicationRepository', () {
    test('isLowStock returns true when remaining <= threshold', () {
      final repo = MedicationRepository(StorageService());
      final med = Medication(
        id: 'test-1',
        name: 'Test Med',
        dosage: 100,
        dosageUnit: DosageUnit.mg,
        shape: PillShape.round,
        color: PillColor.white,
        inventoryTotal: 30,
        inventoryRemaining: 3,
        lowStockThreshold: 5,
        createdAt: DateTime.now(),
      );

      expect(repo.isLowStock(med), isTrue);
    });

    test('isLowStock returns false when remaining > threshold', () {
      final repo = MedicationRepository(StorageService());
      final med = Medication(
        id: 'test-2',
        name: 'Test Med',
        dosage: 100,
        dosageUnit: DosageUnit.mg,
        shape: PillShape.round,
        color: PillColor.white,
        inventoryTotal: 30,
        inventoryRemaining: 20,
        lowStockThreshold: 5,
        createdAt: DateTime.now(),
      );

      expect(repo.isLowStock(med), isFalse);
    });

    test('daysRemaining calculates correctly', () {
      final repo = MedicationRepository(StorageService());
      final med = Medication(
        id: 'test-3',
        name: 'Test Med',
        dosage: 100,
        dosageUnit: DosageUnit.mg,
        shape: PillShape.round,
        color: PillColor.white,
        inventoryTotal: 30,
        inventoryRemaining: 15,
        lowStockThreshold: 5,
        createdAt: DateTime.now(),
      );

      expect(repo.daysRemaining(med, dosesPerDay: 1), equals(15));
      expect(repo.daysRemaining(med, dosesPerDay: 3), equals(5));
    });

    test('daysRemaining returns 0 when dosesPerDay is 0', () {
      final repo = MedicationRepository(StorageService());
      final med = Medication(
        id: 'test-4',
        name: 'Test Med',
        dosage: 100,
        dosageUnit: DosageUnit.mg,
        shape: PillShape.round,
        color: PillColor.white,
        inventoryTotal: 30,
        inventoryRemaining: 15,
        lowStockThreshold: 5,
        createdAt: DateTime.now(),
      );

      expect(repo.daysRemaining(med, dosesPerDay: 0), equals(0));
    });

    test('isLowStock returns true when days remaining <= 3', () {
      final repo = MedicationRepository(StorageService());
      final med = Medication(
        id: 'test-5',
        name: 'Test Med',
        dosage: 100,
        dosageUnit: DosageUnit.mg,
        shape: PillShape.round,
        color: PillColor.white,
        inventoryTotal: 30,
        inventoryRemaining: 30,
        lowStockThreshold: 5,
        createdAt: DateTime.now(),
      );

      // 30 pills / 10 doses per day = 3 days remaining (triggers low stock)
      expect(repo.isLowStock(med, dosesPerDay: 10), isTrue);
    });
  });
}
