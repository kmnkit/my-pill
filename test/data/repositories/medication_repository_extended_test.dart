import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_pill/data/enums/dosage_unit.dart';
import 'package:my_pill/data/enums/pill_color.dart';
import 'package:my_pill/data/enums/pill_shape.dart';
import 'package:my_pill/data/enums/schedule_type.dart';
import 'package:my_pill/data/models/medication.dart';
import 'package:my_pill/data/models/schedule.dart';
import 'package:my_pill/data/repositories/medication_repository.dart';
import 'package:my_pill/data/services/storage_service.dart';

@GenerateMocks([StorageService])
import 'medication_repository_extended_test.mocks.dart';

Medication buildMedication({
  String id = 'med-001',
  String name = 'Aspirin',
  double dosage = 100,
  DosageUnit dosageUnit = DosageUnit.mg,
  int inventoryTotal = 30,
  int inventoryRemaining = 20,
  int lowStockThreshold = 5,
  String? photoPath,
  bool isCritical = false,
}) =>
    Medication(
      id: id,
      name: name,
      dosage: dosage,
      dosageUnit: dosageUnit,
      shape: PillShape.round,
      color: PillColor.white,
      inventoryTotal: inventoryTotal,
      inventoryRemaining: inventoryRemaining,
      lowStockThreshold: lowStockThreshold,
      photoPath: photoPath,
      isCritical: isCritical,
      createdAt: DateTime.utc(2024, 1, 1),
    );

void main() {
  late MockStorageService mockStorage;
  late MedicationRepository repo;

  setUp(() {
    mockStorage = MockStorageService();
    repo = MedicationRepository(mockStorage);
  });

  group('MedicationRepository extended', () {
    group('createMedication()', () {
      test('generates a new UUID for the medication id', () async {
        final input = buildMedication(id: 'placeholder');
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        final result = await repo.createMedication(input);

        expect(result.id, isNot(equals('placeholder')));
        expect(result.id.length, greaterThan(0));
      });

      test('sets createdAt timestamp', () async {
        final before = DateTime.now().subtract(const Duration(seconds: 1));
        final input = buildMedication();
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        final result = await repo.createMedication(input);

        expect(result.createdAt.isAfter(before), isTrue);
      });

      test('sets updatedAt timestamp equal to createdAt', () async {
        final input = buildMedication();
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        final result = await repo.createMedication(input);

        expect(result.updatedAt, isNotNull);
        expect(
          result.updatedAt!.difference(result.createdAt).inMilliseconds.abs(),
          lessThan(100),
        );
      });

      test('saves medication via storage', () async {
        final input = buildMedication();
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        await repo.createMedication(input);

        verify(mockStorage.saveMedication(any)).called(1);
      });

      test('preserves medication name and dosage', () async {
        final input = buildMedication(name: 'Ibuprofen', dosage: 200);
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        final result = await repo.createMedication(input);

        expect(result.name, 'Ibuprofen');
        expect(result.dosage, 200);
      });
    });

    group('getAllMedications()', () {
      test('returns empty list when no medications stored', () async {
        when(mockStorage.getAllMedications()).thenAnswer((_) async => []);

        final result = await repo.getAllMedications();

        expect(result, isEmpty);
      });

      test('returns all medications from storage', () async {
        final meds = [buildMedication(id: 'a'), buildMedication(id: 'b')];
        when(mockStorage.getAllMedications()).thenAnswer((_) async => meds);

        final result = await repo.getAllMedications();

        expect(result, hasLength(2));
        expect(result.map((m) => m.id), containsAll(['a', 'b']));
      });
    });

    group('getMedication()', () {
      test('returns medication when found', () async {
        final med = buildMedication(id: 'med-001');
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => med);

        final result = await repo.getMedication('med-001');

        expect(result, isNotNull);
        expect(result!.id, 'med-001');
      });

      test('returns null when not found', () async {
        when(mockStorage.getMedication('missing'))
            .thenAnswer((_) async => null);

        final result = await repo.getMedication('missing');

        expect(result, isNull);
      });
    });

    group('updateMedication()', () {
      test('saves updated medication with new updatedAt timestamp', () async {
        final existing = buildMedication(id: 'med-001');
        final updated = buildMedication(id: 'med-001', name: 'Updated Name');
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => existing);
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        await repo.updateMedication(updated);

        final captured =
            verify(mockStorage.saveMedication(captureAny)).captured.single
                as Medication;
        expect(captured.name, 'Updated Name');
        expect(captured.updatedAt, isNotNull);
      });

      test('does not delete photo when photo path unchanged', () async {
        final existing = buildMedication(id: 'med-001', photoPath: '/photo.jpg');
        final updated = buildMedication(id: 'med-001', photoPath: '/photo.jpg');
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => existing);
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        await repo.updateMedication(updated);

        verifyNever(mockStorage.deletePhotoFile(any));
      });

      test('deletes old photo when photo path changed', () async {
        final existing =
            buildMedication(id: 'med-001', photoPath: '/old.jpg');
        final updated =
            buildMedication(id: 'med-001', photoPath: '/new.jpg');
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => existing);
        when(mockStorage.deletePhotoFile(any)).thenAnswer((_) async {});
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        await repo.updateMedication(updated);

        verify(mockStorage.deletePhotoFile('/old.jpg')).called(1);
      });

      test('does not delete photo when existing has no photo', () async {
        final existing = buildMedication(id: 'med-001', photoPath: null);
        final updated =
            buildMedication(id: 'med-001', photoPath: '/new.jpg');
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => existing);
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        await repo.updateMedication(updated);

        verifyNever(mockStorage.deletePhotoFile(any));
      });

      test('does not delete photo when medication does not exist in storage',
          () async {
        final updated = buildMedication(id: 'med-new');
        when(mockStorage.getMedication('med-new'))
            .thenAnswer((_) async => null);
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        await repo.updateMedication(updated);

        verifyNever(mockStorage.deletePhotoFile(any));
      });
    });

    group('deleteMedication()', () {
      test('deletes medication and related data', () async {
        final med = buildMedication(id: 'med-001');
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
      });

      test('deletes each associated schedule', () async {
        final med = buildMedication(id: 'med-001');
        const schedule1 = Schedule(
          id: 'sched-1',
          medicationId: 'med-001',
          type: ScheduleType.daily,
        );
        const schedule2 = Schedule(
          id: 'sched-2',
          medicationId: 'med-001',
          type: ScheduleType.daily,
        );
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => med);
        when(mockStorage.deletePhotoFile(any)).thenAnswer((_) async {});
        when(mockStorage.deleteRemindersForMedication('med-001'))
            .thenAnswer((_) async {});
        when(mockStorage.deleteAdherenceRecordsForMedication('med-001'))
            .thenAnswer((_) async {});
        when(mockStorage.getSchedulesForMedication('med-001'))
            .thenAnswer((_) async => [schedule1, schedule2]);
        when(mockStorage.deleteSchedule(any)).thenAnswer((_) async {});
        when(mockStorage.deleteMedication('med-001'))
            .thenAnswer((_) async {});

        await repo.deleteMedication('med-001');

        verify(mockStorage.deleteSchedule('sched-1')).called(1);
        verify(mockStorage.deleteSchedule('sched-2')).called(1);
      });

      test('deletes photo when medication has photoPath', () async {
        final med = buildMedication(id: 'med-001', photoPath: '/photo.jpg');
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => med);
        when(mockStorage.deletePhotoFile('/photo.jpg'))
            .thenAnswer((_) async {});
        when(mockStorage.deleteRemindersForMedication('med-001'))
            .thenAnswer((_) async {});
        when(mockStorage.deleteAdherenceRecordsForMedication('med-001'))
            .thenAnswer((_) async {});
        when(mockStorage.getSchedulesForMedication('med-001'))
            .thenAnswer((_) async => []);
        when(mockStorage.deleteMedication('med-001'))
            .thenAnswer((_) async {});

        await repo.deleteMedication('med-001');

        verify(mockStorage.deletePhotoFile('/photo.jpg')).called(1);
      });

      test('skips photo deletion when medication not found', () async {
        when(mockStorage.getMedication('missing'))
            .thenAnswer((_) async => null);
        when(mockStorage.deleteRemindersForMedication('missing'))
            .thenAnswer((_) async {});
        when(mockStorage.deleteAdherenceRecordsForMedication('missing'))
            .thenAnswer((_) async {});
        when(mockStorage.getSchedulesForMedication('missing'))
            .thenAnswer((_) async => []);
        when(mockStorage.deleteMedication('missing'))
            .thenAnswer((_) async {});

        await repo.deleteMedication('missing');

        verifyNever(mockStorage.deletePhotoFile(any));
      });
    });

    group('searchMedications()', () {
      test('returns medications matching query (case-insensitive)', () async {
        final meds = [
          buildMedication(id: 'a', name: 'Aspirin'),
          buildMedication(id: 'b', name: 'Ibuprofen'),
          buildMedication(id: 'c', name: 'Aspirin Plus'),
        ];
        when(mockStorage.getAllMedications()).thenAnswer((_) async => meds);

        final result = await repo.searchMedications('aspirin');

        expect(result, hasLength(2));
        expect(result.map((m) => m.id), containsAll(['a', 'c']));
      });

      test('returns empty list when no match', () async {
        final meds = [buildMedication(name: 'Aspirin')];
        when(mockStorage.getAllMedications()).thenAnswer((_) async => meds);

        final result = await repo.searchMedications('Paracetamol');

        expect(result, isEmpty);
      });

      test('is case-insensitive for uppercase query', () async {
        final meds = [buildMedication(name: 'ibuprofen')];
        when(mockStorage.getAllMedications()).thenAnswer((_) async => meds);

        final result = await repo.searchMedications('IBUPROFEN');

        expect(result, hasLength(1));
      });

      test('matches partial substrings', () async {
        final meds = [buildMedication(name: 'Aspirin Cardio 100mg')];
        when(mockStorage.getAllMedications()).thenAnswer((_) async => meds);

        final result = await repo.searchMedications('cardio');

        expect(result, hasLength(1));
      });

      test('returns all medications when query matches all names', () async {
        final meds = [
          buildMedication(id: 'a', name: 'Aspirin'),
          buildMedication(id: 'b', name: 'Aspirin Plus'),
        ];
        when(mockStorage.getAllMedications()).thenAnswer((_) async => meds);

        final result = await repo.searchMedications('asp');

        expect(result, hasLength(2));
      });
    });

    group('getLowStockMedications()', () {
      test('returns only medications below threshold', () async {
        final meds = [
          buildMedication(
              id: 'low', inventoryRemaining: 3, lowStockThreshold: 5),
          buildMedication(
              id: 'ok', inventoryRemaining: 20, lowStockThreshold: 5),
        ];
        when(mockStorage.getAllMedications()).thenAnswer((_) async => meds);

        final result = await repo.getLowStockMedications();

        expect(result, hasLength(1));
        expect(result.first.id, 'low');
      });

      test('returns empty list when all medications are well-stocked', () async {
        final meds = [
          buildMedication(inventoryRemaining: 30, lowStockThreshold: 5),
        ];
        when(mockStorage.getAllMedications()).thenAnswer((_) async => meds);

        final result = await repo.getLowStockMedications();

        expect(result, isEmpty);
      });
    });

    group('deductInventory()', () {
      test('decrements inventoryRemaining by 1', () async {
        final med = buildMedication(id: 'med-001', inventoryRemaining: 10);
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => med);
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        final result = await repo.deductInventory('med-001');

        expect(result.inventoryRemaining, 9);
      });

      test('saves updated medication after deduction', () async {
        final med = buildMedication(id: 'med-001', inventoryRemaining: 10);
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => med);
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        await repo.deductInventory('med-001');

        final captured =
            verify(mockStorage.saveMedication(captureAny)).captured.single
                as Medication;
        expect(captured.inventoryRemaining, 9);
      });

      test('throws when medication not found', () async {
        when(mockStorage.getMedication('missing'))
            .thenAnswer((_) async => null);

        expect(
          () => repo.deductInventory('missing'),
          throwsA(isA<Exception>()),
        );
      });

      test('throws when inventory is already zero', () async {
        final med = buildMedication(id: 'med-001', inventoryRemaining: 0);
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => med);

        expect(
          () => repo.deductInventory('med-001'),
          throwsA(isA<Exception>()),
        );
      });

      test('sets updatedAt on returned medication', () async {
        final before = DateTime.now().subtract(const Duration(seconds: 1));
        final med = buildMedication(id: 'med-001', inventoryRemaining: 5);
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => med);
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        final result = await repo.deductInventory('med-001');

        expect(result.updatedAt, isNotNull);
        expect(result.updatedAt!.isAfter(before), isTrue);
      });

      test('deduction to exactly threshold triggers low stock check without error',
          () async {
        // inventoryRemaining will be 5 after deduction = threshold → isLowStock
        final med = buildMedication(
            id: 'med-001', inventoryRemaining: 6, lowStockThreshold: 5);
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => med);
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        // Should complete without exception even if notification fails
        final result = await repo.deductInventory('med-001');
        expect(result.inventoryRemaining, 5);
      });
    });

    group('updateInventory()', () {
      test('sets inventoryRemaining to the new value', () async {
        final med = buildMedication(id: 'med-001', inventoryRemaining: 5);
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => med);
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        final result = await repo.updateInventory('med-001', 30);

        expect(result.inventoryRemaining, 30);
      });

      test('saves updated medication via storage', () async {
        final med = buildMedication(id: 'med-001', inventoryRemaining: 5);
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => med);
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        await repo.updateInventory('med-001', 30);

        final captured =
            verify(mockStorage.saveMedication(captureAny)).captured.single
                as Medication;
        expect(captured.inventoryRemaining, 30);
      });

      test('throws when medication not found', () async {
        when(mockStorage.getMedication('missing'))
            .thenAnswer((_) async => null);

        expect(
          () => repo.updateInventory('missing', 30),
          throwsA(isA<Exception>()),
        );
      });

      test('sets updatedAt on returned medication', () async {
        final before = DateTime.now().subtract(const Duration(seconds: 1));
        final med = buildMedication(id: 'med-001', inventoryRemaining: 5);
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => med);
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        final result = await repo.updateInventory('med-001', 30);

        expect(result.updatedAt, isNotNull);
        expect(result.updatedAt!.isAfter(before), isTrue);
      });

      test('allows setting inventory to zero', () async {
        final med = buildMedication(id: 'med-001', inventoryRemaining: 10);
        when(mockStorage.getMedication('med-001'))
            .thenAnswer((_) async => med);
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        final result = await repo.updateInventory('med-001', 0);

        expect(result.inventoryRemaining, 0);
      });
    });

    group('isLowStock() — boundary cases', () {
      test('returns true when remaining equals threshold', () {
        final med = buildMedication(
            inventoryRemaining: 5, lowStockThreshold: 5);

        expect(repo.isLowStock(med), isTrue);
      });

      test('returns false when remaining is one above threshold', () {
        final med = buildMedication(
            inventoryRemaining: 6, lowStockThreshold: 5);

        expect(repo.isLowStock(med), isFalse);
      });

      test('returns true when days remaining is exactly 3', () {
        final med = buildMedication(
            inventoryRemaining: 3, lowStockThreshold: 0);

        // 3 pills / 1 dose/day = 3 days (triggers low stock)
        expect(repo.isLowStock(med, dosesPerDay: 1), isTrue);
      });

      test('returns false when days remaining is 4', () {
        final med = buildMedication(
            inventoryRemaining: 4, lowStockThreshold: 0);

        // 4 pills / 1 dose/day = 4 days (above 3 threshold)
        expect(repo.isLowStock(med, dosesPerDay: 1), isFalse);
      });
    });

    group('daysRemaining() — edge cases', () {
      test('truncates fractional days', () {
        final med = buildMedication(inventoryRemaining: 7);

        // 7 / 3 = 2.33 → floor → 2
        expect(repo.daysRemaining(med, dosesPerDay: 3), 2);
      });

      test('returns 0 when inventoryRemaining is 0', () {
        final med = buildMedication(inventoryRemaining: 0);

        expect(repo.daysRemaining(med, dosesPerDay: 1), 0);
      });

      test('handles large inventory gracefully', () {
        final med = buildMedication(inventoryRemaining: 365);

        expect(repo.daysRemaining(med, dosesPerDay: 1), 365);
      });
    });
  });
}
