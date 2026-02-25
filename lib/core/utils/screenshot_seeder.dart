import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:my_pill/data/enums/dosage_unit.dart';
import 'package:my_pill/data/enums/pill_color.dart';
import 'package:my_pill/data/enums/pill_shape.dart';
import 'package:my_pill/data/enums/reminder_status.dart';
import 'package:my_pill/data/enums/dosage_timing.dart';
import 'package:my_pill/data/enums/schedule_type.dart';
import 'package:my_pill/data/enums/timezone_mode.dart';
import 'package:my_pill/data/models/dosage_time_slot.dart';
import 'package:my_pill/data/models/adherence_record.dart';
import 'package:my_pill/data/models/medication.dart';
import 'package:my_pill/data/models/reminder.dart';
import 'package:my_pill/data/models/schedule.dart';
import 'package:my_pill/data/services/storage_service.dart';

/// Debug-only screenshot data seeder.
/// Creates realistic medication, schedule, reminder, and adherence data
/// for App Store screenshot capture.
class ScreenshotSeeder {
  final StorageService _storage;
  static const _uuid = Uuid();

  ScreenshotSeeder(this._storage);

  /// Seed all data for screenshot capture. Only runs in debug mode.
  Future<void> seed() async {
    if (!kDebugMode) return;

    final now = DateTime.now();

    // --- Medications ---
    final meds = _buildMedications(now);
    for (final med in meds) {
      await _storage.saveMedication(med);
    }

    // --- Schedules ---
    final schedules = _buildSchedules(meds);
    for (final s in schedules) {
      await _storage.saveSchedule(s);
    }

    // --- Reminders (today) ---
    final reminders = _buildTodayReminders(meds, now);
    for (final r in reminders) {
      await _storage.saveReminder(r);
    }

    // --- Adherence records (past 7 days) ---
    final records = _buildAdherenceRecords(meds, now);
    for (final r in records) {
      await _storage.saveAdherenceRecord(r);
    }

    debugPrint('[ScreenshotSeeder] Seeded ${meds.length} medications, '
        '${schedules.length} schedules, ${reminders.length} reminders, '
        '${records.length} adherence records');
  }

  // ── Medications ────────────────────────────────────────

  List<Medication> _buildMedications(DateTime now) {
    return [
      // 1) 一包化 — 朝の薬 (morning dose pack)
      Medication(
        id: 'seed-med-ippoka-morning',
        name: '朝の薬',
        dosage: 1,
        dosageUnit: DosageUnit.packs,
        shape: PillShape.packet,
        color: PillColor.white,
        inventoryTotal: 30,
        inventoryRemaining: 22,
        isCritical: true,
        isIppoka: true,
        createdAt: now.subtract(const Duration(days: 14)),
      ),
      // 2) Amlodipine — 血圧の薬 (capsule, blue)
      Medication(
        id: 'seed-med-amlodipine',
        name: 'Amlodipine',
        dosage: 5,
        dosageUnit: DosageUnit.mg,
        shape: PillShape.capsule,
        color: PillColor.blue,
        inventoryTotal: 30,
        inventoryRemaining: 4, // low stock!
        lowStockThreshold: 5,
        isCritical: true,
        createdAt: now.subtract(const Duration(days: 30)),
      ),
      // 3) Vitamin D — サプリ (round, yellow)
      Medication(
        id: 'seed-med-vitamind',
        name: 'Vitamin D',
        dosage: 1000,
        dosageUnit: DosageUnit.units,
        shape: PillShape.round,
        color: PillColor.yellow,
        inventoryTotal: 60,
        inventoryRemaining: 45,
        createdAt: now.subtract(const Duration(days: 20)),
      ),
    ];
  }

  // ── Schedules ──────────────────────────────────────────

  List<Schedule> _buildSchedules(List<Medication> meds) {
    return [
      // 朝の薬: daily 08:00
      Schedule(
        id: 'seed-sch-ippoka',
        medicationId: meds[0].id,
        type: ScheduleType.daily,
        dosageSlots: [DosageTimeSlot(timing: DosageTiming.morning, time: '08:00')],
        timezoneMode: TimezoneMode.fixedInterval,
      ),
      // Amlodipine: daily 09:00, 21:00
      Schedule(
        id: 'seed-sch-amlodipine',
        medicationId: meds[1].id,
        type: ScheduleType.daily,
        dosageSlots: [
          DosageTimeSlot(timing: DosageTiming.morning, time: '09:00'),
          DosageTimeSlot(timing: DosageTiming.evening, time: '21:00'),
        ],
        timezoneMode: TimezoneMode.fixedInterval,
      ),
      // Vitamin D: daily 12:00
      Schedule(
        id: 'seed-sch-vitamind',
        medicationId: meds[2].id,
        type: ScheduleType.daily,
        dosageSlots: [DosageTimeSlot(timing: DosageTiming.noon, time: '12:00')],
        timezoneMode: TimezoneMode.localTime,
      ),
    ];
  }

  // ── Reminders (today — mixed statuses for timeline) ────

  List<Reminder> _buildTodayReminders(List<Medication> meds, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return [
      // 朝の薬 08:00 — taken
      Reminder(
        id: 'seed-rem-ippoka-am',
        medicationId: meds[0].id,
        scheduledTime: today.add(const Duration(hours: 8)),
        status: ReminderStatus.taken,
        actionTime: today.add(const Duration(hours: 8, minutes: 5)),
      ),
      // Amlodipine 09:00 — taken
      Reminder(
        id: 'seed-rem-amlo-am',
        medicationId: meds[1].id,
        scheduledTime: today.add(const Duration(hours: 9)),
        status: ReminderStatus.taken,
        actionTime: today.add(const Duration(hours: 9, minutes: 12)),
      ),
      // Vitamin D 12:00 — pending (next up)
      Reminder(
        id: 'seed-rem-vitd-noon',
        medicationId: meds[2].id,
        scheduledTime: today.add(const Duration(hours: 12)),
        status: ReminderStatus.pending,
      ),
      // Amlodipine 21:00 — pending
      Reminder(
        id: 'seed-rem-amlo-pm',
        medicationId: meds[1].id,
        scheduledTime: today.add(const Duration(hours: 21)),
        status: ReminderStatus.pending,
      ),
    ];
  }

  // ── Adherence records (7 days, ~85% rate) ──────────────

  List<AdherenceRecord> _buildAdherenceRecords(
    List<Medication> meds,
    DateTime now,
  ) {
    final records = <AdherenceRecord>[];

    // Pattern per day: mostly taken, occasional miss for realism
    // Day offsets: 1=yesterday ... 7=a week ago
    final patterns = <int, List<ReminderStatus>>{
      1: [ReminderStatus.taken, ReminderStatus.taken, ReminderStatus.taken],
      2: [ReminderStatus.taken, ReminderStatus.taken, ReminderStatus.taken],
      3: [ReminderStatus.taken, ReminderStatus.missed, ReminderStatus.taken],
      4: [ReminderStatus.taken, ReminderStatus.taken, ReminderStatus.taken],
      5: [ReminderStatus.taken, ReminderStatus.taken, ReminderStatus.skipped],
      6: [ReminderStatus.taken, ReminderStatus.taken, ReminderStatus.taken],
      7: [ReminderStatus.taken, ReminderStatus.taken, ReminderStatus.taken],
    };

    for (final entry in patterns.entries) {
      final dayOffset = entry.key;
      final statuses = entry.value;
      final date = DateTime(
        now.year,
        now.month,
        now.day - dayOffset,
      );

      for (var i = 0; i < statuses.length && i < meds.length; i++) {
        final scheduledHour = i == 0 ? 8 : (i == 1 ? 9 : 12);
        final scheduled = date.add(Duration(hours: scheduledHour));
        records.add(
          AdherenceRecord(
            id: _uuid.v4(),
            medicationId: meds[i].id,
            date: date,
            status: statuses[i],
            scheduledTime: scheduled,
            actionTime: statuses[i] == ReminderStatus.taken
                ? scheduled.add(Duration(minutes: 3 + i * 4))
                : null,
          ),
        );
      }
    }

    return records;
  }
}
