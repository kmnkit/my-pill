/// Japanese test data fixtures for App Store screenshot capture.
library;

import 'package:kusuridoki/data/models/caregiver_link.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/data/models/schedule.dart';
import 'package:kusuridoki/data/models/reminder.dart';
import 'package:kusuridoki/data/models/adherence_record.dart';
import 'package:kusuridoki/data/models/user_profile.dart';
import 'package:kusuridoki/data/enums/dosage_unit.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/data/enums/dosage_timing.dart';
import 'package:kusuridoki/data/enums/schedule_type.dart';
import 'package:kusuridoki/data/enums/reminder_status.dart';
import 'package:kusuridoki/data/enums/timezone_mode.dart';
import 'package:kusuridoki/data/models/dosage_time_slot.dart';

/// Japanese test data for App Store screenshot capture.
class ScreenshotFixtures {
  ScreenshotFixtures._();

  // --- User Profile ---

  static const UserProfile userProfile = UserProfile(
    id: 'user-1',
    name: '田中 花子',
    language: 'ja',
    onboardingComplete: true,
    userRole: 'patient',
    homeTimezone: 'Asia/Tokyo',
    notificationsEnabled: true,
  );

  // --- Medications (critical×1, low-stock×1, normal×1) ---

  static Medication get criticalMedication => Medication(
    id: 'med-1',
    name: '降圧薬',
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
    id: 'med-2',
    name: 'ビタミンD',
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

  static Medication get normalMedication => Medication(
    id: 'med-3',
    name: 'アスピリン',
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

  static List<Medication> get medications => [
    criticalMedication,
    lowStockMedication,
    normalMedication,
  ];

  // --- Schedules (daily, specificDays, interval) ---

  static const Schedule dailySchedule = Schedule(
    id: 'schedule-1',
    medicationId: 'med-1',
    type: ScheduleType.daily,
    dosageSlots: [
      DosageTimeSlot(timing: DosageTiming.morning, time: '08:00'),
      DosageTimeSlot(timing: DosageTiming.evening, time: '20:00'),
    ],
    timezoneMode: TimezoneMode.fixedInterval,
    isActive: true,
  );

  static const Schedule specificDaysSchedule = Schedule(
    id: 'schedule-2',
    medicationId: 'med-2',
    type: ScheduleType.specificDays,
    dosageSlots: [
      DosageTimeSlot(timing: DosageTiming.morning, time: '09:00'),
    ],
    specificDays: [1, 3, 5],
    timezoneMode: TimezoneMode.fixedInterval,
    isActive: true,
  );

  static const Schedule intervalSchedule = Schedule(
    id: 'schedule-3',
    medicationId: 'med-3',
    type: ScheduleType.interval,
    dosageSlots: [
      DosageTimeSlot(timing: DosageTiming.morning, time: '10:00'),
    ],
    intervalHours: 8,
    timezoneMode: TimezoneMode.fixedInterval,
    isActive: true,
  );

  static List<Schedule> get schedules => [
    dailySchedule,
    specificDaysSchedule,
    intervalSchedule,
  ];

  // --- Reminders (3 pending for today) ---

  static List<Reminder> get reminders {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return [
      Reminder(
        id: 'reminder-1',
        medicationId: 'med-1',
        scheduledTime: today.add(const Duration(hours: 8)),
        status: ReminderStatus.pending,
      ),
      Reminder(
        id: 'reminder-2',
        medicationId: 'med-2',
        scheduledTime: today.add(const Duration(hours: 12)),
        status: ReminderStatus.pending,
      ),
      Reminder(
        id: 'reminder-3',
        medicationId: 'med-3',
        scheduledTime: today.add(const Duration(hours: 20)),
        status: ReminderStatus.pending,
      ),
    ];
  }

  // --- Adherence Records (7 days, ~85% taken) ---

  static List<AdherenceRecord> get adherenceRecords {
    final now = DateTime.now();
    final records = <AdherenceRecord>[];

    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      final day = DateTime(date.year, date.month, date.day);

      // 2 taken + 1 conditional per day → i%3==0 gives missed, else taken
      records.add(
        AdherenceRecord(
          id: 'adh-$i-morning',
          medicationId: 'med-1',
          date: day,
          status: ReminderStatus.taken,
          scheduledTime: day.add(const Duration(hours: 8)),
          actionTime: day.add(const Duration(hours: 8, minutes: 5)),
        ),
      );
      records.add(
        AdherenceRecord(
          id: 'adh-$i-noon',
          medicationId: 'med-1',
          date: day,
          status: ReminderStatus.taken,
          scheduledTime: day.add(const Duration(hours: 12)),
          actionTime: day.add(const Duration(hours: 12, minutes: 10)),
        ),
      );
      if (i % 3 == 0) {
        records.add(
          AdherenceRecord(
            id: 'adh-$i-evening',
            medicationId: 'med-1',
            date: day,
            status: ReminderStatus.missed,
            scheduledTime: day.add(const Duration(hours: 20)),
          ),
        );
      } else {
        records.add(
          AdherenceRecord(
            id: 'adh-$i-evening',
            medicationId: 'med-1',
            date: day,
            status: ReminderStatus.taken,
            scheduledTime: day.add(const Duration(hours: 20)),
            actionTime: day.add(const Duration(hours: 20, minutes: 3)),
          ),
        );
      }
    }

    return records;
  }

  // --- Caregiver Links (1 connected) ---

  static CaregiverLink get caregiverLink => CaregiverLink(
    id: 'link-1',
    patientId: 'user-1',
    caregiverId: 'caregiver-1',
    caregiverName: '山田 一郎',
    status: 'connected',
    linkedAt: DateTime(2024, 1, 15),
  );

  static List<CaregiverLink> get caregiverLinks => [caregiverLink];
}
