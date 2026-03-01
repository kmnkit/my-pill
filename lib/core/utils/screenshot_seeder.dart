import 'package:flutter/foundation.dart';
import 'package:kusuridoki/data/enums/dosage_unit.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/data/enums/reminder_status.dart';
import 'package:kusuridoki/data/enums/dosage_timing.dart';
import 'package:kusuridoki/data/enums/schedule_type.dart';
import 'package:kusuridoki/data/enums/timezone_mode.dart';
import 'package:kusuridoki/data/models/dosage_time_slot.dart';
import 'package:kusuridoki/data/models/adherence_record.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/data/models/reminder.dart';
import 'package:kusuridoki/data/models/schedule.dart';
import 'package:kusuridoki/data/models/user_profile.dart';
import 'package:kusuridoki/data/services/storage_service.dart';

/// Debug-only screenshot data seeder.
///
/// Creates realistic Japanese-market medication data for App Store screenshots.
/// Accessible via Settings > Debug Tools > Seed Screenshot Data (debug builds only).
class ScreenshotSeeder {
  final StorageService _storage;

  ScreenshotSeeder(this._storage);

  // ── Medication IDs ───────────────────────────────────────
  static const _medIppokaMorning = 'seed-ippoka-morning';
  static const _medAmlodipine = 'seed-amlodipine';
  static const _medGaster = 'seed-gaster';
  static const _medVitaminD = 'seed-vitamin-d';
  static const _medAllegra = 'seed-allegra';

  /// Clear all existing data, then seed fresh screenshot data.
  /// Only runs in debug mode.
  Future<void> clearAndSeed() async {
    if (!kDebugMode) return;

    await _clearAllData();
    await seed();

    debugPrint('[ScreenshotSeeder] Clear + seed complete');
  }

  /// Seed screenshot data (without clearing first).
  /// Only runs in debug mode.
  Future<void> seed() async {
    if (!kDebugMode) return;

    final now = DateTime.now();

    await _seedUserProfile();

    final meds = _buildMedications(now);
    for (final med in meds) {
      await _storage.saveMedication(med);
    }

    final schedules = _buildSchedules(meds);
    for (final s in schedules) {
      await _storage.saveSchedule(s);
    }

    final reminders = _buildTodayReminders(meds, now);
    for (final r in reminders) {
      await _storage.saveReminder(r);
    }

    final records = _buildAdherenceRecords(meds, now);
    for (final r in records) {
      await _storage.saveAdherenceRecord(r);
    }

    debugPrint(
      '[ScreenshotSeeder] Seeded: ${meds.length} medications, '
      '${schedules.length} schedules, ${reminders.length} reminders, '
      '${records.length} adherence records',
    );
  }

  // ── Clear ────────────────────────────────────────────────

  Future<void> _clearAllData() async {
    final meds = await _storage.getAllMedications();
    for (final med in meds) {
      await _storage.deleteRemindersForMedication(med.id);
      await _storage.deleteAdherenceRecordsForMedication(med.id);
      await _storage.deleteMedication(med.id);
    }

    final schedules = await _storage.getAllSchedules();
    for (final s in schedules) {
      await _storage.deleteSchedule(s.id);
    }

    debugPrint(
      '[ScreenshotSeeder] Cleared ${meds.length} medications, '
      '${schedules.length} schedules',
    );
  }

  // ── User Profile ─────────────────────────────────────────

  Future<void> _seedUserProfile() async {
    const profile = UserProfile(
      id: 'seed-user',
      name: 'ゆき',
      language: 'ja',
      notificationsEnabled: true,
      criticalAlerts: true,
      snoozeDuration: 10,
      travelModeEnabled: false,
      removeAds: true,
      onboardingComplete: true,
      userRole: 'patient',
      shareAdherenceData: true,
      shareMedicationList: true,
      lowStockAlerts: true,
      missedDoseAlerts: true,
    );
    await _storage.saveUserProfile(profile);
  }

  // ── Medications ──────────────────────────────────────────

  List<Medication> _buildMedications(DateTime now) {
    return [
      // 1) 朝のおくすり — 一包化 (morning dose pack)
      Medication(
        id: _medIppokaMorning,
        name: '朝のおくすり',
        dosage: 1,
        dosageUnit: DosageUnit.packs,
        shape: PillShape.packet,
        color: PillColor.white,
        inventoryTotal: 30,
        inventoryRemaining: 23,
        isCritical: true,
        isIppoka: true,
        createdAt: now.subtract(const Duration(days: 90)),
      ),
      // 2) アムロジピン — 血圧 (blood pressure, round white)
      Medication(
        id: _medAmlodipine,
        name: 'アムロジピン',
        dosage: 5,
        dosageUnit: DosageUnit.mg,
        shape: PillShape.round,
        color: PillColor.white,
        inventoryTotal: 30,
        inventoryRemaining: 4,
        lowStockThreshold: 5,
        isCritical: true,
        createdAt: now.subtract(const Duration(days: 120)),
      ),
      // 3) ガスター — 胃薬 (stomach, oval pink)
      Medication(
        id: _medGaster,
        name: 'ガスター',
        dosage: 20,
        dosageUnit: DosageUnit.mg,
        shape: PillShape.oval,
        color: PillColor.pink,
        inventoryTotal: 30,
        inventoryRemaining: 18,
        createdAt: now.subtract(const Duration(days: 60)),
      ),
      // 4) ビタミンD — サプリ (supplement, capsule yellow)
      Medication(
        id: _medVitaminD,
        name: 'ビタミンD',
        dosage: 2000,
        dosageUnit: DosageUnit.units,
        shape: PillShape.capsule,
        color: PillColor.yellow,
        inventoryTotal: 90,
        inventoryRemaining: 68,
        createdAt: now.subtract(const Duration(days: 45)),
      ),
      // 5) アレグラ — アレルギー (allergy, oval blue)
      Medication(
        id: _medAllegra,
        name: 'アレグラ',
        dosage: 60,
        dosageUnit: DosageUnit.mg,
        shape: PillShape.oval,
        color: PillColor.blue,
        inventoryTotal: 30,
        inventoryRemaining: 15,
        createdAt: now.subtract(const Duration(days: 30)),
      ),
    ];
  }

  // ── Schedules ────────────────────────────────────────────

  List<Schedule> _buildSchedules(List<Medication> meds) {
    return [
      // 朝のおくすり: 毎日 08:00
      Schedule(
        id: 'seed-sch-ippoka',
        medicationId: meds[0].id,
        type: ScheduleType.daily,
        dosageSlots: const [
          DosageTimeSlot(timing: DosageTiming.morning, time: '08:00'),
        ],
        timezoneMode: TimezoneMode.fixedInterval,
      ),
      // アムロジピン: 毎日 08:00 + 20:00 (朝夕)
      Schedule(
        id: 'seed-sch-amlodipine',
        medicationId: meds[1].id,
        type: ScheduleType.daily,
        dosageSlots: const [
          DosageTimeSlot(timing: DosageTiming.morning, time: '08:00'),
          DosageTimeSlot(timing: DosageTiming.evening, time: '20:00'),
        ],
        timezoneMode: TimezoneMode.fixedInterval,
      ),
      // ガスター: 毎日 07:30 (朝食前)
      Schedule(
        id: 'seed-sch-gaster',
        medicationId: meds[2].id,
        type: ScheduleType.daily,
        dosageSlots: const [
          DosageTimeSlot(timing: DosageTiming.morning, time: '07:30'),
        ],
        timezoneMode: TimezoneMode.fixedInterval,
      ),
      // ビタミンD: 毎日 12:00 (昼)
      Schedule(
        id: 'seed-sch-vitamind',
        medicationId: meds[3].id,
        type: ScheduleType.daily,
        dosageSlots: const [
          DosageTimeSlot(timing: DosageTiming.noon, time: '12:00'),
        ],
        timezoneMode: TimezoneMode.localTime,
      ),
      // アレグラ: 毎日 21:00 (就寝前)
      Schedule(
        id: 'seed-sch-allegra',
        medicationId: meds[4].id,
        type: ScheduleType.daily,
        dosageSlots: const [
          DosageTimeSlot(timing: DosageTiming.bedtime, time: '21:00'),
        ],
        timezoneMode: TimezoneMode.fixedInterval,
      ),
    ];
  }

  // ── Reminders (today — mixed statuses for timeline screenshot) ──

  List<Reminder> _buildTodayReminders(List<Medication> meds, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);

    return [
      // 07:30 ガスター — taken ✓
      Reminder(
        id: 'seed-rem-gaster',
        medicationId: meds[2].id,
        scheduledTime: today.add(const Duration(hours: 7, minutes: 30)),
        status: ReminderStatus.taken,
        actionTime: today.add(const Duration(hours: 7, minutes: 32)),
      ),
      // 08:00 朝のおくすり — taken ✓
      Reminder(
        id: 'seed-rem-ippoka',
        medicationId: meds[0].id,
        scheduledTime: today.add(const Duration(hours: 8)),
        status: ReminderStatus.taken,
        actionTime: today.add(const Duration(hours: 8, minutes: 1)),
      ),
      // 08:00 アムロジピン(朝) — taken ✓
      Reminder(
        id: 'seed-rem-amlo-am',
        medicationId: meds[1].id,
        scheduledTime: today.add(const Duration(hours: 8)),
        status: ReminderStatus.taken,
        actionTime: today.add(const Duration(hours: 8, minutes: 3)),
      ),
      // 12:00 ビタミンD — pending (next up)
      Reminder(
        id: 'seed-rem-vitd',
        medicationId: meds[3].id,
        scheduledTime: today.add(const Duration(hours: 12)),
        status: ReminderStatus.pending,
      ),
      // 20:00 アムロジピン(夕) — pending
      Reminder(
        id: 'seed-rem-amlo-pm',
        medicationId: meds[1].id,
        scheduledTime: today.add(const Duration(hours: 20)),
        status: ReminderStatus.pending,
      ),
      // 21:00 アレグラ — pending
      Reminder(
        id: 'seed-rem-allegra',
        medicationId: meds[4].id,
        scheduledTime: today.add(const Duration(hours: 21)),
        status: ReminderStatus.pending,
      ),
    ];
  }

  // ── Adherence records (14 days, ~87% adherence) ──────────

  List<AdherenceRecord> _buildAdherenceRecords(
    List<Medication> meds,
    DateTime now,
  ) {
    final today = DateTime(now.year, now.month, now.day);
    final records = <AdherenceRecord>[];

    // Schedule: medIndex → list of (hour, minute) pairs
    final medSchedules = <int, List<(int, int)>>{
      0: [(8, 0)], // 朝のおくすり
      1: [(8, 0), (20, 0)], // アムロジピン (朝夕)
      2: [(7, 30)], // ガスター
      3: [(12, 0)], // ビタミンD
      4: [(21, 0)], // アレグラ
    };

    var idx = 0;
    for (var dayOffset = 14; dayOffset >= 1; dayOffset--) {
      final day = today.subtract(Duration(days: dayOffset));

      for (final entry in medSchedules.entries) {
        final medIdx = entry.key;
        final times = entry.value;

        for (final (hour, minute) in times) {
          final scheduled = day.add(Duration(hours: hour, minutes: minute));

          // Deterministic pattern: ~87% taken, ~9% skipped, ~4% missed
          // Critical meds (index 0,1) almost never missed
          final hash = (idx * 7 + dayOffset * 13 + medIdx * 3) % 23;
          ReminderStatus status;
          DateTime? actionTime;

          if (medIdx <= 1) {
            // Critical meds: 95% taken
            if (hash < 21) {
              status = ReminderStatus.taken;
              actionTime = scheduled.add(Duration(minutes: hash % 8));
            } else if (hash < 22) {
              status = ReminderStatus.skipped;
            } else {
              status = ReminderStatus.missed;
            }
          } else {
            // Non-critical: 83% taken
            if (hash < 19) {
              status = ReminderStatus.taken;
              actionTime = scheduled.add(Duration(minutes: hash % 12));
            } else if (hash < 21) {
              status = ReminderStatus.skipped;
            } else {
              status = ReminderStatus.missed;
            }
          }

          records.add(
            AdherenceRecord(
              id: 'seed-adh-$idx',
              medicationId: meds[medIdx].id,
              date: day,
              status: status,
              scheduledTime: scheduled,
              actionTime: actionTime,
            ),
          );
          idx++;
        }
      }
    }

    // Today's already-taken records (morning meds)
    final todayTaken = [
      AdherenceRecord(
        id: 'seed-adh-today-gaster',
        medicationId: meds[2].id,
        date: today,
        status: ReminderStatus.taken,
        scheduledTime: today.add(const Duration(hours: 7, minutes: 30)),
        actionTime: today.add(const Duration(hours: 7, minutes: 32)),
      ),
      AdherenceRecord(
        id: 'seed-adh-today-ippoka',
        medicationId: meds[0].id,
        date: today,
        status: ReminderStatus.taken,
        scheduledTime: today.add(const Duration(hours: 8)),
        actionTime: today.add(const Duration(hours: 8, minutes: 1)),
      ),
      AdherenceRecord(
        id: 'seed-adh-today-amlo',
        medicationId: meds[1].id,
        date: today,
        status: ReminderStatus.taken,
        scheduledTime: today.add(const Duration(hours: 8)),
        actionTime: today.add(const Duration(hours: 8, minutes: 3)),
      ),
    ];

    records.addAll(todayTaken);
    return records;
  }
}
