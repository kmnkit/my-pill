import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/schedule_type.dart';

void main() {
  group('ScheduleType', () {
    test('has exactly 3 values', () {
      expect(ScheduleType.values.length, 3);
    });

    group('enum names', () {
      test('daily has correct name', () {
        expect(ScheduleType.daily.name, 'daily');
      });

      test('specificDays has correct name', () {
        expect(ScheduleType.specificDays.name, 'specificDays');
      });

      test('interval has correct name', () {
        expect(ScheduleType.interval.name, 'interval');
      });
    });

    group('label metadata', () {
      test('daily label is Daily', () {
        expect(ScheduleType.daily.label, 'Daily');
      });

      test('specificDays label is Specific Days', () {
        expect(ScheduleType.specificDays.label, 'Specific Days');
      });

      test('interval label is Interval', () {
        expect(ScheduleType.interval.label, 'Interval');
      });
    });

    group('all values have non-empty labels', () {
      test('every value has a non-empty label', () {
        for (final type in ScheduleType.values) {
          expect(
            type.label,
            isNotEmpty,
            reason: '${type.name} should have a non-empty label',
          );
        }
      });
    });

    group('labels are unique', () {
      test('no two ScheduleType values share the same label', () {
        final labels = ScheduleType.values.map((t) => t.label).toList();
        final uniqueLabels = labels.toSet();
        expect(
          labels.length,
          uniqueLabels.length,
          reason: 'All ScheduleType labels should be unique',
        );
      });
    });
  });
}
