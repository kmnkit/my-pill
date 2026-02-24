import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_pill/data/enums/dosage_unit.dart';
import 'package:my_pill/data/enums/pill_color.dart';
import 'package:my_pill/data/enums/pill_shape.dart';
import 'package:my_pill/data/enums/schedule_type.dart';
import 'package:my_pill/data/models/medication.dart';
import 'package:my_pill/data/models/schedule.dart';
import 'package:my_pill/data/repositories/medication_repository.dart';

// Reuse mock from the extended test file
import 'medication_repository_extended_test.mocks.dart';

Medication _buildMed({
  String id = 'med-001',
  String name = 'Aspirin',
  int inventoryRemaining = 20,
  int lowStockThreshold = 5,
  String? photoPath,
}) =>
    Medication(
      id: id,
      name: name,
      dosage: 100,
      dosageUnit: DosageUnit.mg,
      shape: PillShape.round,
      color: PillColor.white,
      inventoryTotal: 30,
      inventoryRemaining: inventoryRemaining,
      lowStockThreshold: lowStockThreshold,
      photoPath: photoPath,
      createdAt: DateTime.utc(2024, 1, 1),
    );

void main() {
  late MockStorageService mockStorage;
  late MedicationRepository repo;

  setUp(() {
    mockStorage = MockStorageService();
    repo = MedicationRepository(mockStorage);
  });

  group('MedicationRepository — additional coverage', () {
    // ─── createMedication — preserves all fields ──────────────────────────

    group('createMedication() — field preservation', () {
      test('preserves inventory fields', () async {
        final input = _buildMed(
          inventoryRemaining: 15,
          lowStockThreshold: 10,
        );
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        final result = await repo.createMedication(input);

        expect(result.inventoryRemaining, 15);
        expect(result.lowStockThreshold, 10);
        expect(result.inventoryTotal, 30);
      });

      test('preserves shape and color', () async {
        final input = Medication(
          id: 'placeholder',
          name: 'Custom',
          dosage: 50,
          dosageUnit: DosageUnit.ml,
          shape: PillShape.capsule,
          color: PillColor.blue,
          createdAt: DateTime.utc(2024, 1, 1),
        );
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        final result = await repo.createMedication(input);

        expect(result.shape, PillShape.capsule);
        expect(result.color, PillColor.blue);
        expect(result.dosageUnit, DosageUnit.ml);
      });

      test('preserves photoPath when set', () async {
        final input = _buildMed(photoPath: '/photos/med.jpg');
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        final result = await repo.createMedication(input);

        expect(result.photoPath, '/photos/med.jpg');
      });
    });

    // ─── updateMedication — edge cases ────────────────────────────────────

    group('updateMedication() — edge cases', () {
      test('deletes old photo when photo removed (new path is null)',
          () async {
        final existing = _buildMed(id: 'med-001', photoPath: '/old.jpg');
        final updated = _buildMed(id: 'med-001', photoPath: null);
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => existing);
        when(mockStorage.deletePhotoFile(any)).thenAnswer((_) async {});
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        await repo.updateMedication(updated);

        verify(mockStorage.deletePhotoFile('/old.jpg')).called(1);
      });

      test('preserves other fields when only name changes', () async {
        final existing = _buildMed(
          id: 'med-001',
          name: 'Original',
          inventoryRemaining: 25,
        );
        final updated = _buildMed(
          id: 'med-001',
          name: 'Renamed',
          inventoryRemaining: 25,
        );
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => existing);
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        await repo.updateMedication(updated);

        final captured =
            verify(mockStorage.saveMedication(captureAny)).captured.single
                as Medication;
        expect(captured.name, 'Renamed');
        expect(captured.inventoryRemaining, 25);
      });
    });

    // ─── deleteMedication — edge cases ────────────────────────────────────

    group('deleteMedication() — edge cases', () {
      test('handles medication with no photo and no schedules', () async {
        final med = _buildMed(id: 'med-001', photoPath: null);
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => med);
        when(mockStorage.deletePhotoFile(any)).thenAnswer((_) async {});
        when(mockStorage.deleteRemindersForMedication('med-001'))
            .thenAnswer((_) async {});
        when(mockStorage.deleteAdherenceRecordsForMedication('med-001'))
            .thenAnswer((_) async {});
        when(mockStorage.getSchedulesForMedication('med-001'))
            .thenAnswer((_) async => []);
        when(mockStorage.deleteMedication('med-001'))
            .thenAnswer((_) async {});

        await repo.deleteMedication('med-001');

        verify(mockStorage.deleteMedication('med-001')).called(1);
        verify(mockStorage.deleteRemindersForMedication('med-001')).called(1);
        verify(mockStorage.deleteAdherenceRecordsForMedication('med-001'))
            .called(1);
        // photo deletion should be called with null (which is safe)
        verify(mockStorage.deletePhotoFile(null)).called(1);
      });

      test('deletes multiple schedules correctly', () async {
        final med = _buildMed(id: 'med-001');
        final schedules = List.generate(
          3,
          (i) => Schedule(
            id: 'sched-$i',
            medicationId: 'med-001',
            type: ScheduleType.daily,
            times: const ['08:00'],
          ),
        );

        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => med);
        when(mockStorage.deletePhotoFile(any)).thenAnswer((_) async {});
        when(mockStorage.deleteRemindersForMedication('med-001'))
            .thenAnswer((_) async {});
        when(mockStorage.deleteAdherenceRecordsForMedication('med-001'))
            .thenAnswer((_) async {});
        when(mockStorage.getSchedulesForMedication('med-001'))
            .thenAnswer((_) async => schedules);
        when(mockStorage.deleteSchedule(any)).thenAnswer((_) async {});
        when(mockStorage.deleteMedication('med-001'))
            .thenAnswer((_) async {});

        await repo.deleteMedication('med-001');

        verify(mockStorage.deleteSchedule('sched-0')).called(1);
        verify(mockStorage.deleteSchedule('sched-1')).called(1);
        verify(mockStorage.deleteSchedule('sched-2')).called(1);
      });
    });

    // ─── searchMedications — additional cases ─────────────────────────────

    group('searchMedications() — additional cases', () {
      test('returns empty list when storage is empty', () async {
        when(mockStorage.getAllMedications()).thenAnswer((_) async => []);

        final result = await repo.searchMedications('anything');

        expect(result, isEmpty);
      });

      test('returns all medications when query is empty string', () async {
        final meds = [
          _buildMed(id: 'a', name: 'Aspirin'),
          _buildMed(id: 'b', name: 'Ibuprofen'),
        ];
        when(mockStorage.getAllMedications()).thenAnswer((_) async => meds);

        final result = await repo.searchMedications('');

        // empty string is contained in every string
        expect(result, hasLength(2));
      });

      test('handles special characters in search query', () async {
        final meds = [
          _buildMed(id: 'a', name: 'Aspirin (100mg)'),
        ];
        when(mockStorage.getAllMedications()).thenAnswer((_) async => meds);

        final result = await repo.searchMedications('(100mg)');

        expect(result, hasLength(1));
      });
    });

    // ─── getLowStockMedications — additional cases ────────────────────────

    group('getLowStockMedications() — additional cases', () {
      test('returns empty list when no medications exist', () async {
        when(mockStorage.getAllMedications()).thenAnswer((_) async => []);

        final result = await repo.getLowStockMedications();

        expect(result, isEmpty);
      });

      test('returns multiple low stock medications', () async {
        final meds = [
          _buildMed(
              id: 'low1', inventoryRemaining: 2, lowStockThreshold: 5),
          _buildMed(
              id: 'low2', inventoryRemaining: 4, lowStockThreshold: 5),
          _buildMed(
              id: 'ok', inventoryRemaining: 20, lowStockThreshold: 5),
        ];
        when(mockStorage.getAllMedications()).thenAnswer((_) async => meds);

        final result = await repo.getLowStockMedications();

        expect(result, hasLength(2));
        expect(result.map((m) => m.id), containsAll(['low1', 'low2']));
      });

      test('medication at threshold boundary is low stock', () async {
        final meds = [
          _buildMed(inventoryRemaining: 5, lowStockThreshold: 5),
        ];
        when(mockStorage.getAllMedications()).thenAnswer((_) async => meds);

        final result = await repo.getLowStockMedications();

        expect(result, hasLength(1));
      });
    });

    // ─── updateInventory — additional cases ───────────────────────────────

    group('updateInventory() — additional cases', () {
      test('can set inventory to a very large number', () async {
        final med = _buildMed(id: 'med-001', inventoryRemaining: 5);
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => med);
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        final result = await repo.updateInventory('med-001', 999);

        expect(result.inventoryRemaining, 999);
      });

      test('preserves medication name after inventory update', () async {
        final med = _buildMed(id: 'med-001', name: 'KeepMyName');
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => med);
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        final result = await repo.updateInventory('med-001', 50);

        expect(result.name, 'KeepMyName');
        expect(result.inventoryRemaining, 50);
      });
    });

    // ─── deductInventory — additional cases ───────────────────────────────

    group('deductInventory() — additional cases', () {
      test('deduction from 1 to 0 succeeds', () async {
        final med = _buildMed(id: 'med-001', inventoryRemaining: 1);
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => med);
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        final result = await repo.deductInventory('med-001');

        expect(result.inventoryRemaining, 0);
      });

      test('preserves medication fields after deduction', () async {
        final med = _buildMed(
          id: 'med-001',
          name: 'Ibuprofen',
          inventoryRemaining: 10,
          lowStockThreshold: 3,
        );
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => med);
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        final result = await repo.deductInventory('med-001');

        expect(result.name, 'Ibuprofen');
        expect(result.lowStockThreshold, 3);
        expect(result.inventoryRemaining, 9);
      });
    });

    // ─── isLowStock — comprehensive boundary cases ────────────────────────

    group('isLowStock() — comprehensive', () {
      test('returns true when remaining is 0', () {
        final med = _buildMed(
            inventoryRemaining: 0, lowStockThreshold: 0);

        // 0 pills / 1 dose = 0 days <= 3
        expect(repo.isLowStock(med), isTrue);
      });

      test('returns false when well-stocked with high doses per day', () {
        final med = _buildMed(
            inventoryRemaining: 100, lowStockThreshold: 5);

        // 100 / 2 = 50 days > 3, remaining > threshold
        expect(repo.isLowStock(med, dosesPerDay: 2), isFalse);
      });

      test('threshold check takes priority even with many days remaining',
          () {
        final med = _buildMed(
            inventoryRemaining: 3, lowStockThreshold: 5);

        // remaining (3) <= threshold (5) → true regardless of days
        expect(repo.isLowStock(med, dosesPerDay: 1), isTrue);
      });
    });

    // ─── daysRemaining — comprehensive ────────────────────────────────────

    group('daysRemaining() — comprehensive', () {
      test('returns 0 for negative dosesPerDay', () {
        final med = _buildMed(inventoryRemaining: 10);

        expect(repo.daysRemaining(med, dosesPerDay: -1), 0);
      });

      test('exact division returns exact days', () {
        final med = _buildMed(inventoryRemaining: 10);

        // 10 / 2 = 5
        expect(repo.daysRemaining(med, dosesPerDay: 2), 5);
      });

      test('handles single dose per day', () {
        final med = _buildMed(inventoryRemaining: 1);

        expect(repo.daysRemaining(med, dosesPerDay: 1), 1);
      });
    });
  });
}
