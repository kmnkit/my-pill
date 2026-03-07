import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kusuridoki/data/enums/dosage_unit.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/data/providers/storage_service_provider.dart';
import 'package:kusuridoki/data/services/storage_service.dart';

@GenerateMocks([StorageService])
import 'medication_provider_test.mocks.dart';
import '../../mock_firebase.dart';

Medication _makeMedication(String id, String name) => Medication(
  id: id,
  name: name,
  dosage: 100,
  dosageUnit: DosageUnit.mg,
  shape: PillShape.round,
  color: PillColor.white,
  createdAt: DateTime(2024, 1, 1),
);

void main() {
  late MockStorageService mockStorage;

  setUp(() {
    setupFirebaseAuthMocks();
    mockStorage = MockStorageService();
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [storageServiceProvider.overrideWithValue(mockStorage)],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('MedicationList provider', () {
    test('build returns empty list when no medications', () async {
      when(mockStorage.getAllMedications()).thenAnswer((_) async => []);

      final container = makeContainer();
      final result = await container.read(medicationListProvider.future);

      expect(result, isEmpty);
    });

    test('build returns list of medications from storage', () async {
      final meds = [
        _makeMedication('med-1', 'Aspirin'),
        _makeMedication('med-2', 'Ibuprofen'),
      ];
      when(mockStorage.getAllMedications()).thenAnswer((_) async => meds);

      final container = makeContainer();
      final result = await container.read(medicationListProvider.future);

      expect(result.length, equals(2));
      expect(result[0].name, equals('Aspirin'));
      expect(result[1].name, equals('Ibuprofen'));
    });

    test('addMedication saves medication and invalidates provider', () async {
      final med = _makeMedication('med-1', 'Aspirin');
      when(mockStorage.getAllMedications()).thenAnswer((_) async => []);
      when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

      final container = makeContainer();
      await container.read(medicationListProvider.future);

      await container.read(medicationListProvider.notifier).addMedication(med);

      verify(mockStorage.saveMedication(med)).called(1);
    });

    test(
      'updateMedication saves updated medication and invalidates provider',
      () async {
        final med = _makeMedication('med-1', 'Aspirin');
        final updated = med.copyWith(name: 'Aspirin Updated');

        when(mockStorage.getAllMedications()).thenAnswer((_) async => [med]);
        when(mockStorage.saveMedication(any)).thenAnswer((_) async {});

        final container = makeContainer();
        await container.read(medicationListProvider.future);

        await container
            .read(medicationListProvider.notifier)
            .updateMedication(updated);

        verify(mockStorage.saveMedication(updated)).called(1);
      },
    );

    test(
      'deleteMedication calls cascade delete and invalidates provider',
      () async {
        final med = _makeMedication('med-1', 'Aspirin');

        when(mockStorage.getAllMedications()).thenAnswer((_) async => [med]);
        when(mockStorage.getMedication('med-1')).thenAnswer((_) async => med);
        when(mockStorage.deletePhotoFile(any)).thenAnswer((_) async {});
        when(
          mockStorage.deleteRemindersForMedication(any),
        ).thenAnswer((_) async {});
        when(
          mockStorage.deleteAdherenceRecordsForMedication(any),
        ).thenAnswer((_) async {});
        when(
          mockStorage.getSchedulesForMedication(any),
        ).thenAnswer((_) async => []);
        when(mockStorage.deleteMedication(any)).thenAnswer((_) async {});

        final container = makeContainer();
        await container.read(medicationListProvider.future);

        await container
            .read(medicationListProvider.notifier)
            .deleteMedication('med-1');

        verify(mockStorage.deleteMedication('med-1')).called(1);
      },
    );
  });

  group('medication provider (single)', () {
    test('returns medication when found', () async {
      final med = _makeMedication('med-1', 'Aspirin');
      when(mockStorage.getMedication('med-1')).thenAnswer((_) async => med);

      final container = makeContainer();
      final result = await container.read(medicationProvider('med-1').future);

      expect(result, isNotNull);
      expect(result!.id, equals('med-1'));
      expect(result.name, equals('Aspirin'));
    });

    test('returns null when medication not found', () async {
      when(
        mockStorage.getMedication('non-existent'),
      ).thenAnswer((_) async => null);

      final container = makeContainer();
      final result = await container.read(
        medicationProvider('non-existent').future,
      );

      expect(result, isNull);
    });
  });
}
