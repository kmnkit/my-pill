import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/enums/dosage_timing.dart';
import 'package:my_pill/data/enums/schedule_type.dart';
import 'package:my_pill/data/enums/timezone_mode.dart';
import 'package:my_pill/data/models/dosage_time_slot.dart';
import 'package:my_pill/data/models/schedule.dart';

void main() {
  group('Schedule', () {
    Schedule buildFull() => Schedule(
          id: 'sched-001',
          medicationId: 'med-001',
          type: ScheduleType.specificDays,
          dosageSlots: [
            const DosageTimeSlot(timing: DosageTiming.morning, time: '08:00'),
            const DosageTimeSlot(timing: DosageTiming.noon, time: '13:00'),
            const DosageTimeSlot(timing: DosageTiming.evening, time: '20:00'),
          ],
          specificDays: const [1, 3, 5],
          intervalHours: 8,
          timezoneMode: TimezoneMode.localTime,
          isActive: false,
        );

    Schedule buildMinimal() => const Schedule(
          id: 'sched-002',
          medicationId: 'med-002',
          type: ScheduleType.daily,
        );

    group('dosageSlots', () {
      test('creates Schedule with dosageSlots correctly', () {
        final schedule = Schedule(
          id: 'sched-1',
          medicationId: 'med-1',
          type: ScheduleType.daily,
          dosageSlots: [
            DosageTimeSlot.withDefault(DosageTiming.morning),
          ],
        );

        expect(schedule.dosageSlots, hasLength(1));
        expect(schedule.dosageSlots.first.timing, DosageTiming.morning);
        expect(schedule.dosageSlots.first.time, '08:00');
      });

      test('timesPerDay getter returns dosageSlots.length', () {
        final schedule = Schedule(
          id: 'sched-1',
          medicationId: 'med-1',
          type: ScheduleType.daily,
          dosageSlots: [
            DosageTimeSlot.withDefault(DosageTiming.morning),
            DosageTimeSlot.withDefault(DosageTiming.evening),
          ],
        );

        expect(schedule.timesPerDay, 2);
      });

      test('times getter returns extracted time strings from dosageSlots', () {
        final schedule = Schedule(
          id: 'sched-1',
          medicationId: 'med-1',
          type: ScheduleType.daily,
          dosageSlots: [
            const DosageTimeSlot(timing: DosageTiming.morning, time: '08:00'),
            const DosageTimeSlot(timing: DosageTiming.noon, time: '12:30'),
            const DosageTimeSlot(timing: DosageTiming.evening, time: '19:00'),
          ],
        );

        expect(schedule.times, ['08:00', '12:30', '19:00']);
      });

      test('dosageTimings getter returns extracted DosageTiming values', () {
        final schedule = Schedule(
          id: 'sched-1',
          medicationId: 'med-1',
          type: ScheduleType.daily,
          dosageSlots: [
            DosageTimeSlot.withDefault(DosageTiming.morning),
            DosageTimeSlot.withDefault(DosageTiming.bedtime),
          ],
        );

        expect(schedule.dosageTimings, [
          DosageTiming.morning,
          DosageTiming.bedtime,
        ]);
      });

      test('empty dosageSlots gives zero timesPerDay and empty lists', () {
        final schedule = buildMinimal();

        expect(schedule.dosageSlots, isEmpty);
        expect(schedule.timesPerDay, 0);
        expect(schedule.times, isEmpty);
        expect(schedule.dosageTimings, isEmpty);
      });

      test('multiple dosageSlots preserve order', () {
        final schedule = Schedule(
          id: 'sched-1',
          medicationId: 'med-1',
          type: ScheduleType.daily,
          dosageSlots: [
            DosageTimeSlot.withDefault(DosageTiming.evening),
            DosageTimeSlot.withDefault(DosageTiming.morning),
            DosageTimeSlot.withDefault(DosageTiming.noon),
          ],
        );

        expect(schedule.dosageTimings, [
          DosageTiming.evening,
          DosageTiming.morning,
          DosageTiming.noon,
        ]);
        expect(schedule.times, ['18:00', '08:00', '12:00']);
      });
    });

    group('fromJson/toJson', () {
      test('roundtrip preserves all fields including dosageSlots', () {
        final original = buildFull();
        final json = original.toJson();
        final restored = Schedule.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.medicationId, original.medicationId);
        expect(restored.type, original.type);
        expect(restored.dosageSlots, original.dosageSlots);
        expect(restored.timesPerDay, original.timesPerDay);
        expect(restored.times, original.times);
        expect(restored.dosageTimings, original.dosageTimings);
        expect(restored.specificDays, original.specificDays);
        expect(restored.intervalHours, original.intervalHours);
        expect(restored.timezoneMode, original.timezoneMode);
        expect(restored.isActive, original.isActive);
      });

      test('roundtrip with null intervalHours', () {
        final original = buildMinimal();
        final json = original.toJson();
        final restored = Schedule.fromJson(json);

        expect(restored.intervalHours, isNull);
      });

      test('roundtrip preserves empty lists', () {
        final original = buildMinimal();
        final json = original.toJson();
        final restored = Schedule.fromJson(json);

        expect(restored.dosageSlots, isEmpty);
        expect(restored.times, isEmpty);
        expect(restored.specificDays, isEmpty);
      });

      test('toJson encodes enum values as strings', () {
        final schedule = buildFull();
        final json = schedule.toJson();

        expect(json['type'], 'specificDays');
        expect(json['timezoneMode'], 'localTime');
      });

      test('fromJson handles all ScheduleType values', () {
        for (final type in ScheduleType.values) {
          final json = buildFull().toJson()..['type'] = type.name;
          final schedule = Schedule.fromJson(json);
          expect(schedule.type, type);
        }
      });

      test('fromJson handles all TimezoneMode values', () {
        for (final mode in TimezoneMode.values) {
          final json = buildFull().toJson()..['timezoneMode'] = mode.name;
          final schedule = Schedule.fromJson(json);
          expect(schedule.timezoneMode, mode);
        }
      });

      test('roundtrip preserves dosageSlots order', () {
        final original = buildFull();
        final restored = Schedule.fromJson(original.toJson());

        expect(restored.times, ['08:00', '13:00', '20:00']);
        expect(restored.dosageTimings, [
          DosageTiming.morning,
          DosageTiming.noon,
          DosageTiming.evening,
        ]);
      });

      test('roundtrip preserves specificDays list', () {
        final original = buildFull();
        final restored = Schedule.fromJson(original.toJson());

        expect(restored.specificDays, [1, 3, 5]);
      });

      test('JSON roundtrip with dosageSlots serializes nested objects', () {
        final schedule = Schedule(
          id: 'sched-1',
          medicationId: 'med-1',
          type: ScheduleType.daily,
          dosageSlots: [
            DosageTimeSlot.withDefault(DosageTiming.morning),
          ],
        );

        final json = schedule.toJson();
        expect(json['dosageSlots'], isList);
        expect((json['dosageSlots'] as List).first, isA<Map>());

        final restored = Schedule.fromJson(json);
        expect(restored.dosageSlots.first.timing, DosageTiming.morning);
        expect(restored.dosageSlots.first.time, '08:00');
      });
    });

    group('copyWith', () {
      test('copies with modified type leaves other fields unchanged', () {
        final original = buildFull();
        final copied = original.copyWith(type: ScheduleType.interval);

        expect(copied.type, ScheduleType.interval);
        expect(copied.id, original.id);
        expect(copied.medicationId, original.medicationId);
        expect(copied.dosageSlots, original.dosageSlots);
        expect(copied.timesPerDay, original.timesPerDay);
        expect(copied.times, original.times);
        expect(copied.specificDays, original.specificDays);
        expect(copied.intervalHours, original.intervalHours);
        expect(copied.timezoneMode, original.timezoneMode);
        expect(copied.isActive, original.isActive);
      });

      test('copies with modified dosageSlots', () {
        final original = buildFull();
        final newSlots = [
          DosageTimeSlot.withDefault(DosageTiming.bedtime),
        ];
        final copied = original.copyWith(dosageSlots: newSlots);

        expect(copied.dosageSlots, newSlots);
        expect(copied.timesPerDay, 1);
        expect(copied.times, ['22:00']);
        expect(copied.type, original.type);
      });

      test('copies with isActive toggled', () {
        final original = buildFull();
        final copied = original.copyWith(isActive: true);

        expect(copied.isActive, true);
        expect(copied.type, original.type);
      });

      test('copies with null intervalHours clears the field', () {
        final original = buildFull();
        final copied = original.copyWith(intervalHours: null);

        expect(copied.intervalHours, isNull);
        expect(copied.id, original.id);
      });

      test('copies with modified specificDays', () {
        final original = buildFull();
        final copied = original.copyWith(specificDays: [2, 4, 6]);

        expect(copied.specificDays, [2, 4, 6]);
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

      test('instances with different type are not equal', () {
        final a = buildFull();
        final b = a.copyWith(type: ScheduleType.daily);

        expect(a, isNot(equals(b)));
      });

      test('instances with different dosageSlots are not equal', () {
        final a = buildFull();
        final b = a.copyWith(dosageSlots: [
          DosageTimeSlot.withDefault(DosageTiming.morning),
        ]);

        expect(a, isNot(equals(b)));
      });

      test('instances with different isActive are not equal', () {
        final a = buildFull();
        final b = a.copyWith(isActive: true);

        expect(a, isNot(equals(b)));
      });

      test('instances with different timezoneMode are not equal', () {
        final a = buildFull();
        final b = a.copyWith(timezoneMode: TimezoneMode.fixedInterval);

        expect(a, isNot(equals(b)));
      });
    });

    group('defaults', () {
      test('dosageSlots defaults to empty list', () {
        expect(buildMinimal().dosageSlots, isEmpty);
      });

      test('timesPerDay defaults to 0 (empty dosageSlots)', () {
        expect(buildMinimal().timesPerDay, 0);
      });

      test('times defaults to empty list', () {
        expect(buildMinimal().times, isEmpty);
      });

      test('specificDays defaults to empty list', () {
        expect(buildMinimal().specificDays, isEmpty);
      });

      test('intervalHours defaults to null', () {
        expect(buildMinimal().intervalHours, isNull);
      });

      test('timezoneMode defaults to TimezoneMode.fixedInterval', () {
        expect(buildMinimal().timezoneMode, TimezoneMode.fixedInterval);
      });

      test('isActive defaults to true', () {
        expect(buildMinimal().isActive, true);
      });
    });
  });
}
