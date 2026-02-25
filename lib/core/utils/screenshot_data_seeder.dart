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
import 'package:my_pill/data/models/user_profile.dart';
import 'package:my_pill/data/services/storage_service.dart';

/// Seeds realistic sample data into StorageService for App Store screenshots.
///
/// Run with: `flutter run -t lib/main_screenshot.dart`
/// Remove after screenshots are taken.
class ScreenshotDataSeeder {
  final StorageService _storage;

  ScreenshotDataSeeder(this._storage);

  Future<void> seed() async {
    await _seedUserProfile();
    await _seedMedications();
    await _seedSchedules();
    await _seedReminders();
    await _seedAdherenceRecords();
  }

  // --- Medication IDs (shared across seed methods) ---
  static const _medAmlodipine = 'med-amlodipine';
  static const _medMetformin = 'med-metformin';
  static const _medVitaminD = 'med-vitamin-d';
  static const _medOmeprazole = 'med-omeprazole';
  static const _medIronSupplement = 'med-iron';
  static const _medAllergy = 'med-allergy';

  Future<void> _seedUserProfile() async {
    const profile = UserProfile(
      id: 'screenshot-user',
      name: 'Yuki',
      email: 'yuki@example.com',
      language: 'ja',
      highContrast: false,
      textSize: 'normal',
      notificationsEnabled: true,
      criticalAlerts: true,
      snoozeDuration: 15,
      travelModeEnabled: false,
      removeAds: true,
      onboardingComplete: true,
      userRole: 'patient',
    );
    await _storage.saveUserProfile(profile);
  }

  Future<void> _seedMedications() async {
    final now = DateTime.now();

    final medications = [
      Medication(
        id: _medAmlodipine,
        name: 'Amlodipine',
        dosage: 5,
        dosageUnit: DosageUnit.mg,
        shape: PillShape.round,
        color: PillColor.white,
        inventoryTotal: 30,
        inventoryRemaining: 22,
        lowStockThreshold: 5,
        isCritical: true,
        createdAt: now.subtract(const Duration(days: 60)),
      ),
      Medication(
        id: _medMetformin,
        name: 'Metformin',
        dosage: 500,
        dosageUnit: DosageUnit.mg,
        shape: PillShape.oval,
        color: PillColor.white,
        inventoryTotal: 60,
        inventoryRemaining: 45,
        lowStockThreshold: 10,
        isCritical: true,
        createdAt: now.subtract(const Duration(days: 45)),
      ),
      Medication(
        id: _medVitaminD,
        name: 'Vitamin D3',
        dosage: 2000,
        dosageUnit: DosageUnit.units,
        shape: PillShape.capsule,
        color: PillColor.yellow,
        inventoryTotal: 90,
        inventoryRemaining: 67,
        lowStockThreshold: 10,
        isCritical: false,
        createdAt: now.subtract(const Duration(days: 30)),
      ),
      Medication(
        id: _medOmeprazole,
        name: 'Omeprazole',
        dosage: 20,
        dosageUnit: DosageUnit.mg,
        shape: PillShape.capsule,
        color: PillColor.purple,
        inventoryTotal: 30,
        inventoryRemaining: 18,
        lowStockThreshold: 5,
        isCritical: false,
        createdAt: now.subtract(const Duration(days: 20)),
      ),
      Medication(
        id: _medIronSupplement,
        name: 'Iron Supplement',
        dosage: 65,
        dosageUnit: DosageUnit.mg,
        shape: PillShape.round,
        color: PillColor.green,
        inventoryTotal: 30,
        inventoryRemaining: 3,
        lowStockThreshold: 5,
        isCritical: false,
        createdAt: now.subtract(const Duration(days: 25)),
      ),
      Medication(
        id: _medAllergy,
        name: 'Cetirizine',
        dosage: 10,
        dosageUnit: DosageUnit.mg,
        shape: PillShape.oval,
        color: PillColor.blue,
        inventoryTotal: 30,
        inventoryRemaining: 15,
        lowStockThreshold: 5,
        isCritical: false,
        createdAt: now.subtract(const Duration(days: 14)),
      ),
    ];

    for (final med in medications) {
      await _storage.saveMedication(med);
    }
  }

  Future<void> _seedSchedules() async {
    final schedules = [
      // Amlodipine: daily morning
      const Schedule(
        id: 'sch-amlodipine',
        medicationId: _medAmlodipine,
        type: ScheduleType.daily,
        dosageSlots: [DosageTimeSlot(timing: DosageTiming.morning, time: '08:00')],
        timezoneMode: TimezoneMode.fixedInterval,
      ),
      // Metformin: daily morning + evening
      const Schedule(
        id: 'sch-metformin',
        medicationId: _medMetformin,
        type: ScheduleType.daily,
        dosageSlots: [
          DosageTimeSlot(timing: DosageTiming.morning, time: '08:00'),
          DosageTimeSlot(timing: DosageTiming.evening, time: '20:00'),
        ],
        timezoneMode: TimezoneMode.fixedInterval,
      ),
      // Vitamin D: daily morning
      const Schedule(
        id: 'sch-vitamin-d',
        medicationId: _medVitaminD,
        type: ScheduleType.daily,
        dosageSlots: [DosageTimeSlot(timing: DosageTiming.morning, time: '08:00')],
        timezoneMode: TimezoneMode.fixedInterval,
      ),
      // Omeprazole: daily before breakfast
      const Schedule(
        id: 'sch-omeprazole',
        medicationId: _medOmeprazole,
        type: ScheduleType.daily,
        dosageSlots: [DosageTimeSlot(timing: DosageTiming.morning, time: '07:30')],
        timezoneMode: TimezoneMode.fixedInterval,
      ),
      // Iron: daily afternoon
      const Schedule(
        id: 'sch-iron',
        medicationId: _medIronSupplement,
        type: ScheduleType.daily,
        dosageSlots: [DosageTimeSlot(timing: DosageTiming.noon, time: '13:00')],
        timezoneMode: TimezoneMode.fixedInterval,
      ),
      // Cetirizine: daily evening
      const Schedule(
        id: 'sch-allergy',
        medicationId: _medAllergy,
        type: ScheduleType.daily,
        dosageSlots: [DosageTimeSlot(timing: DosageTiming.evening, time: '21:00')],
        timezoneMode: TimezoneMode.fixedInterval,
      ),
    ];

    for (final schedule in schedules) {
      await _storage.saveSchedule(schedule);
    }
  }

  Future<void> _seedReminders() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final reminders = [
      // Morning meds — already taken
      Reminder(
        id: 'rem-omeprazole-today',
        medicationId: _medOmeprazole,
        scheduledTime: today.add(const Duration(hours: 7, minutes: 30)),
        status: ReminderStatus.taken,
        actionTime: today.add(const Duration(hours: 7, minutes: 33)),
      ),
      Reminder(
        id: 'rem-amlodipine-today',
        medicationId: _medAmlodipine,
        scheduledTime: today.add(const Duration(hours: 8)),
        status: ReminderStatus.taken,
        actionTime: today.add(const Duration(hours: 8, minutes: 2)),
      ),
      Reminder(
        id: 'rem-metformin-am-today',
        medicationId: _medMetformin,
        scheduledTime: today.add(const Duration(hours: 8)),
        status: ReminderStatus.taken,
        actionTime: today.add(const Duration(hours: 8, minutes: 2)),
      ),
      Reminder(
        id: 'rem-vitamin-d-today',
        medicationId: _medVitaminD,
        scheduledTime: today.add(const Duration(hours: 8)),
        status: ReminderStatus.taken,
        actionTime: today.add(const Duration(hours: 8, minutes: 5)),
      ),
      // Afternoon — pending
      Reminder(
        id: 'rem-iron-today',
        medicationId: _medIronSupplement,
        scheduledTime: today.add(const Duration(hours: 13)),
        status: ReminderStatus.pending,
      ),
      // Evening — pending
      Reminder(
        id: 'rem-metformin-pm-today',
        medicationId: _medMetformin,
        scheduledTime: today.add(const Duration(hours: 20)),
        status: ReminderStatus.pending,
      ),
      Reminder(
        id: 'rem-allergy-today',
        medicationId: _medAllergy,
        scheduledTime: today.add(const Duration(hours: 21)),
        status: ReminderStatus.pending,
      ),
    ];

    for (final reminder in reminders) {
      await _storage.saveReminder(reminder);
    }
  }

  Future<void> _seedAdherenceRecords() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // All medication IDs with their schedule times
    final medSchedules = <String, List<Duration>>{
      _medAmlodipine: [const Duration(hours: 8)],
      _medMetformin: [const Duration(hours: 8), const Duration(hours: 20)],
      _medVitaminD: [const Duration(hours: 8)],
      _medOmeprazole: [const Duration(hours: 7, minutes: 30)],
      _medIronSupplement: [const Duration(hours: 13)],
      _medAllergy: [const Duration(hours: 21)],
    };

    // Generate 14 days of history (high adherence ~88%)
    var recordIndex = 0;
    for (var dayOffset = 14; dayOffset >= 1; dayOffset--) {
      final day = today.subtract(Duration(days: dayOffset));

      for (final entry in medSchedules.entries) {
        final medId = entry.key;
        final times = entry.value;

        for (final time in times) {
          final scheduledTime = day.add(time);

          // ~88% taken, ~8% skipped, ~4% missed
          ReminderStatus status;
          DateTime? actionTime;
          final seed = (recordIndex * 7 + dayOffset * 13) % 25;

          if (seed < 22) {
            status = ReminderStatus.taken;
            // Taken within 0-10 minutes of scheduled time
            actionTime = scheduledTime.add(Duration(minutes: seed % 11));
          } else if (seed < 24) {
            status = ReminderStatus.skipped;
          } else {
            status = ReminderStatus.missed;
          }

          final record = AdherenceRecord(
            id: 'adh-$recordIndex',
            medicationId: medId,
            date: day,
            status: status,
            scheduledTime: scheduledTime,
            actionTime: actionTime,
          );

          await _storage.saveAdherenceRecord(record);
          recordIndex++;
        }
      }
    }

    // Today's taken records (morning meds)
    final todayTaken = [
      AdherenceRecord(
        id: 'adh-today-omeprazole',
        medicationId: _medOmeprazole,
        date: today,
        status: ReminderStatus.taken,
        scheduledTime: today.add(const Duration(hours: 7, minutes: 30)),
        actionTime: today.add(const Duration(hours: 7, minutes: 33)),
      ),
      AdherenceRecord(
        id: 'adh-today-amlodipine',
        medicationId: _medAmlodipine,
        date: today,
        status: ReminderStatus.taken,
        scheduledTime: today.add(const Duration(hours: 8)),
        actionTime: today.add(const Duration(hours: 8, minutes: 2)),
      ),
      AdherenceRecord(
        id: 'adh-today-metformin-am',
        medicationId: _medMetformin,
        date: today,
        status: ReminderStatus.taken,
        scheduledTime: today.add(const Duration(hours: 8)),
        actionTime: today.add(const Duration(hours: 8, minutes: 2)),
      ),
      AdherenceRecord(
        id: 'adh-today-vitamin-d',
        medicationId: _medVitaminD,
        date: today,
        status: ReminderStatus.taken,
        scheduledTime: today.add(const Duration(hours: 8)),
        actionTime: today.add(const Duration(hours: 8, minutes: 5)),
      ),
    ];

    for (final record in todayTaken) {
      await _storage.saveAdherenceRecord(record);
    }
  }
}
