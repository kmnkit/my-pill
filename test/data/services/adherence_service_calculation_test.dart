// SC-ADH-001 through SC-ADH-011
// Tests for AdherenceService calculation logic (percentage, filtering, sorting)
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/reminder_status.dart';
import 'package:kusuridoki/data/models/adherence_record.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/data/services/adherence_service.dart';
import 'package:kusuridoki/data/services/storage_service.dart';
import 'package:kusuridoki/data/enums/dosage_unit.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';

/// Stub StorageService that returns pre-configured records.
class _StubStorage extends StorageService {
  /// Records returned for all calls (ignores medicationId filter).
  List<AdherenceRecord> Function({
    String? medicationId,
    DateTime? startDate,
    DateTime? endDate,
  })? recordsBuilder;

  List<AdherenceRecord> _defaultRecords = [];

  void setRecords(List<AdherenceRecord> records) {
    _defaultRecords = records;
    recordsBuilder = null;
  }

  @override
  Future<List<AdherenceRecord>> getAdherenceRecords({
    String? medicationId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (recordsBuilder != null) {
      return recordsBuilder!(
        medicationId: medicationId,
        startDate: startDate,
        endDate: endDate,
      );
    }
    if (medicationId != null) {
      return _defaultRecords
          .where((r) => r.medicationId == medicationId)
          .toList();
    }
    return _defaultRecords;
  }
}

AdherenceRecord _makeRecord(
  String id,
  ReminderStatus status, {
  String medicationId = 'med-1',
  DateTime? date,
}) {
  final d = date ?? DateTime(2026, 3, 1);
  return AdherenceRecord(
    id: id,
    medicationId: medicationId,
    date: d,
    status: status,
    scheduledTime: d,
  );
}

Medication _makeMedication(String id, String name) {
  return Medication(
    id: id,
    name: name,
    dosage: 1,
    dosageUnit: DosageUnit.pills,
    shape: PillShape.round,
    color: PillColor.white,
    createdAt: DateTime(2026, 1, 1),
  );
}

void main() {
  late _StubStorage stub;
  late AdherenceService service;

  setUp(() {
    stub = _StubStorage();
    service = AdherenceService(stub);
  });

  // ---------------------------------------------------------------------------
  // SC-ADH-001: 66.67% for 2 taken + 1 missed
  // ---------------------------------------------------------------------------
  group('getDailyAdherence — SC-ADH-001', () {
    test('returns ~66.67 for 2 taken + 1 missed', () async {
      stub.setRecords([
        _makeRecord('r1', ReminderStatus.taken),
        _makeRecord('r2', ReminderStatus.taken),
        _makeRecord('r3', ReminderStatus.missed),
      ]);

      final result = await service.getDailyAdherence(DateTime(2026, 3, 1));

      expect(result, isNotNull);
      expect(result!, closeTo(66.67, 0.01));
    });
  });

  // ---------------------------------------------------------------------------
  // SC-ADH-002: null for empty records
  // ---------------------------------------------------------------------------
  group('getDailyAdherence — SC-ADH-002', () {
    test('returns null when no records exist', () async {
      stub.setRecords([]);

      final result = await service.getDailyAdherence(DateTime(2026, 3, 1));

      expect(result, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // SC-ADH-003: skipped excluded from denominator (1 taken / (1+1) = 50%)
  // ---------------------------------------------------------------------------
  group('getDailyAdherence — SC-ADH-003', () {
    test('excludes skipped from calculation: 1 taken + 1 missed + 1 skipped = 50%',
        () async {
      stub.setRecords([
        _makeRecord('r1', ReminderStatus.taken),
        _makeRecord('r2', ReminderStatus.missed),
        _makeRecord('r3', ReminderStatus.skipped),
      ]);

      final result = await service.getDailyAdherence(DateTime(2026, 3, 1));

      expect(result, isNotNull);
      expect(result!, closeTo(50.0, 0.001));
    });
  });

  // ---------------------------------------------------------------------------
  // SC-ADH-004: null when only skipped records
  // ---------------------------------------------------------------------------
  group('getDailyAdherence — SC-ADH-004', () {
    test('returns null when only skipped records', () async {
      stub.setRecords([
        _makeRecord('r1', ReminderStatus.skipped),
        _makeRecord('r2', ReminderStatus.skipped),
      ]);

      final result = await service.getDailyAdherence(DateTime(2026, 3, 1));

      expect(result, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // SC-ADH-005: 100.0 when all taken
  // ---------------------------------------------------------------------------
  group('getDailyAdherence — SC-ADH-005', () {
    test('returns 100.0 when all records are taken', () async {
      stub.setRecords(List.generate(
        5,
        (i) => _makeRecord('r$i', ReminderStatus.taken),
      ));

      final result = await service.getDailyAdherence(DateTime(2026, 3, 1));

      expect(result, equals(100.0));
    });
  });

  // ---------------------------------------------------------------------------
  // SC-ADH-006: 0.0 when all missed
  // ---------------------------------------------------------------------------
  group('getDailyAdherence — SC-ADH-006', () {
    test('returns 0.0 when all records are missed', () async {
      stub.setRecords([
        _makeRecord('r1', ReminderStatus.missed),
        _makeRecord('r2', ReminderStatus.missed),
        _makeRecord('r3', ReminderStatus.missed),
      ]);

      final result = await service.getDailyAdherence(DateTime(2026, 3, 1));

      expect(result, equals(0.0));
    });
  });

  // ---------------------------------------------------------------------------
  // SC-ADH-007: getOverallAdherence percentage
  // ---------------------------------------------------------------------------
  group('getOverallAdherence — SC-ADH-007', () {
    test('returns 80.0 for 8 taken + 2 missed over 30 days', () async {
      stub.setRecords([
        ...List.generate(8, (i) => _makeRecord('t$i', ReminderStatus.taken)),
        ...List.generate(2, (i) => _makeRecord('m$i', ReminderStatus.missed)),
      ]);

      final result = await service.getOverallAdherence(days: 30);

      expect(result, isNotNull);
      expect(result!, closeTo(80.0, 0.001));
    });

    test('returns null when no records', () async {
      stub.setRecords([]);

      final result = await service.getOverallAdherence(days: 30);

      expect(result, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // SC-ADH-008: getWeeklyAdherence returns 7 entries
  // ---------------------------------------------------------------------------
  group('getWeeklyAdherence — SC-ADH-008', () {
    test('returns map with 7 entries keyed by weekday number strings', () async {
      stub.setRecords([]);

      final result = await service.getWeeklyAdherence();

      expect(result, hasLength(7));
      // Keys must be numeric strings; values are double? or null
      for (final key in result.keys) {
        final weekday = int.tryParse(key);
        expect(weekday, isNotNull, reason: 'key "$key" should be numeric string');
        expect(weekday! >= 1 && weekday <= 7, isTrue);
      }
    });
  });

  // ---------------------------------------------------------------------------
  // SC-ADH-009: getMedicationBreakdown sorts descending, nulls last
  // ---------------------------------------------------------------------------
  group('getMedicationBreakdown — SC-ADH-009', () {
    test('sorts by percentage descending, nulls last', () async {
      final medA = _makeMedication('med-a', 'Med A'); // 80%
      final medB = _makeMedication('med-b', 'Med B'); // null (no records)
      final medC = _makeMedication('med-c', 'Med C'); // 95%

      stub.recordsBuilder = ({medicationId, startDate, endDate}) {
        if (medicationId == 'med-a') {
          return [
            ...List.generate(4, (i) => _makeRecord('a$i', ReminderStatus.taken, medicationId: 'med-a')),
            _makeRecord('a4', ReminderStatus.missed, medicationId: 'med-a'),
          ];
        }
        if (medicationId == 'med-b') {
          return [];
        }
        if (medicationId == 'med-c') {
          return [
            ...List.generate(19, (i) => _makeRecord('c$i', ReminderStatus.taken, medicationId: 'med-c')),
            _makeRecord('c19', ReminderStatus.missed, medicationId: 'med-c'),
          ];
        }
        return [];
      };

      final result = await service.getMedicationBreakdown(
        [medA, medB, medC],
        days: 7,
      );

      expect(result, hasLength(3));
      expect(result[0].id, equals('med-c'));
      expect(result[0].percentage, closeTo(95.0, 0.01));
      expect(result[1].id, equals('med-a'));
      expect(result[1].percentage, closeTo(80.0, 0.01));
      expect(result[2].id, equals('med-b'));
      expect(result[2].percentage, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // SC-ADH-010: getMedicationBreakdown all nulls — list preserved
  // ---------------------------------------------------------------------------
  group('getMedicationBreakdown — SC-ADH-010', () {
    test('returns list of length 2 with null percentages when no records',
        () async {
      final medA = _makeMedication('med-a', 'Med A');
      final medB = _makeMedication('med-b', 'Med B');
      stub.setRecords([]);

      final result = await service.getMedicationBreakdown([medA, medB], days: 7);

      expect(result, hasLength(2));
      expect(result[0].percentage, isNull);
      expect(result[1].percentage, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // SC-ADH-011: getAdherenceRating boundary values (regression)
  // ---------------------------------------------------------------------------
  group('getAdherenceRating — SC-ADH-011 boundary regression', () {
    test('returns correct rating at exact boundary values', () {
      final s = AdherenceService(_StubStorage());
      expect(s.getAdherenceRating(100.0), equals('Excellent'));
      expect(s.getAdherenceRating(95.0), equals('Excellent'));
      expect(s.getAdherenceRating(94.99), equals('Good'));
      expect(s.getAdherenceRating(80.0), equals('Good'));
      expect(s.getAdherenceRating(79.99), equals('Fair'));
      expect(s.getAdherenceRating(50.0), equals('Fair'));
      expect(s.getAdherenceRating(49.99), equals('Poor'));
      expect(s.getAdherenceRating(0.0), equals('Poor'));
    });
  });
}
