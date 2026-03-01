import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kusuridoki/data/enums/reminder_status.dart';
import 'package:kusuridoki/data/enums/dosage_timing.dart';
import 'package:kusuridoki/data/enums/schedule_type.dart';
import 'package:kusuridoki/data/enums/timezone_mode.dart';
import 'package:kusuridoki/data/models/dosage_time_slot.dart';
import 'package:kusuridoki/data/models/reminder.dart';
import 'package:kusuridoki/data/models/schedule.dart';
import 'package:kusuridoki/data/services/reminder_service.dart';
import 'package:kusuridoki/data/services/storage_service.dart';

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

  Reminder makeReminder({
    String id = 'rem-1',
    String medicationId = 'med-1',
    required DateTime scheduledTime,
    ReminderStatus status = ReminderStatus.pending,
  }) => Reminder(
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

      final mondayResult = await service.generateRemindersForDate([
        schedule,
      ], monday);
      expect(mondayResult.length, 1);

      final sundayResult = await service.generateRemindersForDate([
        schedule,
      ], sunday);
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

      final monResult = await service.generateRemindersForDate([
        schedule,
      ], monday);
      expect(monResult.length, 1, reason: 'Monday is in specificDays');

      final tueResult = await service.generateRemindersForDate([
        schedule,
      ], tuesday);
      expect(tueResult.length, 0, reason: 'Tuesday is not in specificDays');

      final wedResult = await service.generateRemindersForDate([
        schedule,
      ], wednesday);
      expect(wedResult.length, 1, reason: 'Wednesday is in specificDays');
    });

    test('does not generate when specificDays is empty', () async {
      final schedule = makeSchedule(
        type: ScheduleType.specificDays,
        specificDays: [],
      );

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final result = await service.generateRemindersForDate([
        schedule,
      ], DateTime(2024, 1, 1));
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

      final day0Result = await service.generateRemindersForDate([
        schedule,
      ], epochDay0);
      expect(day0Result.length, 1, reason: 'day 0 mod 2 == 0, should generate');

      final day1Result = await service.generateRemindersForDate([
        schedule,
      ], epochDay1);
      expect(
        day1Result.length,
        0,
        reason: 'day 1 mod 2 != 0, should not generate',
      );
    });

    test('generates every day when intervalHours is null', () async {
      final schedule = makeSchedule(
        type: ScheduleType.interval,
        intervalHours: null,
      );

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      for (var i = 0; i < 3; i++) {
        final date = DateTime(2024, 1, 1 + i);
        final result = await service.generateRemindersForDate([schedule], date);
        expect(
          result.length,
          1,
          reason: 'null intervalHours falls back to generate every day',
        );
      }
    });

    test('generates every day when intervalHours is 0 (edge case)', () async {
      final schedule = makeSchedule(
        type: ScheduleType.interval,
        intervalHours: 0,
      );

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final result = await service.generateRemindersForDate([
        schedule,
      ], DateTime(2024, 6, 15));
      expect(
        result.length,
        1,
        reason: 'intervalHours=0 treated as null, generates every day',
      );
    });
  });

  // ─── generateRemindersForDate ───────────────────────────────────────────────

  group('generateRemindersForDate', () {
    test('skips inactive schedules', () async {
      final schedule = makeSchedule(type: ScheduleType.daily, isActive: false);

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final result = await service.generateRemindersForDate([
        schedule,
      ], DateTime(2024, 1, 1));
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

      when(
        mockStorage.getRemindersForDate(date),
      ).thenAnswer((_) async => [existingReminder]);

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
      expect(
        result.map((r) => r.scheduledTime.hour).toList(),
        containsAll([8, 12, 20]),
      );
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

      when(
        mockStorage.getRemindersForDate(date),
      ).thenAnswer((_) async => [existingReminder]);
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

      when(mockStorage.getReminder('rem-1')).thenAnswer((_) async => reminder);
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

      when(mockStorage.getReminder('rem-1')).thenAnswer((_) async => reminder);
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

      when(mockStorage.getReminder('rem-1')).thenAnswer((_) async => reminder);
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

      when(mockStorage.getReminder('rem-1')).thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});
      when(mockStorage.saveAdherenceRecord(any)).thenAnswer((_) async {});

      await service.markAsTaken('rem-1');

      verify(mockStorage.saveAdherenceRecord(any)).called(1);
    });

    test('throws when reminder not found', () async {
      when(
        mockStorage.getReminder('nonexistent'),
      ).thenAnswer((_) async => null);

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

      when(mockStorage.getReminder('rem-2')).thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});
      when(mockStorage.saveAdherenceRecord(any)).thenAnswer((_) async {});

      final updated = await service.markAsSkipped('rem-2');

      expect(updated.status, ReminderStatus.skipped);
      verify(mockStorage.saveAdherenceRecord(any)).called(1);
    });

    test('throws when reminder not found', () async {
      when(
        mockStorage.getReminder('nonexistent'),
      ).thenAnswer((_) async => null);

      expect(
        () => service.markAsSkipped('nonexistent'),
        throwsA(isA<Exception>()),
      );
    });

    test('sets actionTime when marking as skipped', () async {
      final reminder = makeReminder(
        id: 'rem-2',
        medicationId: 'med-1',
        scheduledTime: DateTime(2024, 3, 15, 8, 0),
      );

      when(mockStorage.getReminder('rem-2')).thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});
      when(mockStorage.saveAdherenceRecord(any)).thenAnswer((_) async {});

      final updated = await service.markAsSkipped('rem-2');

      expect(updated.actionTime, isNotNull);
    });

    test('saves the updated reminder', () async {
      final reminder = makeReminder(
        id: 'rem-2',
        medicationId: 'med-1',
        scheduledTime: DateTime(2024, 3, 15, 8, 0),
      );

      when(mockStorage.getReminder('rem-2')).thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});
      when(mockStorage.saveAdherenceRecord(any)).thenAnswer((_) async {});

      await service.markAsSkipped('rem-2');

      verify(mockStorage.saveReminder(any)).called(1);
    });
  });

  // ─── snooze ───────────────────────────────────────────────────────────────

  group('snooze', () {
    test('updates status to snoozed', () async {
      final reminder = makeReminder(
        id: 'rem-snz',
        medicationId: 'med-1',
        scheduledTime: DateTime(2024, 3, 15, 8, 0),
      );

      when(
        mockStorage.getReminder('rem-snz'),
      ).thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final updated = await service.snooze('rem-snz');

      expect(updated.status, ReminderStatus.snoozed);
    });

    test('sets snoozedUntil with default 15 minutes', () async {
      final reminder = makeReminder(
        id: 'rem-snz',
        medicationId: 'med-1',
        scheduledTime: DateTime(2024, 3, 15, 8, 0),
      );

      when(
        mockStorage.getReminder('rem-snz'),
      ).thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final before = DateTime.now();
      final updated = await service.snooze('rem-snz');
      final after = DateTime.now();

      expect(updated.snoozedUntil, isNotNull);
      // snoozedUntil should be approximately now + 15 minutes
      expect(
        updated.snoozedUntil!.isAfter(before.add(const Duration(minutes: 14))),
        isTrue,
      );
      expect(
        updated.snoozedUntil!.isBefore(after.add(const Duration(minutes: 16))),
        isTrue,
      );
    });

    test('sets snoozedUntil with custom duration', () async {
      final reminder = makeReminder(
        id: 'rem-snz',
        medicationId: 'med-1',
        scheduledTime: DateTime(2024, 3, 15, 8, 0),
      );

      when(
        mockStorage.getReminder('rem-snz'),
      ).thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final before = DateTime.now();
      final updated = await service.snooze(
        'rem-snz',
        duration: const Duration(minutes: 30),
      );

      expect(updated.snoozedUntil, isNotNull);
      expect(
        updated.snoozedUntil!.isAfter(before.add(const Duration(minutes: 29))),
        isTrue,
      );
    });

    test('saves the snoozed reminder', () async {
      final reminder = makeReminder(
        id: 'rem-snz',
        medicationId: 'med-1',
        scheduledTime: DateTime(2024, 3, 15, 8, 0),
      );

      when(
        mockStorage.getReminder('rem-snz'),
      ).thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      await service.snooze('rem-snz');

      verify(mockStorage.saveReminder(any)).called(1);
    });

    test('throws when reminder not found', () async {
      when(
        mockStorage.getReminder('nonexistent'),
      ).thenAnswer((_) async => null);

      expect(() => service.snooze('nonexistent'), throwsA(isA<Exception>()));
    });
  });

  // ─── checkAndMarkMissed ───────────────────────────────────────────────────

  group('checkAndMarkMissed', () {
    test('marks pending reminders as missed after 60 minutes', () async {
      final now = DateTime.now();
      final oldReminder = makeReminder(
        id: 'rem-old',
        medicationId: 'med-1',
        scheduledTime: now.subtract(const Duration(minutes: 61)),
      );

      when(
        mockStorage.getRemindersForDate(any),
      ).thenAnswer((_) async => [oldReminder]);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});
      when(mockStorage.saveAdherenceRecord(any)).thenAnswer((_) async {});

      final result = await service.checkAndMarkMissed();

      expect(result.length, 1);
      expect(result.first.status, ReminderStatus.missed);
      verify(mockStorage.saveReminder(any)).called(1);
      verify(mockStorage.saveAdherenceRecord(any)).called(1);
    });

    test('does not mark pending reminders within 60 minutes', () async {
      final now = DateTime.now();
      final recentReminder = makeReminder(
        id: 'rem-recent',
        medicationId: 'med-1',
        scheduledTime: now.subtract(const Duration(minutes: 30)),
      );

      when(
        mockStorage.getRemindersForDate(any),
      ).thenAnswer((_) async => [recentReminder]);

      final result = await service.checkAndMarkMissed();

      expect(result.isEmpty, isTrue);
      verifyNever(mockStorage.saveReminder(any));
    });

    test('does not mark already-taken reminders as missed', () async {
      final now = DateTime.now();
      final takenReminder = Reminder(
        id: 'rem-taken',
        medicationId: 'med-1',
        scheduledTime: now.subtract(const Duration(minutes: 120)),
        status: ReminderStatus.taken,
        actionTime: now.subtract(const Duration(minutes: 100)),
      );

      when(
        mockStorage.getRemindersForDate(any),
      ).thenAnswer((_) async => [takenReminder]);

      final result = await service.checkAndMarkMissed();

      expect(result.isEmpty, isTrue);
      verifyNever(mockStorage.saveReminder(any));
    });

    test('does not mark snoozed reminders as missed', () async {
      final now = DateTime.now();
      final snoozedReminder = Reminder(
        id: 'rem-snz',
        medicationId: 'med-1',
        scheduledTime: now.subtract(const Duration(minutes: 120)),
        status: ReminderStatus.snoozed,
        snoozedUntil: now.add(const Duration(minutes: 5)),
      );

      when(
        mockStorage.getRemindersForDate(any),
      ).thenAnswer((_) async => [snoozedReminder]);

      final result = await service.checkAndMarkMissed();

      expect(result.isEmpty, isTrue);
      verifyNever(mockStorage.saveReminder(any));
    });

    test('handles multiple reminders, only marks eligible ones', () async {
      final now = DateTime.now();
      final oldPending = makeReminder(
        id: 'rem-old',
        medicationId: 'med-1',
        scheduledTime: now.subtract(const Duration(minutes: 90)),
      );
      final recentPending = makeReminder(
        id: 'rem-recent',
        medicationId: 'med-2',
        scheduledTime: now.subtract(const Duration(minutes: 30)),
      );

      when(
        mockStorage.getRemindersForDate(any),
      ).thenAnswer((_) async => [oldPending, recentPending]);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});
      when(mockStorage.saveAdherenceRecord(any)).thenAnswer((_) async {});

      final result = await service.checkAndMarkMissed();

      expect(result.length, 1);
      expect(result.first.id, isNot('rem-recent'));
    });

    test('returns empty list when no reminders exist', () async {
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);

      final result = await service.checkAndMarkMissed();

      expect(result.isEmpty, isTrue);
    });

    test('sets actionTime on missed reminders', () async {
      final now = DateTime.now();
      final oldReminder = makeReminder(
        id: 'rem-old',
        medicationId: 'med-1',
        scheduledTime: now.subtract(const Duration(minutes: 120)),
      );

      when(
        mockStorage.getRemindersForDate(any),
      ).thenAnswer((_) async => [oldReminder]);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});
      when(mockStorage.saveAdherenceRecord(any)).thenAnswer((_) async {});

      final result = await service.checkAndMarkMissed();

      expect(result.first.actionTime, isNotNull);
    });
  });

  // ─── getNextReminderTime ──────────────────────────────────────────────────

  group('getNextReminderTime', () {
    test('returns null when no pending or snoozed reminders', () async {
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);

      final result = await service.getNextReminderTime();

      expect(result, isNull);
    });

    test('returns null when all reminders are taken or missed', () async {
      final now = DateTime.now();
      final takenReminder = Reminder(
        id: 'rem-taken',
        medicationId: 'med-1',
        scheduledTime: now.add(const Duration(hours: 1)),
        status: ReminderStatus.taken,
        actionTime: now,
      );
      final missedReminder = Reminder(
        id: 'rem-missed',
        medicationId: 'med-2',
        scheduledTime: now.subtract(const Duration(hours: 2)),
        status: ReminderStatus.missed,
        actionTime: now.subtract(const Duration(hours: 1)),
      );

      when(
        mockStorage.getRemindersForDate(any),
      ).thenAnswer((_) async => [takenReminder, missedReminder]);

      final result = await service.getNextReminderTime();

      expect(result, isNull);
    });

    test('returns scheduledTime of earliest pending reminder', () async {
      final now = DateTime.now();
      final early = now.add(const Duration(hours: 1));
      final late_ = now.add(const Duration(hours: 3));

      final earlyReminder = makeReminder(
        id: 'rem-early',
        medicationId: 'med-1',
        scheduledTime: early,
      );
      final lateReminder = makeReminder(
        id: 'rem-late',
        medicationId: 'med-2',
        scheduledTime: late_,
      );

      when(
        mockStorage.getRemindersForDate(any),
      ).thenAnswer((_) async => [lateReminder, earlyReminder]);

      final result = await service.getNextReminderTime();

      expect(result, equals(early));
    });

    test(
      'returns snoozedUntil for snoozed reminders instead of scheduledTime',
      () async {
        final now = DateTime.now();
        final snoozedUntil = now.add(const Duration(minutes: 10));

        final snoozedReminder = Reminder(
          id: 'rem-snz',
          medicationId: 'med-1',
          scheduledTime: now.subtract(const Duration(hours: 1)),
          status: ReminderStatus.snoozed,
          snoozedUntil: snoozedUntil,
        );

        when(
          mockStorage.getRemindersForDate(any),
        ).thenAnswer((_) async => [snoozedReminder]);

        final result = await service.getNextReminderTime();

        expect(result, equals(snoozedUntil));
      },
    );

    test(
      'picks snoozed reminder if its snoozedUntil is earlier than pending scheduledTime',
      () async {
        final now = DateTime.now();
        final snoozedUntil = now.add(const Duration(minutes: 5));
        final pendingTime = now.add(const Duration(hours: 2));

        final snoozedReminder = Reminder(
          id: 'rem-snz',
          medicationId: 'med-1',
          scheduledTime: now.subtract(const Duration(hours: 1)),
          status: ReminderStatus.snoozed,
          snoozedUntil: snoozedUntil,
        );
        final pendingReminder = makeReminder(
          id: 'rem-pending',
          medicationId: 'med-2',
          scheduledTime: pendingTime,
        );

        when(
          mockStorage.getRemindersForDate(any),
        ).thenAnswer((_) async => [pendingReminder, snoozedReminder]);

        final result = await service.getNextReminderTime();

        expect(result, equals(snoozedUntil));
      },
    );

    test(
      'picks pending reminder if its scheduledTime is earlier than snoozedUntil',
      () async {
        final now = DateTime.now();
        final snoozedUntil = now.add(const Duration(hours: 2));
        final pendingTime = now.add(const Duration(minutes: 5));

        final snoozedReminder = Reminder(
          id: 'rem-snz',
          medicationId: 'med-1',
          scheduledTime: now.subtract(const Duration(hours: 1)),
          status: ReminderStatus.snoozed,
          snoozedUntil: snoozedUntil,
        );
        final pendingReminder = makeReminder(
          id: 'rem-pending',
          medicationId: 'med-2',
          scheduledTime: pendingTime,
        );

        when(
          mockStorage.getRemindersForDate(any),
        ).thenAnswer((_) async => [snoozedReminder, pendingReminder]);

        final result = await service.getNextReminderTime();

        expect(result, equals(pendingTime));
      },
    );
  });

  // ─── generateRemindersForDate — multiple schedules ────────────────────────

  group('generateRemindersForDate — multiple schedules', () {
    test('generates reminders for multiple active schedules', () async {
      final date = DateTime(2024, 3, 15);

      final schedule1 = makeSchedule(
        id: 'sched-1',
        medicationId: 'med-1',
        type: ScheduleType.daily,
        times: ['08:00'],
      );
      final schedule2 = makeSchedule(
        id: 'sched-2',
        medicationId: 'med-2',
        type: ScheduleType.daily,
        times: ['12:00'],
      );

      when(mockStorage.getRemindersForDate(date)).thenAnswer((_) async => []);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final result = await service.generateRemindersForDate([
        schedule1,
        schedule2,
      ], date);

      expect(result.length, 2);
      expect(
        result.map((r) => r.medicationId).toSet(),
        containsAll(['med-1', 'med-2']),
      );
      verify(mockStorage.saveReminder(any)).called(2);
    });

    test('handles empty schedule list', () async {
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);

      final result = await service.generateRemindersForDate(
        [],
        DateTime(2024, 3, 15),
      );

      expect(result.isEmpty, isTrue);
    });

    test('mixes active and inactive schedules correctly', () async {
      final date = DateTime(2024, 3, 15);
      final activeSchedule = makeSchedule(
        id: 'sched-active',
        medicationId: 'med-1',
        type: ScheduleType.daily,
        times: ['08:00'],
        isActive: true,
      );
      final inactiveSchedule = makeSchedule(
        id: 'sched-inactive',
        medicationId: 'med-2',
        type: ScheduleType.daily,
        times: ['12:00'],
        isActive: false,
      );

      when(mockStorage.getRemindersForDate(date)).thenAnswer((_) async => []);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final result = await service.generateRemindersForDate([
        activeSchedule,
        inactiveSchedule,
      ], date);

      expect(result.length, 1);
      expect(result.first.medicationId, 'med-1');
    });
  });

  // ─── generateRemindersForDate — deduplication ──────────────────────────────

  group('generateRemindersForDate — deduplication', () {
    test('detects duplicate by medicationId + hour + minute', () async {
      final date = DateTime(2024, 3, 15);
      final schedule = makeSchedule(
        type: ScheduleType.daily,
        times: ['08:00'],
      );

      // Existing reminder with slightly different seconds (simulating
      // DateTime serialization precision difference)
      final existingReminder = makeReminder(
        id: 'rem-existing',
        medicationId: 'med-1',
        scheduledTime: DateTime(2024, 3, 15, 8, 0, 1),
      );

      when(
        mockStorage.getRemindersForDate(date),
      ).thenAnswer((_) async => [existingReminder]);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final result =
          await service.generateRemindersForDate([schedule], date);

      // Should NOT create a new reminder — same med + same hour:minute
      expect(result.length, 1);
      expect(result.first.id, 'rem-existing');
      verifyNever(mockStorage.saveReminder(any));
    });

    test('allows same time for different medications', () async {
      final date = DateTime(2024, 3, 15);
      final schedule1 = makeSchedule(
        id: 'sched-1',
        medicationId: 'med-1',
        type: ScheduleType.daily,
        times: ['08:00'],
      );
      final schedule2 = makeSchedule(
        id: 'sched-2',
        medicationId: 'med-2',
        type: ScheduleType.daily,
        times: ['08:00'],
      );

      final existingReminder = makeReminder(
        id: 'rem-existing',
        medicationId: 'med-1',
        scheduledTime: DateTime(2024, 3, 15, 8, 0),
      );

      when(
        mockStorage.getRemindersForDate(date),
      ).thenAnswer((_) async => [existingReminder]);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final result = await service.generateRemindersForDate(
        [schedule1, schedule2],
        date,
      );

      // med-1 already exists, med-2 should be created
      expect(result.length, 2);
      verify(mockStorage.saveReminder(any)).called(1);
    });
  });

  // ─── _shouldGenerateForDate — interval edge cases ─────────────────────────

  group('_shouldGenerateForDate — interval advanced', () {
    test('intervalHours=24 generates every day', () async {
      final schedule = makeSchedule(
        type: ScheduleType.interval,
        intervalHours: 24,
      );

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      // intervalDays = ceil(24/24) = 1 → every day
      final day1 = await service.generateRemindersForDate([
        schedule,
      ], DateTime(2024, 6, 1));
      final day2 = await service.generateRemindersForDate([
        schedule,
      ], DateTime(2024, 6, 2));

      expect(day1.length, 1);
      expect(day2.length, 1);
    });

    test('intervalHours=72 generates every 3 days', () async {
      final schedule = makeSchedule(
        type: ScheduleType.interval,
        intervalHours: 72,
      );

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      // intervalDays = ceil(72/24) = 3
      // daysSinceEpoch for each date, check modulo 3
      int generatedCount = 0;
      for (var i = 0; i < 6; i++) {
        final date = DateTime(2024, 1, 1 + i);
        final result = await service.generateRemindersForDate([schedule], date);
        generatedCount += result.length;
      }

      // In 6 consecutive days with interval 3, exactly 2 should generate
      expect(generatedCount, 2);
    });

    test('intervalHours=36 rounds up to 2-day cycle', () async {
      final schedule = makeSchedule(
        type: ScheduleType.interval,
        intervalHours: 36,
      );

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      // intervalDays = ceil(36/24) = 2
      int generatedCount = 0;
      for (var i = 0; i < 4; i++) {
        final date = DateTime(2024, 1, 1 + i);
        final result = await service.generateRemindersForDate([schedule], date);
        generatedCount += result.length;
      }

      // In 4 consecutive days with interval 2, exactly 2 should generate
      expect(generatedCount, 2);
    });

    test('negative intervalHours treated as generate every day', () async {
      final schedule = makeSchedule(
        type: ScheduleType.interval,
        intervalHours: -5,
      );

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final result = await service.generateRemindersForDate([
        schedule,
      ], DateTime(2024, 6, 15));
      expect(result.length, 1);
    });
  });
}
