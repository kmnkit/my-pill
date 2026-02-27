import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/timezone_mode.dart';

void main() {
  group('TimezoneMode', () {
    test('has exactly 2 values', () {
      expect(TimezoneMode.values.length, 2);
    });

    group('enum names', () {
      test('fixedInterval has correct name', () {
        expect(TimezoneMode.fixedInterval.name, 'fixedInterval');
      });

      test('localTime has correct name', () {
        expect(TimezoneMode.localTime.name, 'localTime');
      });
    });

    group('label metadata', () {
      test('fixedInterval label is Fixed Interval (Home Time)', () {
        expect(TimezoneMode.fixedInterval.label, 'Fixed Interval (Home Time)');
      });

      test('localTime label is Local Time Adaptation', () {
        expect(TimezoneMode.localTime.label, 'Local Time Adaptation');
      });
    });

    group('all values have non-empty labels', () {
      test('every value has a non-empty label', () {
        for (final mode in TimezoneMode.values) {
          expect(
            mode.label,
            isNotEmpty,
            reason: '${mode.name} should have a non-empty label',
          );
        }
      });
    });

    group('labels are unique', () {
      test('no two TimezoneMode values share the same label', () {
        final labels = TimezoneMode.values.map((m) => m.label).toList();
        final uniqueLabels = labels.toSet();
        expect(
          labels.length,
          uniqueLabels.length,
          reason: 'All TimezoneMode labels should be unique',
        );
      });
    });
  });
}
