import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/enums/dosage_timing.dart';
import 'package:my_pill/data/models/dosage_time_slot.dart';

void main() {
  group('DosageTimeSlot', () {
    group('constructor', () {
      test('creates with explicit timing and time', () {
        const slot = DosageTimeSlot(
          timing: DosageTiming.morning,
          time: '08:00',
        );

        expect(slot.timing, DosageTiming.morning);
        expect(slot.time, '08:00');
      });

      test('creates with noon timing', () {
        const slot = DosageTimeSlot(
          timing: DosageTiming.noon,
          time: '12:30',
        );

        expect(slot.timing, DosageTiming.noon);
        expect(slot.time, '12:30');
      });

      test('creates with evening timing', () {
        const slot = DosageTimeSlot(
          timing: DosageTiming.evening,
          time: '19:00',
        );

        expect(slot.timing, DosageTiming.evening);
        expect(slot.time, '19:00');
      });

      test('creates with bedtime timing', () {
        const slot = DosageTimeSlot(
          timing: DosageTiming.bedtime,
          time: '23:00',
        );

        expect(slot.timing, DosageTiming.bedtime);
        expect(slot.time, '23:00');
      });
    });

    group('withDefault', () {
      test('morning produces time "08:00"', () {
        final slot = DosageTimeSlot.withDefault(DosageTiming.morning);

        expect(slot.timing, DosageTiming.morning);
        expect(slot.time, '08:00');
      });

      test('noon produces time "12:00"', () {
        final slot = DosageTimeSlot.withDefault(DosageTiming.noon);

        expect(slot.timing, DosageTiming.noon);
        expect(slot.time, '12:00');
      });

      test('evening produces time "18:00"', () {
        final slot = DosageTimeSlot.withDefault(DosageTiming.evening);

        expect(slot.timing, DosageTiming.evening);
        expect(slot.time, '18:00');
      });

      test('bedtime produces time "22:00"', () {
        final slot = DosageTimeSlot.withDefault(DosageTiming.bedtime);

        expect(slot.timing, DosageTiming.bedtime);
        expect(slot.time, '22:00');
      });

      test('formats single-digit hours with zero-padding', () {
        // morning has defaultHour: 8, defaultMinute: 0
        final slot = DosageTimeSlot.withDefault(DosageTiming.morning);

        expect(slot.time, '08:00');
        expect(slot.time.length, 5);
      });

      test('formats double-digit hours correctly', () {
        // noon has defaultHour: 12, defaultMinute: 0
        final slot = DosageTimeSlot.withDefault(DosageTiming.noon);

        expect(slot.time, '12:00');
        expect(slot.time.length, 5);
      });
    });

    group('timeOfDay', () {
      test('returns correct TimeOfDay for morning', () {
        const slot = DosageTimeSlot(
          timing: DosageTiming.morning,
          time: '08:00',
        );

        expect(slot.timeOfDay, const TimeOfDay(hour: 8, minute: 0));
      });

      test('returns correct TimeOfDay for custom time', () {
        const slot = DosageTimeSlot(
          timing: DosageTiming.evening,
          time: '19:30',
        );

        expect(slot.timeOfDay, const TimeOfDay(hour: 19, minute: 30));
      });

      test('returns correct TimeOfDay for midnight-adjacent time', () {
        const slot = DosageTimeSlot(
          timing: DosageTiming.bedtime,
          time: '23:45',
        );

        expect(slot.timeOfDay, const TimeOfDay(hour: 23, minute: 45));
      });

      test('returns correct TimeOfDay for noon', () {
        const slot = DosageTimeSlot(
          timing: DosageTiming.noon,
          time: '12:00',
        );

        expect(slot.timeOfDay, const TimeOfDay(hour: 12, minute: 0));
      });

      test('parses zero-padded hour correctly', () {
        const slot = DosageTimeSlot(
          timing: DosageTiming.morning,
          time: '07:15',
        );

        expect(slot.timeOfDay.hour, 7);
        expect(slot.timeOfDay.minute, 15);
      });
    });

    group('fromJson/toJson', () {
      test('roundtrip preserves all fields', () {
        const original = DosageTimeSlot(
          timing: DosageTiming.morning,
          time: '08:00',
        );
        final json = original.toJson();
        final restored = DosageTimeSlot.fromJson(json);

        expect(restored.timing, original.timing);
        expect(restored.time, original.time);
      });

      test('roundtrip preserves all DosageTiming values', () {
        for (final timing in DosageTiming.values) {
          final original = DosageTimeSlot.withDefault(timing);
          final json = original.toJson();
          final restored = DosageTimeSlot.fromJson(json);

          expect(restored.timing, timing);
          expect(restored.time, original.time);
        }
      });

      test('toJson encodes timing as string', () {
        const slot = DosageTimeSlot(
          timing: DosageTiming.evening,
          time: '18:00',
        );
        final json = slot.toJson();

        expect(json['timing'], 'evening');
        expect(json['time'], '18:00');
      });

      test('fromJson handles all DosageTiming enum values', () {
        for (final timing in DosageTiming.values) {
          final json = {
            'timing': timing.name,
            'time': '10:00',
          };
          final slot = DosageTimeSlot.fromJson(json);
          expect(slot.timing, timing);
        }
      });

      test('roundtrip with custom time preserves exact time string', () {
        const original = DosageTimeSlot(
          timing: DosageTiming.morning,
          time: '09:45',
        );
        final restored = DosageTimeSlot.fromJson(original.toJson());

        expect(restored.time, '09:45');
      });
    });

    group('copyWith', () {
      test('copies with modified timing leaves time unchanged', () {
        const original = DosageTimeSlot(
          timing: DosageTiming.morning,
          time: '08:00',
        );
        final copied = original.copyWith(timing: DosageTiming.noon);

        expect(copied.timing, DosageTiming.noon);
        expect(copied.time, '08:00');
      });

      test('copies with modified time leaves timing unchanged', () {
        const original = DosageTimeSlot(
          timing: DosageTiming.morning,
          time: '08:00',
        );
        final copied = original.copyWith(time: '09:30');

        expect(copied.timing, DosageTiming.morning);
        expect(copied.time, '09:30');
      });
    });

    group('equality', () {
      test('two instances with same fields are equal', () {
        const a = DosageTimeSlot(
          timing: DosageTiming.morning,
          time: '08:00',
        );
        const b = DosageTimeSlot(
          timing: DosageTiming.morning,
          time: '08:00',
        );

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('instances with different timing are not equal', () {
        const a = DosageTimeSlot(
          timing: DosageTiming.morning,
          time: '08:00',
        );
        const b = DosageTimeSlot(
          timing: DosageTiming.noon,
          time: '08:00',
        );

        expect(a, isNot(equals(b)));
      });

      test('instances with different time are not equal', () {
        const a = DosageTimeSlot(
          timing: DosageTiming.morning,
          time: '08:00',
        );
        const b = DosageTimeSlot(
          timing: DosageTiming.morning,
          time: '09:00',
        );

        expect(a, isNot(equals(b)));
      });
    });
  });
}
