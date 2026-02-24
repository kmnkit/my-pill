import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/enums/reminder_status.dart';
import 'package:my_pill/data/models/reminder.dart';

void main() {
  group('Reminder', () {
    final scheduledTime = DateTime.utc(2024, 1, 15, 8, 0);
    final actionTime = DateTime.utc(2024, 1, 15, 8, 5);
    final snoozedUntil = DateTime.utc(2024, 1, 15, 8, 15);

    Reminder buildFull() => Reminder(
          id: 'rem-001',
          medicationId: 'med-001',
          scheduledTime: scheduledTime,
          status: ReminderStatus.taken,
          actionTime: actionTime,
          snoozedUntil: snoozedUntil,
        );

    Reminder buildMinimal() => Reminder(
          id: 'rem-002',
          medicationId: 'med-002',
          scheduledTime: scheduledTime,
        );

    group('fromJson/toJson', () {
      test('roundtrip preserves all fields', () {
        final original = buildFull();
        final json = original.toJson();
        final restored = Reminder.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.medicationId, original.medicationId);
        expect(restored.scheduledTime, original.scheduledTime);
        expect(restored.status, original.status);
        expect(restored.actionTime, original.actionTime);
        expect(restored.snoozedUntil, original.snoozedUntil);
      });

      test('roundtrip with null optional fields', () {
        final original = buildMinimal();
        final json = original.toJson();
        final restored = Reminder.fromJson(json);

        expect(restored.actionTime, isNull);
        expect(restored.snoozedUntil, isNull);
      });

      test('toJson encodes status as string', () {
        final reminder = buildFull();
        final json = reminder.toJson();

        expect(json['status'], 'taken');
      });

      test('toJson encodes DateTime fields as ISO8601 strings', () {
        final reminder = buildFull();
        final json = reminder.toJson();

        expect(json['scheduledTime'], scheduledTime.toIso8601String());
        expect(json['actionTime'], actionTime.toIso8601String());
        expect(json['snoozedUntil'], snoozedUntil.toIso8601String());
      });

      test('fromJson handles all ReminderStatus values', () {
        for (final status in ReminderStatus.values) {
          final json = buildFull().toJson()..['status'] = status.name;
          final reminder = Reminder.fromJson(json);
          expect(reminder.status, status);
        }
      });

      test('roundtrip preserves scheduledTime precision', () {
        final preciseTime = DateTime.utc(2024, 1, 15, 8, 30, 45);
        final reminder = Reminder(
          id: 'rem-003',
          medicationId: 'med-001',
          scheduledTime: preciseTime,
        );
        final restored = Reminder.fromJson(reminder.toJson());

        expect(restored.scheduledTime, preciseTime);
      });
    });

    group('copyWith', () {
      test('copies with modified status leaves other fields unchanged', () {
        final original = buildFull();
        final copied = original.copyWith(status: ReminderStatus.missed);

        expect(copied.status, ReminderStatus.missed);
        expect(copied.id, original.id);
        expect(copied.medicationId, original.medicationId);
        expect(copied.scheduledTime, original.scheduledTime);
        expect(copied.actionTime, original.actionTime);
        expect(copied.snoozedUntil, original.snoozedUntil);
      });

      test('copies with modified actionTime', () {
        final original = buildFull();
        final newActionTime = DateTime.utc(2024, 1, 15, 9, 0);
        final copied = original.copyWith(actionTime: newActionTime);

        expect(copied.actionTime, newActionTime);
        expect(copied.scheduledTime, original.scheduledTime);
      });

      test('copies with modified snoozedUntil', () {
        final original = buildFull();
        final newSnoozedUntil = DateTime.utc(2024, 1, 15, 8, 30);
        final copied = original.copyWith(snoozedUntil: newSnoozedUntil);

        expect(copied.snoozedUntil, newSnoozedUntil);
        expect(copied.status, original.status);
      });

      test('copies with null actionTime clears the field', () {
        final original = buildFull();
        final copied = original.copyWith(actionTime: null);

        expect(copied.actionTime, isNull);
        expect(copied.id, original.id);
      });

      test('copies with null snoozedUntil clears the field', () {
        final original = buildFull();
        final copied = original.copyWith(snoozedUntil: null);

        expect(copied.snoozedUntil, isNull);
        expect(copied.id, original.id);
      });

      test('copies with modified medicationId', () {
        final original = buildFull();
        final copied = original.copyWith(medicationId: 'med-999');

        expect(copied.medicationId, 'med-999');
        expect(copied.id, original.id);
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

      test('instances with different scheduledTime are not equal', () {
        final a = buildFull();
        final b = a.copyWith(scheduledTime: DateTime.utc(2024, 6, 1));

        expect(a, isNot(equals(b)));
      });

      test('instances with different medicationId are not equal', () {
        final a = buildFull();
        final b = a.copyWith(medicationId: 'med-999');

        expect(a, isNot(equals(b)));
      });

      test('instances differing only in actionTime are not equal', () {
        final a = buildFull();
        final b = a.copyWith(actionTime: null);

        expect(a, isNot(equals(b)));
      });
    });

    group('defaults', () {
      test('status defaults to ReminderStatus.pending', () {
        expect(buildMinimal().status, ReminderStatus.pending);
      });

      test('actionTime defaults to null', () {
        expect(buildMinimal().actionTime, isNull);
      });

      test('snoozedUntil defaults to null', () {
        expect(buildMinimal().snoozedUntil, isNull);
      });
    });
  });
}
