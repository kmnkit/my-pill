import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kusuridoki/data/enums/dosage_unit.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/data/enums/reminder_status.dart';
import 'package:kusuridoki/data/models/adherence_record.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/data/providers/adherence_provider.dart';
import 'package:kusuridoki/data/providers/storage_service_provider.dart';
import 'package:kusuridoki/data/services/storage_service.dart';

@GenerateMocks([StorageService])
import 'adherence_provider_test.mocks.dart';

AdherenceRecord _makeRecord({
  required String id,
  required String medicationId,
  required ReminderStatus status,
  DateTime? date,
}) => AdherenceRecord(
  id: id,
  medicationId: medicationId,
  date: date ?? DateTime.now(),
  status: status,
  scheduledTime: date ?? DateTime.now(),
);

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
    mockStorage = MockStorageService();
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [storageServiceProvider.overrideWithValue(mockStorage)],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('overallAdherence provider', () {
    test('returns null when no adherence records exist', () async {
      when(
        mockStorage.getAdherenceRecords(
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
          medicationId: anyNamed('medicationId'),
        ),
      ).thenAnswer((_) async => []);

      final container = makeContainer();
      final result = await container.read(overallAdherenceProvider.future);

      expect(result, isNull);
    });

    test('returns 1.0 when all records are taken', () async {
      final records = [
        _makeRecord(
          id: 'r1',
          medicationId: 'med-1',
          status: ReminderStatus.taken,
        ),
        _makeRecord(
          id: 'r2',
          medicationId: 'med-1',
          status: ReminderStatus.taken,
        ),
        _makeRecord(
          id: 'r3',
          medicationId: 'med-2',
          status: ReminderStatus.taken,
        ),
      ];
      when(
        mockStorage.getAdherenceRecords(
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
          medicationId: anyNamed('medicationId'),
        ),
      ).thenAnswer((_) async => records);

      final container = makeContainer();
      final result = await container.read(overallAdherenceProvider.future);

      expect(result, closeTo(1.0, 0.001));
    });

    test('returns 0.0 when all records are missed', () async {
      final records = [
        _makeRecord(
          id: 'r1',
          medicationId: 'med-1',
          status: ReminderStatus.missed,
        ),
        _makeRecord(
          id: 'r2',
          medicationId: 'med-1',
          status: ReminderStatus.missed,
        ),
      ];
      when(
        mockStorage.getAdherenceRecords(
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
          medicationId: anyNamed('medicationId'),
        ),
      ).thenAnswer((_) async => records);

      final container = makeContainer();
      final result = await container.read(overallAdherenceProvider.future);

      expect(result, closeTo(0.0, 0.001));
    });

    test('returns correct ratio with mixed taken and missed', () async {
      final records = [
        _makeRecord(
          id: 'r1',
          medicationId: 'med-1',
          status: ReminderStatus.taken,
        ),
        _makeRecord(
          id: 'r2',
          medicationId: 'med-1',
          status: ReminderStatus.taken,
        ),
        _makeRecord(
          id: 'r3',
          medicationId: 'med-1',
          status: ReminderStatus.missed,
        ),
        _makeRecord(
          id: 'r4',
          medicationId: 'med-1',
          status: ReminderStatus.missed,
        ),
      ];
      when(
        mockStorage.getAdherenceRecords(
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
          medicationId: anyNamed('medicationId'),
        ),
      ).thenAnswer((_) async => records);

      final container = makeContainer();
      final result = await container.read(overallAdherenceProvider.future);

      // 2 taken / 4 total = 50% = 0.5
      expect(result, closeTo(0.5, 0.001));
    });

    test('excludes skipped records from calculation', () async {
      final records = [
        _makeRecord(
          id: 'r1',
          medicationId: 'med-1',
          status: ReminderStatus.taken,
        ),
        _makeRecord(
          id: 'r2',
          medicationId: 'med-1',
          status: ReminderStatus.skipped,
        ),
        _makeRecord(
          id: 'r3',
          medicationId: 'med-1',
          status: ReminderStatus.skipped,
        ),
      ];
      when(
        mockStorage.getAdherenceRecords(
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
          medicationId: anyNamed('medicationId'),
        ),
      ).thenAnswer((_) async => records);

      final container = makeContainer();
      final result = await container.read(overallAdherenceProvider.future);

      // Only 1 taken, 0 missed (skipped excluded) -> 100% -> 1.0
      expect(result, closeTo(1.0, 0.001));
    });
  });

  group('adherenceRating provider', () {
    test('returns Excellent for percentage >= 95', () {
      final container = makeContainer();

      expect(
        container.read(adherenceRatingProvider(95.0)),
        equals('Excellent'),
      );
      expect(
        container.read(adherenceRatingProvider(100.0)),
        equals('Excellent'),
      );
      expect(
        container.read(adherenceRatingProvider(97.5)),
        equals('Excellent'),
      );
    });

    test('returns Good for percentage >= 80 and < 95', () {
      final container = makeContainer();

      expect(container.read(adherenceRatingProvider(80.0)), equals('Good'));
      expect(container.read(adherenceRatingProvider(90.0)), equals('Good'));
      expect(container.read(adherenceRatingProvider(94.9)), equals('Good'));
    });

    test('returns Fair for percentage >= 50 and < 80', () {
      final container = makeContainer();

      expect(container.read(adherenceRatingProvider(50.0)), equals('Fair'));
      expect(container.read(adherenceRatingProvider(65.0)), equals('Fair'));
      expect(container.read(adherenceRatingProvider(79.9)), equals('Fair'));
    });

    test('returns Poor for percentage < 50', () {
      final container = makeContainer();

      expect(container.read(adherenceRatingProvider(0.0)), equals('Poor'));
      expect(container.read(adherenceRatingProvider(49.9)), equals('Poor'));
      expect(container.read(adherenceRatingProvider(25.0)), equals('Poor'));
    });
  });

  group('medicationAdherence provider', () {
    test('returns null when no records for medication', () async {
      when(
        mockStorage.getAdherenceRecords(
          medicationId: anyNamed('medicationId'),
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        ),
      ).thenAnswer((_) async => []);

      final container = makeContainer();
      final result = await container.read(
        medicationAdherenceProvider('med-1').future,
      );

      expect(result, isNull);
    });

    test('returns correct ratio for a specific medication', () async {
      final records = [
        _makeRecord(
          id: 'r1',
          medicationId: 'med-1',
          status: ReminderStatus.taken,
        ),
        _makeRecord(
          id: 'r2',
          medicationId: 'med-1',
          status: ReminderStatus.missed,
        ),
      ];
      when(
        mockStorage.getAdherenceRecords(
          medicationId: anyNamed('medicationId'),
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        ),
      ).thenAnswer((_) async => records);

      final container = makeContainer();
      final result = await container.read(
        medicationAdherenceProvider('med-1').future,
      );

      // 1 taken / 2 total = 50% -> 0.5
      expect(result, closeTo(0.5, 0.001));
    });
  });

  group('medicationHistory provider', () {
    test('returns records sorted by date descending, limited to 10', () async {
      final now = DateTime.now();
      final records = List.generate(
        15,
        (i) => _makeRecord(
          id: 'r$i',
          medicationId: 'med-1',
          status: ReminderStatus.taken,
          date: now.subtract(Duration(days: i)),
        ),
      );
      when(
        mockStorage.getAdherenceRecords(
          medicationId: anyNamed('medicationId'),
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        ),
      ).thenAnswer((_) async => records);

      final container = makeContainer();
      final result = await container.read(
        medicationHistoryProvider('med-1').future,
      );

      expect(result.length, equals(10));
      // Most recent first
      for (int i = 0; i < result.length - 1; i++) {
        expect(
          result[i].date.isAfter(result[i + 1].date) ||
              result[i].date.isAtSameMomentAs(result[i + 1].date),
          isTrue,
        );
      }
    });

    test('returns all records when fewer than 10', () async {
      final records = [
        _makeRecord(
          id: 'r1',
          medicationId: 'med-1',
          status: ReminderStatus.taken,
        ),
        _makeRecord(
          id: 'r2',
          medicationId: 'med-1',
          status: ReminderStatus.missed,
        ),
      ];
      when(
        mockStorage.getAdherenceRecords(
          medicationId: anyNamed('medicationId'),
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        ),
      ).thenAnswer((_) async => records);

      final container = makeContainer();
      final result = await container.read(
        medicationHistoryProvider('med-1').future,
      );

      expect(result.length, equals(2));
    });
  });

  group('medicationBreakdown provider', () {
    test(
      'returns breakdown list with medication names and percentages',
      () async {
        final meds = [
          _makeMedication('med-1', 'Aspirin'),
          _makeMedication('med-2', 'Ibuprofen'),
        ];
        // First call: medicationListProvider build
        when(mockStorage.getAllMedications()).thenAnswer((_) async => meds);
        when(mockStorage.getAllSchedules()).thenAnswer((_) async => []);

        // Per-medication adherence calls
        when(
          mockStorage.getAdherenceRecords(
            medicationId: anyNamed('medicationId'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
          ),
        ).thenAnswer((_) async => []);

        final container = makeContainer();
        final result = await container.read(medicationBreakdownProvider.future);

        expect(result.length, equals(2));
        expect(
          result.map((r) => r.name),
          containsAll(['Aspirin', 'Ibuprofen']),
        );
      },
    );

    test(
      'returns null percentages when no records exist for medications',
      () async {
        final meds = [_makeMedication('med-1', 'Aspirin')];
        when(mockStorage.getAllMedications()).thenAnswer((_) async => meds);
        when(mockStorage.getAllSchedules()).thenAnswer((_) async => []);
        when(
          mockStorage.getAdherenceRecords(
            medicationId: anyNamed('medicationId'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
          ),
        ).thenAnswer((_) async => []);

        final container = makeContainer();
        final result = await container.read(medicationBreakdownProvider.future);

        expect(result.length, equals(1));
        expect(result.first.percentage, isNull);
      },
    );

    test('returns empty list when no medications exist', () async {
      when(mockStorage.getAllMedications()).thenAnswer((_) async => []);
      when(mockStorage.getAllSchedules()).thenAnswer((_) async => []);

      final container = makeContainer();
      final result = await container.read(medicationBreakdownProvider.future);

      expect(result, isEmpty);
    });

    test('sorts by percentage descending with nulls last', () async {
      final meds = [
        _makeMedication('med-1', 'Low'),
        _makeMedication('med-2', 'High'),
        _makeMedication('med-3', 'NoData'),
      ];
      when(mockStorage.getAllMedications()).thenAnswer((_) async => meds);
      when(mockStorage.getAllSchedules()).thenAnswer((_) async => []);

      // Return different records per medication
      when(
        mockStorage.getAdherenceRecords(
          medicationId: 'med-1',
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        ),
      ).thenAnswer(
        (_) async => [
          _makeRecord(
            id: 'r1',
            medicationId: 'med-1',
            status: ReminderStatus.taken,
          ),
          _makeRecord(
            id: 'r2',
            medicationId: 'med-1',
            status: ReminderStatus.missed,
          ),
        ],
      );
      when(
        mockStorage.getAdherenceRecords(
          medicationId: 'med-2',
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        ),
      ).thenAnswer(
        (_) async => [
          _makeRecord(
            id: 'r3',
            medicationId: 'med-2',
            status: ReminderStatus.taken,
          ),
          _makeRecord(
            id: 'r4',
            medicationId: 'med-2',
            status: ReminderStatus.taken,
          ),
        ],
      );
      when(
        mockStorage.getAdherenceRecords(
          medicationId: 'med-3',
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        ),
      ).thenAnswer((_) async => []);

      final container = makeContainer();
      final result = await container.read(medicationBreakdownProvider.future);

      expect(result.length, 3);
      // High (100%) first, Low (50%) second, NoData (null) last
      expect(result[0].name, 'High');
      expect(result[1].name, 'Low');
      expect(result[2].name, 'NoData');
      expect(result[2].percentage, isNull);
    });
  });

  group('weeklyAdherence provider', () {
    test('returns a map with 7 entries for the last 7 days', () async {
      // Return empty records for every day
      when(
        mockStorage.getAdherenceRecords(
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
          medicationId: anyNamed('medicationId'),
        ),
      ).thenAnswer((_) async => []);

      final container = makeContainer();
      final result = await container.read(weeklyAdherenceProvider.future);

      expect(result.length, equals(7));
    });

    test('returns null values when no records exist for any day', () async {
      when(
        mockStorage.getAdherenceRecords(
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
          medicationId: anyNamed('medicationId'),
        ),
      ).thenAnswer((_) async => []);

      final container = makeContainer();
      final result = await container.read(weeklyAdherenceProvider.future);

      // All values should be null (no data)
      for (final entry in result.entries) {
        expect(entry.value, isNull, reason: 'Day ${entry.key} should be null');
      }
    });

    test('uses weekday numbers as keys', () async {
      when(
        mockStorage.getAdherenceRecords(
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
          medicationId: anyNamed('medicationId'),
        ),
      ).thenAnswer((_) async => []);

      final container = makeContainer();
      final result = await container.read(weeklyAdherenceProvider.future);

      // Keys should be weekday number strings (1-7)
      for (final key in result.keys) {
        final weekday = int.tryParse(key);
        expect(weekday, isNotNull);
        expect(weekday, inInclusiveRange(1, 7));
      }
    });
  });

  group('overallAdherence provider — edge cases', () {
    test('returns null when only skipped records exist', () async {
      final records = [
        _makeRecord(
          id: 'r1',
          medicationId: 'med-1',
          status: ReminderStatus.skipped,
        ),
        _makeRecord(
          id: 'r2',
          medicationId: 'med-1',
          status: ReminderStatus.skipped,
        ),
      ];
      when(
        mockStorage.getAdherenceRecords(
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
          medicationId: anyNamed('medicationId'),
        ),
      ).thenAnswer((_) async => records);

      final container = makeContainer();
      final result = await container.read(overallAdherenceProvider.future);

      // Only skipped → total (taken+missed) = 0 → null
      expect(result, isNull);
    });
  });

  group('medicationAdherence provider — edge cases', () {
    test('excludes skipped from calculation', () async {
      final records = [
        _makeRecord(
          id: 'r1',
          medicationId: 'med-1',
          status: ReminderStatus.taken,
        ),
        _makeRecord(
          id: 'r2',
          medicationId: 'med-1',
          status: ReminderStatus.skipped,
        ),
        _makeRecord(
          id: 'r3',
          medicationId: 'med-1',
          status: ReminderStatus.skipped,
        ),
      ];
      when(
        mockStorage.getAdherenceRecords(
          medicationId: anyNamed('medicationId'),
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        ),
      ).thenAnswer((_) async => records);

      final container = makeContainer();
      final result = await container.read(
        medicationAdherenceProvider('med-1').future,
      );

      // 1 taken / 1 total (skipped excluded) = 100% → 1.0
      expect(result, closeTo(1.0, 0.001));
    });

    test('returns 0.0 when all are missed for specific medication', () async {
      final records = [
        _makeRecord(
          id: 'r1',
          medicationId: 'med-1',
          status: ReminderStatus.missed,
        ),
      ];
      when(
        mockStorage.getAdherenceRecords(
          medicationId: anyNamed('medicationId'),
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        ),
      ).thenAnswer((_) async => records);

      final container = makeContainer();
      final result = await container.read(
        medicationAdherenceProvider('med-1').future,
      );

      expect(result, closeTo(0.0, 0.001));
    });
  });

  group('medicationHistory provider — edge cases', () {
    test('returns empty list when no records exist', () async {
      when(
        mockStorage.getAdherenceRecords(
          medicationId: anyNamed('medicationId'),
          startDate: anyNamed('startDate'),
          endDate: anyNamed('endDate'),
        ),
      ).thenAnswer((_) async => []);

      final container = makeContainer();
      final result = await container.read(
        medicationHistoryProvider('med-1').future,
      );

      expect(result, isEmpty);
    });
  });
}
