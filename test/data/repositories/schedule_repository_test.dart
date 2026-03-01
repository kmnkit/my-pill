import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kusuridoki/data/enums/dosage_timing.dart';
import 'package:kusuridoki/data/enums/schedule_type.dart';
import 'package:kusuridoki/data/enums/timezone_mode.dart';
import 'package:kusuridoki/data/models/dosage_time_slot.dart';
import 'package:kusuridoki/data/models/schedule.dart';
import 'package:kusuridoki/data/repositories/schedule_repository.dart';
import 'package:kusuridoki/data/services/storage_service.dart';

import 'schedule_repository_test.mocks.dart';

@GenerateMocks([StorageService])
void main() {
  late MockStorageService mockStorage;
  late ScheduleRepository repo;

  setUp(() {
    mockStorage = MockStorageService();
    repo = ScheduleRepository(mockStorage);
  });

  // ─── Helpers ────────────────────────────────────────────────────────────────

  Schedule makeSchedule({
    String id = 'sched-1',
    String medicationId = 'med-1',
    ScheduleType type = ScheduleType.daily,
    List<String> times = const ['08:00'],
    List<int> specificDays = const [],
    int? intervalHours,
    bool isActive = true,
  }) => Schedule(
    id: id,
    medicationId: medicationId,
    type: type,
    dosageSlots: times
        .map((t) => DosageTimeSlot(timing: DosageTiming.morning, time: t))
        .toList(),
    specificDays: specificDays,
    intervalHours: intervalHours,
    timezoneMode: TimezoneMode.fixedInterval,
    isActive: isActive,
  );

  // ─── createSchedule ──────────────────────────────────────────────────────────

  group('createSchedule', () {
    test('generates a new UUID and saves the schedule', () async {
      when(mockStorage.saveSchedule(any)).thenAnswer((_) async {});

      final input = makeSchedule(id: 'placeholder-id');
      final result = await repo.createSchedule(input);

      expect(result.id, isNot('placeholder-id'));
      expect(result.id, isNotEmpty);
      verify(mockStorage.saveSchedule(any)).called(1);
    });

    test('returned schedule preserves all fields except id', () async {
      when(mockStorage.saveSchedule(any)).thenAnswer((_) async {});

      final input = makeSchedule(
        id: 'old-id',
        medicationId: 'med-42',
        type: ScheduleType.specificDays,
        times: ['09:00', '21:00'],
        specificDays: [1, 3, 5],
      );

      final result = await repo.createSchedule(input);

      expect(result.medicationId, 'med-42');
      expect(result.type, ScheduleType.specificDays);
      expect(result.times, ['09:00', '21:00']);
      expect(result.specificDays, [1, 3, 5]);
    });

    test('each call generates a unique id', () async {
      when(mockStorage.saveSchedule(any)).thenAnswer((_) async {});

      final a = await repo.createSchedule(makeSchedule(id: 'x'));
      final b = await repo.createSchedule(makeSchedule(id: 'x'));

      expect(a.id, isNot(b.id));
    });
  });

  // ─── getSchedulesForMedication ───────────────────────────────────────────────

  group('getSchedulesForMedication', () {
    test(
      'returns schedules from storage for the given medication id',
      () async {
        final schedules = [
          makeSchedule(id: 's1', medicationId: 'med-1'),
          makeSchedule(id: 's2', medicationId: 'med-1'),
        ];
        when(
          mockStorage.getSchedulesForMedication('med-1'),
        ).thenAnswer((_) async => schedules);

        final result = await repo.getSchedulesForMedication('med-1');

        expect(result, hasLength(2));
        expect(result.every((s) => s.medicationId == 'med-1'), isTrue);
      },
    );

    test('returns empty list when no schedules exist for medication', () async {
      when(
        mockStorage.getSchedulesForMedication('med-99'),
      ).thenAnswer((_) async => []);

      final result = await repo.getSchedulesForMedication('med-99');

      expect(result, isEmpty);
    });
  });

  // ─── updateSchedule ──────────────────────────────────────────────────────────

  group('updateSchedule', () {
    test('calls saveSchedule with the provided schedule', () async {
      when(mockStorage.saveSchedule(any)).thenAnswer((_) async {});

      final schedule = makeSchedule(id: 'sched-1');
      await repo.updateSchedule(schedule);

      final captured = verify(mockStorage.saveSchedule(captureAny)).captured;
      expect(captured.single.id, 'sched-1');
    });

    test('persists updated fields', () async {
      when(mockStorage.saveSchedule(any)).thenAnswer((_) async {});

      final updated = makeSchedule(
        id: 'sched-1',
        times: ['10:00', '22:00'],
        isActive: false,
      );
      await repo.updateSchedule(updated);

      final captured = verify(mockStorage.saveSchedule(captureAny)).captured;
      final saved = captured.single as Schedule;
      expect(saved.times, ['10:00', '22:00']);
      expect(saved.isActive, isFalse);
    });
  });

  // ─── deleteSchedule ──────────────────────────────────────────────────────────

  group('deleteSchedule', () {
    test('calls deleteSchedule on storage with the correct id', () async {
      when(mockStorage.deleteSchedule('sched-1')).thenAnswer((_) async {});

      await repo.deleteSchedule('sched-1');

      verify(mockStorage.deleteSchedule('sched-1')).called(1);
    });

    test('does not call saveSchedule during deletion', () async {
      when(mockStorage.deleteSchedule(any)).thenAnswer((_) async {});

      await repo.deleteSchedule('sched-1');

      verifyNever(mockStorage.saveSchedule(any));
    });
  });

  // ─── isActiveOnDate ──────────────────────────────────────────────────────────

  group('isActiveOnDate', () {
    test('returns false for inactive schedule regardless of type', () {
      final schedule = makeSchedule(isActive: false, type: ScheduleType.daily);
      expect(repo.isActiveOnDate(schedule, DateTime(2024, 1, 1)), isFalse);
    });

    test('daily schedule is active on every day of the week', () {
      final schedule = makeSchedule(type: ScheduleType.daily);
      for (var day = 1; day <= 7; day++) {
        // 2024-01-01 is Monday (weekday=1), so day 1..7 covers Mon–Sun
        final date = DateTime(2024, 1, day);
        expect(
          repo.isActiveOnDate(schedule, date),
          isTrue,
          reason: 'weekday ${date.weekday} should be active',
        );
      }
    });

    test('specificDays schedule is active only on listed weekdays', () {
      // Monday=1, Wednesday=3
      final schedule = makeSchedule(
        type: ScheduleType.specificDays,
        specificDays: [1, 3],
      );

      final monday = DateTime(2024, 1, 1); // weekday 1
      final tuesday = DateTime(2024, 1, 2); // weekday 2
      final wednesday = DateTime(2024, 1, 3); // weekday 3

      expect(repo.isActiveOnDate(schedule, monday), isTrue);
      expect(repo.isActiveOnDate(schedule, tuesday), isFalse);
      expect(repo.isActiveOnDate(schedule, wednesday), isTrue);
    });

    test('interval schedule is always active when isActive is true', () {
      final schedule = makeSchedule(
        type: ScheduleType.interval,
        intervalHours: 6,
      );
      expect(repo.isActiveOnDate(schedule, DateTime(2024, 6, 15)), isTrue);
    });
  });

  // ─── generateTimeSlotsForDate — daily ────────────────────────────────────────

  group('generateTimeSlotsForDate — daily', () {
    test('returns one slot per time entry on the given date', () {
      final schedule = makeSchedule(
        type: ScheduleType.daily,
        times: ['08:00', '14:00', '20:00'],
      );
      final date = DateTime(2024, 3, 15);

      final slots = repo.generateTimeSlotsForDate(schedule, date);

      expect(slots, hasLength(3));
      expect(slots.map((s) => s.hour).toList(), containsAll([8, 14, 20]));
      expect(
        slots.every((s) => s.year == 2024 && s.month == 3 && s.day == 15),
        isTrue,
      );
    });

    test('returns empty list for inactive schedule', () {
      final schedule = makeSchedule(
        type: ScheduleType.daily,
        isActive: false,
        times: ['08:00'],
      );

      final slots = repo.generateTimeSlotsForDate(
        schedule,
        DateTime(2024, 3, 15),
      );

      expect(slots, isEmpty);
    });

    test('skips malformed time strings gracefully', () {
      final schedule = makeSchedule(
        type: ScheduleType.daily,
        times: ['08:00', 'bad-time', '20:00'],
      );

      final slots = repo.generateTimeSlotsForDate(
        schedule,
        DateTime(2024, 3, 15),
      );

      expect(slots, hasLength(2));
      expect(slots.map((s) => s.hour).toList(), containsAll([8, 20]));
    });

    test('returns empty list when times list is empty', () {
      final schedule = makeSchedule(type: ScheduleType.daily, times: []);

      final slots = repo.generateTimeSlotsForDate(
        schedule,
        DateTime(2024, 3, 15),
      );

      expect(slots, isEmpty);
    });
  });

  // ─── generateTimeSlotsForDate — specificDays ─────────────────────────────────

  group('generateTimeSlotsForDate — specificDays', () {
    test('returns slots only on scheduled weekdays', () {
      // Monday=1, Friday=5
      final schedule = makeSchedule(
        type: ScheduleType.specificDays,
        specificDays: [1, 5],
        times: ['08:00'],
      );

      final monday = DateTime(2024, 1, 1); // weekday 1
      final tuesday = DateTime(2024, 1, 2); // weekday 2
      final friday = DateTime(2024, 1, 5); // weekday 5

      expect(repo.generateTimeSlotsForDate(schedule, monday), hasLength(1));
      expect(repo.generateTimeSlotsForDate(schedule, tuesday), isEmpty);
      expect(repo.generateTimeSlotsForDate(schedule, friday), hasLength(1));
    });

    test('returns empty list when specificDays is empty', () {
      final schedule = makeSchedule(
        type: ScheduleType.specificDays,
        specificDays: [],
        times: ['08:00'],
      );

      final slots = repo.generateTimeSlotsForDate(
        schedule,
        DateTime(2024, 1, 1),
      );

      expect(slots, isEmpty);
    });
  });

  // ─── generateTimeSlotsForDate — interval ─────────────────────────────────────

  group('generateTimeSlotsForDate — interval', () {
    test('generates slots spaced by intervalHours throughout the day', () {
      // Starting 00:00 with 8-hour interval → 00:00, 08:00, 16:00
      final schedule = makeSchedule(
        type: ScheduleType.interval,
        intervalHours: 8,
        times: ['00:00'],
      );

      final slots = repo.generateTimeSlotsForDate(
        schedule,
        DateTime(2024, 3, 15),
      );

      expect(slots, hasLength(3));
      expect(slots[0].hour, 0);
      expect(slots[1].hour, 8);
      expect(slots[2].hour, 16);
    });

    test('uses first time as start of interval cycle', () {
      // Starting 06:00 with 6-hour interval → 06:00, 12:00, 18:00
      final schedule = makeSchedule(
        type: ScheduleType.interval,
        intervalHours: 6,
        times: ['06:00'],
      );

      final slots = repo.generateTimeSlotsForDate(
        schedule,
        DateTime(2024, 3, 15),
      );

      expect(slots, hasLength(3));
      expect(slots[0].hour, 6);
      expect(slots[1].hour, 12);
      expect(slots[2].hour, 18);
    });

    test('returns empty list when intervalHours is null', () {
      final schedule = makeSchedule(
        type: ScheduleType.interval,
        intervalHours: null,
        times: ['08:00'],
      );

      final slots = repo.generateTimeSlotsForDate(
        schedule,
        DateTime(2024, 3, 15),
      );

      expect(slots, isEmpty);
    });

    test('returns empty list when intervalHours is zero', () {
      final schedule = makeSchedule(
        type: ScheduleType.interval,
        intervalHours: 0,
        times: ['08:00'],
      );

      final slots = repo.generateTimeSlotsForDate(
        schedule,
        DateTime(2024, 3, 15),
      );

      expect(slots, isEmpty);
    });

    test('falls back to midnight when times list is empty', () {
      // No start time, 12-hour interval → 00:00, 12:00
      final schedule = makeSchedule(
        type: ScheduleType.interval,
        intervalHours: 12,
        times: [],
      );

      final slots = repo.generateTimeSlotsForDate(
        schedule,
        DateTime(2024, 3, 15),
      );

      expect(slots, hasLength(2));
      expect(slots[0].hour, 0);
      expect(slots[1].hour, 12);
    });

    test('all generated slots fall on the requested date', () {
      final schedule = makeSchedule(
        type: ScheduleType.interval,
        intervalHours: 4,
        times: ['00:00'],
      );
      final date = DateTime(2024, 7, 20);

      final slots = repo.generateTimeSlotsForDate(schedule, date);

      expect(
        slots.every(
          (s) =>
              s.year == date.year && s.month == date.month && s.day == date.day,
        ),
        isTrue,
      );
    });
  });
}
