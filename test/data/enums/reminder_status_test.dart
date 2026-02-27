import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/reminder_status.dart';

void main() {
  group('ReminderStatus', () {
    test('has exactly 5 values', () {
      expect(ReminderStatus.values.length, 5);
    });

    group('enum names', () {
      test('pending has correct name', () {
        expect(ReminderStatus.pending.name, 'pending');
      });

      test('taken has correct name', () {
        expect(ReminderStatus.taken.name, 'taken');
      });

      test('missed has correct name', () {
        expect(ReminderStatus.missed.name, 'missed');
      });

      test('skipped has correct name', () {
        expect(ReminderStatus.skipped.name, 'skipped');
      });

      test('snoozed has correct name', () {
        expect(ReminderStatus.snoozed.name, 'snoozed');
      });
    });

    group('label metadata', () {
      test('pending label is Upcoming', () {
        expect(ReminderStatus.pending.label, 'Upcoming');
      });

      test('taken label is Taken', () {
        expect(ReminderStatus.taken.label, 'Taken');
      });

      test('missed label is Missed', () {
        expect(ReminderStatus.missed.label, 'Missed');
      });

      test('skipped label is Skipped', () {
        expect(ReminderStatus.skipped.label, 'Skipped');
      });

      test('snoozed label is Snoozed', () {
        expect(ReminderStatus.snoozed.label, 'Snoozed');
      });
    });

    group('pending label differs from its name', () {
      // pending -> 'Upcoming' is intentional: the user-facing label differs
      test('pending label is Upcoming, not Pending', () {
        expect(ReminderStatus.pending.label, isNot('Pending'));
        expect(ReminderStatus.pending.label, 'Upcoming');
      });
    });

    group('all values have non-empty labels', () {
      test('every value has a non-empty label', () {
        for (final status in ReminderStatus.values) {
          expect(
            status.label,
            isNotEmpty,
            reason: '${status.name} should have a non-empty label',
          );
        }
      });
    });

    group('labels are unique', () {
      test('no two ReminderStatus values share the same label', () {
        final labels = ReminderStatus.values.map((s) => s.label).toList();
        final uniqueLabels = labels.toSet();
        expect(
          labels.length,
          uniqueLabels.length,
          reason: 'All ReminderStatus labels should be unique',
        );
      });
    });
  });
}
