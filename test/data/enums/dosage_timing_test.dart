import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/enums/dosage_timing.dart';

void main() {
  group('DosageTiming', () {
    test('has exactly 4 values', () {
      expect(DosageTiming.values.length, 4);
    });

    group('existing label field (backward compatibility)', () {
      test('morning label is Morning', () {
        expect(DosageTiming.morning.label, 'Morning');
      });

      test('noon label is Noon', () {
        expect(DosageTiming.noon.label, 'Noon');
      });

      test('evening label is Evening', () {
        expect(DosageTiming.evening.label, 'Evening');
      });

      test('bedtime label is Bedtime', () {
        expect(DosageTiming.bedtime.label, 'Bedtime');
      });
    });

    group('default time metadata', () {
      test('morning default time is 08:00', () {
        expect(DosageTiming.morning.defaultHour, 8);
        expect(DosageTiming.morning.defaultMinute, 0);
      });

      test('noon default time is 12:00', () {
        expect(DosageTiming.noon.defaultHour, 12);
        expect(DosageTiming.noon.defaultMinute, 0);
      });

      test('evening default time is 18:00', () {
        expect(DosageTiming.evening.defaultHour, 18);
        expect(DosageTiming.evening.defaultMinute, 0);
      });

      test('bedtime default time is 22:00', () {
        expect(DosageTiming.bedtime.defaultHour, 22);
        expect(DosageTiming.bedtime.defaultMinute, 0);
      });
    });

    group('range metadata', () {
      test('morning range is 05:00 ~ 10:59', () {
        expect(DosageTiming.morning.minHour, 5);
        expect(DosageTiming.morning.maxHour, 10);
      });

      test('noon range is 11:00 ~ 14:59', () {
        expect(DosageTiming.noon.minHour, 11);
        expect(DosageTiming.noon.maxHour, 14);
      });

      test('evening range is 15:00 ~ 20:59', () {
        expect(DosageTiming.evening.minHour, 15);
        expect(DosageTiming.evening.maxHour, 20);
      });

      test('bedtime range is 21:00 ~ 01:59', () {
        expect(DosageTiming.bedtime.minHour, 21);
        expect(DosageTiming.bedtime.maxHour, 1);
      });
    });

    group('defaultTimeOfDay getter', () {
      test('morning returns TimeOfDay(8, 0)', () {
        expect(
          DosageTiming.morning.defaultTimeOfDay,
          const TimeOfDay(hour: 8, minute: 0),
        );
      });

      test('noon returns TimeOfDay(12, 0)', () {
        expect(
          DosageTiming.noon.defaultTimeOfDay,
          const TimeOfDay(hour: 12, minute: 0),
        );
      });

      test('evening returns TimeOfDay(18, 0)', () {
        expect(
          DosageTiming.evening.defaultTimeOfDay,
          const TimeOfDay(hour: 18, minute: 0),
        );
      });

      test('bedtime returns TimeOfDay(22, 0)', () {
        expect(
          DosageTiming.bedtime.defaultTimeOfDay,
          const TimeOfDay(hour: 22, minute: 0),
        );
      });
    });

    group('isTimeInRange', () {
      group('morning (05:00 ~ 10:59)', () {
        test('05:00 is in range', () {
          expect(DosageTiming.morning.isTimeInRange(5, 0), isTrue);
        });

        test('08:00 is in range (default)', () {
          expect(DosageTiming.morning.isTimeInRange(8, 0), isTrue);
        });

        test('10:59 is in range (upper boundary)', () {
          expect(DosageTiming.morning.isTimeInRange(10, 59), isTrue);
        });

        test('04:59 is out of range (before start)', () {
          expect(DosageTiming.morning.isTimeInRange(4, 59), isFalse);
        });

        test('11:00 is out of range (after end)', () {
          expect(DosageTiming.morning.isTimeInRange(11, 0), isFalse);
        });
      });

      group('noon (11:00 ~ 14:59)', () {
        test('11:00 is in range', () {
          expect(DosageTiming.noon.isTimeInRange(11, 0), isTrue);
        });

        test('12:00 is in range (default)', () {
          expect(DosageTiming.noon.isTimeInRange(12, 0), isTrue);
        });

        test('14:59 is in range (upper boundary)', () {
          expect(DosageTiming.noon.isTimeInRange(14, 59), isTrue);
        });

        test('10:59 is out of range (before start)', () {
          expect(DosageTiming.noon.isTimeInRange(10, 59), isFalse);
        });

        test('15:00 is out of range (after end)', () {
          expect(DosageTiming.noon.isTimeInRange(15, 0), isFalse);
        });
      });

      group('evening (15:00 ~ 20:59)', () {
        test('15:00 is in range', () {
          expect(DosageTiming.evening.isTimeInRange(15, 0), isTrue);
        });

        test('18:00 is in range (default)', () {
          expect(DosageTiming.evening.isTimeInRange(18, 0), isTrue);
        });

        test('20:59 is in range (upper boundary)', () {
          expect(DosageTiming.evening.isTimeInRange(20, 59), isTrue);
        });

        test('14:59 is out of range (before start)', () {
          expect(DosageTiming.evening.isTimeInRange(14, 59), isFalse);
        });

        test('21:00 is out of range (after end)', () {
          expect(DosageTiming.evening.isTimeInRange(21, 0), isFalse);
        });
      });

      group('bedtime with midnight wrap-around (21:00 ~ 01:59)', () {
        test('21:00 is in range (lower boundary)', () {
          expect(DosageTiming.bedtime.isTimeInRange(21, 0), isTrue);
        });

        test('22:00 is in range (default)', () {
          expect(DosageTiming.bedtime.isTimeInRange(22, 0), isTrue);
        });

        test('23:00 is in range', () {
          expect(DosageTiming.bedtime.isTimeInRange(23, 0), isTrue);
        });

        test('23:59 is in range', () {
          expect(DosageTiming.bedtime.isTimeInRange(23, 59), isTrue);
        });

        test('00:00 is in range (midnight)', () {
          expect(DosageTiming.bedtime.isTimeInRange(0, 0), isTrue);
        });

        test('00:30 is in range', () {
          expect(DosageTiming.bedtime.isTimeInRange(0, 30), isTrue);
        });

        test('01:00 is in range', () {
          expect(DosageTiming.bedtime.isTimeInRange(1, 0), isTrue);
        });

        test('01:59 is in range (upper boundary)', () {
          expect(DosageTiming.bedtime.isTimeInRange(1, 59), isTrue);
        });

        test('02:00 is out of range (after end)', () {
          expect(DosageTiming.bedtime.isTimeInRange(2, 0), isFalse);
        });

        test('20:59 is out of range (before start)', () {
          expect(DosageTiming.bedtime.isTimeInRange(20, 59), isFalse);
        });

        test('10:00 is out of range (daytime)', () {
          expect(DosageTiming.bedtime.isTimeInRange(10, 0), isFalse);
        });
      });
    });

    group('all values have valid metadata', () {
      test('every value has defaultHour in 0-23 range', () {
        for (final timing in DosageTiming.values) {
          expect(timing.defaultHour, inInclusiveRange(0, 23),
              reason: '${timing.name} defaultHour should be 0-23');
        }
      });

      test('every value has defaultMinute in 0-59 range', () {
        for (final timing in DosageTiming.values) {
          expect(timing.defaultMinute, inInclusiveRange(0, 59),
              reason: '${timing.name} defaultMinute should be 0-59');
        }
      });

      test('every value has minHour in 0-23 range', () {
        for (final timing in DosageTiming.values) {
          expect(timing.minHour, inInclusiveRange(0, 23),
              reason: '${timing.name} minHour should be 0-23');
        }
      });

      test('every value has maxHour in 0-23 range', () {
        for (final timing in DosageTiming.values) {
          expect(timing.maxHour, inInclusiveRange(0, 23),
              reason: '${timing.name} maxHour should be 0-23');
        }
      });

      test('every value has a non-empty label', () {
        for (final timing in DosageTiming.values) {
          expect(timing.label, isNotEmpty,
              reason: '${timing.name} should have a non-empty label');
        }
      });

      test('every default time is within its own range', () {
        for (final timing in DosageTiming.values) {
          expect(
            timing.isTimeInRange(timing.defaultHour, timing.defaultMinute),
            isTrue,
            reason:
                '${timing.name} default time ${timing.defaultHour}:${timing.defaultMinute} should be in its own range',
          );
        }
      });
    });
  });
}
