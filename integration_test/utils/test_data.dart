/// Test data fixtures for E2E tests
library;

import 'package:my_pill/data/models/medication.dart';
import 'package:my_pill/data/models/schedule.dart';
import 'package:my_pill/data/models/reminder.dart';
import 'package:my_pill/data/models/adherence_record.dart';
import 'package:my_pill/data/models/user_profile.dart';
import 'package:my_pill/data/enums/dosage_unit.dart';
import 'package:my_pill/data/enums/pill_color.dart';
import 'package:my_pill/data/enums/pill_shape.dart';
import 'package:my_pill/data/enums/schedule_type.dart';
import 'package:my_pill/data/enums/reminder_status.dart';
import 'package:my_pill/data/enums/timezone_mode.dart';

/// Test data factory for creating test fixtures
class TestData {
  TestData._();

  // --- User Profiles ---

  static UserProfile get newUserProfile => const UserProfile(
        id: 'test-user-1',
        name: null,
        language: 'en',
        onboardingComplete: false,
        userRole: 'patient',
      );

  static UserProfile get completedOnboardingPatient => const UserProfile(
        id: 'test-user-1',
        name: 'Test User',
        language: 'en',
        onboardingComplete: true,
        userRole: 'patient',
        homeTimezone: 'America/New_York',
        notificationsEnabled: true,
      );

  static UserProfile get completedOnboardingCaregiver => const UserProfile(
        id: 'test-user-2',
        name: 'Caregiver User',
        language: 'en',
        onboardingComplete: true,
        userRole: 'caregiver',
        homeTimezone: 'America/New_York',
        notificationsEnabled: true,
      );

  // --- Medications ---

  static Medication get sampleMedication => Medication(
        id: 'med-1',
        name: 'Aspirin',
        dosage: 100,
        dosageUnit: DosageUnit.mg,
        shape: PillShape.round,
        color: PillColor.white,
        inventoryTotal: 30,
        inventoryRemaining: 25,
        lowStockThreshold: 5,
        isCritical: false,
        createdAt: DateTime(2024, 1, 1),
      );

  static Medication get criticalMedication => Medication(
        id: 'med-2',
        name: 'Blood Pressure Med',
        dosage: 50,
        dosageUnit: DosageUnit.mg,
        shape: PillShape.oval,
        color: PillColor.blue,
        inventoryTotal: 30,
        inventoryRemaining: 3,
        lowStockThreshold: 5,
        isCritical: true,
        createdAt: DateTime(2024, 1, 1),
      );

  static Medication get lowStockMedication => Medication(
        id: 'med-3',
        name: 'Vitamin D',
        dosage: 1000,
        dosageUnit: DosageUnit.units,
        shape: PillShape.round,
        color: PillColor.yellow,
        inventoryTotal: 60,
        inventoryRemaining: 4,
        lowStockThreshold: 5,
        isCritical: false,
        createdAt: DateTime(2024, 1, 1),
      );

  static List<Medication> get sampleMedications => [
        sampleMedication,
        criticalMedication,
        lowStockMedication,
      ];

  // --- Schedules ---

  static Schedule get dailySchedule => const Schedule(
        id: 'schedule-1',
        medicationId: 'med-1',
        type: ScheduleType.daily,
        timesPerDay: 2,
        times: ['08:00', '20:00'],
        timezoneMode: TimezoneMode.fixedInterval,
        isActive: true,
      );

  static Schedule get specificDaysSchedule => const Schedule(
        id: 'schedule-2',
        medicationId: 'med-2',
        type: ScheduleType.specificDays,
        timesPerDay: 1,
        times: ['09:00'],
        specificDays: [1, 3, 5], // Mon, Wed, Fri
        timezoneMode: TimezoneMode.fixedInterval,
        isActive: true,
      );

  static Schedule get intervalSchedule => const Schedule(
        id: 'schedule-3',
        medicationId: 'med-3',
        type: ScheduleType.interval,
        timesPerDay: 1,
        times: ['10:00'],
        intervalHours: 8,
        timezoneMode: TimezoneMode.fixedInterval,
        isActive: true,
      );

  // --- Reminders ---

  static Reminder pendingReminder(DateTime scheduledTime) => Reminder(
        id: 'reminder-1',
        medicationId: 'med-1',
        scheduledTime: scheduledTime,
        status: ReminderStatus.pending,
      );

  static Reminder takenReminder(DateTime scheduledTime) => Reminder(
        id: 'reminder-2',
        medicationId: 'med-1',
        scheduledTime: scheduledTime,
        status: ReminderStatus.taken,
        actionTime: scheduledTime.add(const Duration(minutes: 5)),
      );

  static Reminder missedReminder(DateTime scheduledTime) => Reminder(
        id: 'reminder-3',
        medicationId: 'med-2',
        scheduledTime: scheduledTime,
        status: ReminderStatus.missed,
      );

  static Reminder snoozedReminder(DateTime scheduledTime) => Reminder(
        id: 'reminder-4',
        medicationId: 'med-1',
        scheduledTime: scheduledTime,
        status: ReminderStatus.snoozed,
        snoozedUntil: scheduledTime.add(const Duration(minutes: 15)),
      );

  static List<Reminder> todayReminders() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return [
      pendingReminder(today.add(const Duration(hours: 8))),
      pendingReminder(today.add(const Duration(hours: 12))),
      pendingReminder(today.add(const Duration(hours: 20))),
    ];
  }

  // --- Adherence Records ---

  static AdherenceRecord takenAdherenceRecord(DateTime date) => AdherenceRecord(
        id: 'adherence-1',
        medicationId: 'med-1',
        date: date,
        status: ReminderStatus.taken,
        scheduledTime: date.add(const Duration(hours: 8)),
        actionTime: date.add(const Duration(hours: 8, minutes: 5)),
      );

  static AdherenceRecord missedAdherenceRecord(DateTime date) =>
      AdherenceRecord(
        id: 'adherence-2',
        medicationId: 'med-1',
        date: date,
        status: ReminderStatus.missed,
        scheduledTime: date.add(const Duration(hours: 20)),
      );

  static List<AdherenceRecord> weeklyAdherenceRecords() {
    final now = DateTime.now();
    final records = <AdherenceRecord>[];

    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      final dayDate = DateTime(date.year, date.month, date.day);

      // Add 2 taken, 1 missed per day for 70% adherence
      records.add(AdherenceRecord(
        id: 'adherence-taken-$i-1',
        medicationId: 'med-1',
        date: dayDate,
        status: ReminderStatus.taken,
        scheduledTime: dayDate.add(const Duration(hours: 8)),
        actionTime: dayDate.add(const Duration(hours: 8, minutes: 5)),
      ));
      records.add(AdherenceRecord(
        id: 'adherence-taken-$i-2',
        medicationId: 'med-1',
        date: dayDate,
        status: ReminderStatus.taken,
        scheduledTime: dayDate.add(const Duration(hours: 12)),
        actionTime: dayDate.add(const Duration(hours: 12, minutes: 10)),
      ));
      if (i % 3 == 0) {
        records.add(AdherenceRecord(
          id: 'adherence-missed-$i',
          medicationId: 'med-1',
          date: dayDate,
          status: ReminderStatus.missed,
          scheduledTime: dayDate.add(const Duration(hours: 20)),
        ));
      } else {
        records.add(AdherenceRecord(
          id: 'adherence-taken-$i-3',
          medicationId: 'med-1',
          date: dayDate,
          status: ReminderStatus.taken,
          scheduledTime: dayDate.add(const Duration(hours: 20)),
          actionTime: dayDate.add(const Duration(hours: 20, minutes: 3)),
        ));
      }
    }

    return records;
  }

  // --- Helper methods for creating custom test data ---

  static Medication createMedication({
    String? id,
    required String name,
    double dosage = 100,
    DosageUnit dosageUnit = DosageUnit.mg,
    PillShape shape = PillShape.round,
    PillColor color = PillColor.white,
    int inventoryTotal = 30,
    int inventoryRemaining = 30,
    int lowStockThreshold = 5,
    bool isCritical = false,
  }) {
    return Medication(
      id: id ?? 'med-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      dosage: dosage,
      dosageUnit: dosageUnit,
      shape: shape,
      color: color,
      inventoryTotal: inventoryTotal,
      inventoryRemaining: inventoryRemaining,
      lowStockThreshold: lowStockThreshold,
      isCritical: isCritical,
      createdAt: DateTime.now(),
    );
  }

  static Schedule createSchedule({
    String? id,
    required String medicationId,
    ScheduleType type = ScheduleType.daily,
    int timesPerDay = 1,
    List<String> times = const ['08:00'],
    List<int> specificDays = const [],
    int? intervalHours,
  }) {
    return Schedule(
      id: id ?? 'schedule-${DateTime.now().millisecondsSinceEpoch}',
      medicationId: medicationId,
      type: type,
      timesPerDay: timesPerDay,
      times: times,
      specificDays: specificDays,
      intervalHours: intervalHours,
      timezoneMode: TimezoneMode.fixedInterval,
      isActive: true,
    );
  }
}
