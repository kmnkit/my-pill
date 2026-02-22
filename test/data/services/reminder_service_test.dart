import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_pill/data/enums/reminder_status.dart';
import 'package:my_pill/data/enums/schedule_type.dart';
import 'package:my_pill/data/enums/timezone_mode.dart';
import 'package:my_pill/data/models/reminder.dart';
import 'package:my_pill/data/models/schedule.dart';
import 'package:my_pill/data/services/reminder_service.dart';
import 'package:my_pill/data/services/storage_service.dart';

import 'reminder_service_test.mocks.dart';

@GenerateMocks([StorageService])
void main() {
  late MockStorageService mockStorage;
  late ReminderService service;

  setUp(() {
    mockStorage = MockStorageService();
    service = ReminderService(mockStorage);
  });

  // ─── Helpers ────────────────────────────────────────────────────────────────

  Schedule makeSchedule({
    String id = 'sched-1',
    String medicationId = 'med-1',
    required ScheduleType type,
    List<String> times = const ['08:00'],
    List<int> specificDays = const [],
    int? intervalHours,
    bool isActive = true,
  }) =>
      Schedule(
        id: id,
        medicationId: medicationId,
        type: type,
        times: times,
        specificDays: specificDays,
        intervalHours: intervalHours,
        timezoneMode: TimezoneMode.fixedInterval,
        isActive: isActive,
      );

  Reminder makeReminder({
    String id = 'rem-1',
    String medicationId = 'med-1',
    required DateTime scheduledTime,
    ReminderStatus status = ReminderStatus.pending,
  }) =>
      Reminder(
        id: id,
        medicationId: medicationId,
        scheduledTime: scheduledTime,
        status: status,
      );

  // ─── _shouldGenerateForDate (via generateRemindersForDate) ──────────────────

  group('_shouldGenerateForDate — daily', () {
    test('always generates regardless of weekday', () async {
      final monday = DateTime(2024, 1, 1); // Monday
      final sunday = DateTime(2024, 1, 7); // Sunday

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final schedule = makeSchedule(type: ScheduleType.daily);

      final mondayResult =
          await service.generateRemindersForDate([schedule], monday);
      expect(mondayResult.length, 1);

      final sundayResult =
          await service.generateRemindersForDate([schedule], sunday);
      expect(sundayResult.length, 1);
    });
  });

  group('_shouldGenerateForDate — specificDays', () {
    test('generates only on matching weekdays', () async {
      // Monday=1, Wednesday=3
      final schedule = makeSchedule(
        type: ScheduleType.specificDays,
        specificDays: [1, 3],
      );

      final monday = DateTime(2024, 1, 1); // weekday == 1
      final tuesday = DateTime(2024, 1, 2); // weekday == 2
      final wednesday = DateTime(2024, 1, 3); // weekday == 3

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final monResult =
          await service.generateRemindersForDate([schedule], monday);
      expect(monResult.length, 1, reason: 'Monday is in specificDays');

      final tueResult =
          await service.generateRemindersForDate([schedule], tuesday);
      expect(tueResult.length, 0, reason: 'Tuesday is not in specificDays');

      final wedResult =
          await service.generateRemindersForDate([schedule], wednesday);
      expect(wedResult.length, 1, reason: 'Wednesday is in specificDays');
    });

    test('does not generate when specificDays is empty', () async {
      final schedule = makeSchedule(
        type: ScheduleType.specificDays,
        specificDays: [],
      );

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final result = await service.generateRemindersForDate(
          [schedule], DateTime(2024, 1, 1));
      expect(result.isEmpty, isTrue);
    });
  });

  group('_shouldGenerateForDate — interval', () {
    // Unix epoch = Thursday 1970-01-01 (daysSinceEpoch == 0)
    // daysSinceEpoch % intervalDays == 0  →  should generate

    test('respects intervalHours cycle (Phase 4 bug fix)', () async {
      // intervalHours=48 → intervalDays=2
      // epoch day 0 % 2 == 0 → generate
      // epoch day 1 % 2 != 0 → skip
      final schedule = makeSchedule(
        type: ScheduleType.interval,
        intervalHours: 48,
      );

      // epoch day 0: 1970-01-01 UTC
      final epochDay0 = DateTime.utc(1970, 1, 1).toLocal();
      // epoch day 1: 1970-01-02 UTC
      final epochDay1 = DateTime.utc(1970, 1, 2).toLocal();

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final day0Result =
          await service.generateRemindersForDate([schedule], epochDay0);
      expect(day0Result.length, 1,
          reason: 'day 0 mod 2 == 0, should generate');

      final day1Result =
          await service.generateRemindersForDate([schedule], epochDay1);
      expect(day1Result.length, 0,
          reason: 'day 1 mod 2 != 0, should not generate');
    });

    test('generates every day when intervalHours is null', () async {
      final schedule =
          makeSchedule(type: ScheduleType.interval, intervalHours: null);

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      for (var i = 0; i < 3; i++) {
        final date = DateTime(2024, 1, 1 + i);
        final result =
            await service.generateRemindersForDate([schedule], date);
        expect(result.length, 1,
            reason: 'null intervalHours falls back to generate every day');
      }
    });

    test('generates every day when intervalHours is 0 (edge case)', () async {
      final schedule =
          makeSchedule(type: ScheduleType.interval, intervalHours: 0);

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final result = await service.generateRemindersForDate(
          [schedule], DateTime(2024, 6, 15));
      expect(result.length, 1,
          reason: 'intervalHours=0 treated as null, generates every day');
    });
  });

  // ─── generateRemindersForDate ───────────────────────────────────────────────

  group('generateRemindersForDate', () {
    test('skips inactive schedules', () async {
      final schedule = makeSchedule(
        type: ScheduleType.daily,
        isActive: false,
      );

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final result = await service.generateRemindersForDate(
          [schedule], DateTime(2024, 1, 1));
      expect(result.isEmpty, isTrue);
    });

    test('does not create duplicates when reminder already exists', () async {
      final date = DateTime(2024, 3, 15);
      final scheduledTime = DateTime(2024, 3, 15, 8, 0);

      final existingReminder = makeReminder(
        medicationId: 'med-1',
        scheduledTime: scheduledTime,
      );

      final schedule = makeSchedule(
        type: ScheduleType.daily,
        medicationId: 'med-1',
        times: ['08:00'],
      );

      when(mockStorage.getRemindersForDate(date))
          .thenAnswer((_) async => [existingReminder]);

      final result = await service.generateRemindersForDate([schedule], date);

      // Should return the existing reminder but not save a new one
      expect(result.length, 1);
      verifyNever(mockStorage.saveReminder(any));
    });

    test('creates reminders for all schedule times', () async {
      final date = DateTime(2024, 3, 15);
      final schedule = makeSchedule(
        type: ScheduleType.daily,
        medicationId: 'med-1',
        times: ['08:00', '12:00', '20:00'],
      );

      when(mockStorage.getRemindersForDate(date)).thenAnswer((_) async => []);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final result = await service.generateRemindersForDate([schedule], date);

      expect(result.length, 3);
      expect(result.map((r) => r.scheduledTime.hour).toList(),
          containsAll([8, 12, 20]));
      verify(mockStorage.saveReminder(any)).called(3);
    });

    test('combines existing and new reminders in result', () async {
      final date = DateTime(2024, 3, 15);
      final existingReminder = makeReminder(
        id: 'existing',
        medicationId: 'med-1',
        scheduledTime: DateTime(2024, 3, 15, 8, 0),
      );

      final schedule = makeSchedule(
        type: ScheduleType.daily,
        medicationId: 'med-1',
        times: ['08:00', '20:00'],
      );

      when(mockStorage.getRemindersForDate(date))
          .thenAnswer((_) async => [existingReminder]);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final result = await service.generateRemindersForDate([schedule], date);

      // 1 existing (08:00) + 1 new (20:00)
      expect(result.length, 2);
      verify(mockStorage.saveReminder(any)).called(1);
    });

    test('sets correct scheduled time for each time string', () async {
      final date = DateTime(2024, 3, 15);
      final schedule = makeSchedule(
        type: ScheduleType.daily,
        times: ['09:30', '21:45'],
      );

      when(mockStorage.getRemindersForDate(date)).thenAnswer((_) async => []);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final result = await service.generateRemindersForDate([schedule], date);

      expect(result.length, 2);
      final times = result.map((r) => r.scheduledTime).toList()
        ..sort((a, b) => a.compareTo(b));
      expect(times[0].hour, 9);
      expect(times[0].minute, 30);
      expect(times[1].hour, 21);
      expect(times[1].minute, 45);
    });
  });

  // ─── markAsTaken ────────────────────────────────────────────────────────────

  group('markAsTaken', () {
    test('updates status to taken', () async {
      final reminder = makeReminder(
        id: 'rem-1',
        medicationId: 'med-1',
        scheduledTime: DateTime(2024, 3, 15, 8, 0),
      );

      when(mockStorage.getReminder('rem-1'))
          .thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});
      when(mockStorage.saveAdherenceRecord(any)).thenAnswer((_) async {});

      final updated = await service.markAsTaken('rem-1');

      expect(updated.status, ReminderStatus.taken);
    });

    test('sets actionTime when marking as taken', () async {
      final reminder = makeReminder(
        id: 'rem-1',
        medicationId: 'med-1',
        scheduledTime: DateTime(2024, 3, 15, 8, 0),
      );

      when(mockStorage.getReminder('rem-1'))
          .thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});
      when(mockStorage.saveAdherenceRecord(any)).thenAnswer((_) async {});

      final updated = await service.markAsTaken('rem-1');

      expect(updated.actionTime, isNotNull);
    });

    test('saves the updated reminder', () async {
      final reminder = makeReminder(
        id: 'rem-1',
        medicationId: 'med-1',
        scheduledTime: DateTime(2024, 3, 15, 8, 0),
      );

      when(mockStorage.getReminder('rem-1'))
          .thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});
      when(mockStorage.saveAdherenceRecord(any)).thenAnswer((_) async {});

      await service.markAsTaken('rem-1');

      verify(mockStorage.saveReminder(any)).called(1);
    });

    test('creates an adherence record', () async {
      final reminder = makeReminder(
        id: 'rem-1',
        medicationId: 'med-1',
        scheduledTime: DateTime(2024, 3, 15, 8, 0),
      );

      when(mockStorage.getReminder('rem-1'))
          .thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});
      when(mockStorage.saveAdherenceRecord(any)).thenAnswer((_) async {});

      await service.markAsTaken('rem-1');

      verify(mockStorage.saveAdherenceRecord(any)).called(1);
    });

    test('throws when reminder not found', () async {
      when(mockStorage.getReminder('nonexistent'))
          .thenAnswer((_) async => null);

      expect(
        () => service.markAsTaken('nonexistent'),
        throwsA(isA<Exception>()),
      );
    });
  });

  // ─── markAsSkipped ──────────────────────────────────────────────────────────

  group('markAsSkipped', () {
    test('updates status to skipped and creates adherence record', () async {
      final reminder = makeReminder(
        id: 'rem-2',
        medicationId: 'med-1',
        scheduledTime: DateTime(2024, 3, 15, 8, 0),
      );

      when(mockStorage.getReminder('rem-2'))
          .thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});
      when(mockStorage.saveAdherenceRecord(any)).thenAnswer((_) async {});

      final updated = await service.markAsSkipped('rem-2');

      expect(updated.status, ReminderStatus.skipped);
      verify(mockStorage.saveAdherenceRecord(any)).called(1);
    });

    test('throws when reminder not found', () async {
      when(mockStorage.getReminder('nonexistent'))
          .thenAnswer((_) async => null);

      expect(
        () => service.markAsSkipped('nonexistent'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
