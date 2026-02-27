import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/reminder_status.dart';
import 'package:kusuridoki/data/models/adherence_record.dart';

void main() {
  group('AdherenceRecord', () {
    final date = DateTime.utc(2024, 1, 15);
    final scheduledTime = DateTime.utc(2024, 1, 15, 8, 0);
    final actionTime = DateTime.utc(2024, 1, 15, 8, 3);

    AdherenceRecord buildFull() => AdherenceRecord(
      id: 'adh-001',
      medicationId: 'med-001',
      date: date,
      status: ReminderStatus.taken,
      scheduledTime: scheduledTime,
      actionTime: actionTime,
    );

    AdherenceRecord buildMinimal() => AdherenceRecord(
      id: 'adh-002',
      medicationId: 'med-002',
      date: date,
      status: ReminderStatus.missed,
      scheduledTime: scheduledTime,
    );

    group('fromJson/toJson', () {
      test('roundtrip preserves all fields', () {
        final original = buildFull();
        final json = original.toJson();
        final restored = AdherenceRecord.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.medicationId, original.medicationId);
        expect(restored.date, original.date);
        expect(restored.status, original.status);
        expect(restored.scheduledTime, original.scheduledTime);
        expect(restored.actionTime, original.actionTime);
      });

      test('roundtrip with null actionTime', () {
        final original = buildMinimal();
        final json = original.toJson();
        final restored = AdherenceRecord.fromJson(json);

        expect(restored.actionTime, isNull);
      });

      test('toJson encodes status as string', () {
        final record = buildFull();
        final json = record.toJson();

        expect(json['status'], 'taken');
      });

      test('toJson encodes DateTime fields as ISO8601 strings', () {
        final record = buildFull();
        final json = record.toJson();

        expect(json['date'], date.toIso8601String());
        expect(json['scheduledTime'], scheduledTime.toIso8601String());
        expect(json['actionTime'], actionTime.toIso8601String());
      });

      test('fromJson handles all ReminderStatus values', () {
        for (final status in ReminderStatus.values) {
          final json = buildFull().toJson()..['status'] = status.name;
          final record = AdherenceRecord.fromJson(json);
          expect(record.status, status);
        }
      });

      test('roundtrip preserves date only record', () {
        final record = AdherenceRecord(
          id: 'adh-003',
          medicationId: 'med-001',
          date: DateTime.utc(2024, 12, 31),
          status: ReminderStatus.skipped,
          scheduledTime: DateTime.utc(2024, 12, 31, 22, 0),
        );
        final restored = AdherenceRecord.fromJson(record.toJson());

        expect(restored.date, DateTime.utc(2024, 12, 31));
        expect(restored.status, ReminderStatus.skipped);
      });
    });

    group('copyWith', () {
      test('copies with modified status leaves other fields unchanged', () {
        final original = buildFull();
        final copied = original.copyWith(status: ReminderStatus.skipped);

        expect(copied.status, ReminderStatus.skipped);
        expect(copied.id, original.id);
        expect(copied.medicationId, original.medicationId);
        expect(copied.date, original.date);
        expect(copied.scheduledTime, original.scheduledTime);
        expect(copied.actionTime, original.actionTime);
      });

      test('copies with modified actionTime', () {
        final original = buildFull();
        final newActionTime = DateTime.utc(2024, 1, 15, 9, 0);
        final copied = original.copyWith(actionTime: newActionTime);

        expect(copied.actionTime, newActionTime);
        expect(copied.scheduledTime, original.scheduledTime);
      });

      test('copies with null actionTime clears the field', () {
        final original = buildFull();
        final copied = original.copyWith(actionTime: null);

        expect(copied.actionTime, isNull);
        expect(copied.id, original.id);
      });

      test('copies with modified medicationId', () {
        final original = buildFull();
        final copied = original.copyWith(medicationId: 'med-999');

        expect(copied.medicationId, 'med-999');
        expect(copied.id, original.id);
      });

      test('copies with modified date', () {
        final original = buildFull();
        final newDate = DateTime.utc(2024, 6, 1);
        final copied = original.copyWith(date: newDate);

        expect(copied.date, newDate);
        expect(copied.id, original.id);
      });

      test('copies with modified scheduledTime', () {
        final original = buildFull();
        final newScheduledTime = DateTime.utc(2024, 1, 15, 12, 0);
        final copied = original.copyWith(scheduledTime: newScheduledTime);

        expect(copied.scheduledTime, newScheduledTime);
        expect(copied.date, original.date);
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

      test('instances with different status are not equal', () {
        final a = buildFull();
        final b = a.copyWith(status: ReminderStatus.missed);

        expect(a, isNot(equals(b)));
      });

      test('instances with different medicationId are not equal', () {
        final a = buildFull();
        final b = a.copyWith(medicationId: 'med-999');

        expect(a, isNot(equals(b)));
      });

      test('instances with different date are not equal', () {
        final a = buildFull();
        final b = a.copyWith(date: DateTime.utc(2024, 6, 1));

        expect(a, isNot(equals(b)));
      });

      test('instances differing only in actionTime are not equal', () {
        final a = buildFull();
        final b = a.copyWith(actionTime: null);

        expect(a, isNot(equals(b)));
      });
    });

    group('defaults', () {
      test('actionTime defaults to null', () {
        expect(buildMinimal().actionTime, isNull);
      });

      test('required fields must be provided', () {
        expect(buildMinimal().id, 'adh-002');
        expect(buildMinimal().medicationId, 'med-002');
        expect(buildMinimal().status, ReminderStatus.missed);
        expect(buildMinimal().scheduledTime, scheduledTime);
      });
    });
  });
}
