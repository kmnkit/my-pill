import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/models/reminder.dart';
import 'package:my_pill/data/enums/reminder_status.dart';
import 'package:my_pill/data/providers/storage_service_provider.dart';
import 'package:my_pill/data/providers/schedule_provider.dart';
import 'package:my_pill/data/providers/medication_provider.dart';
import 'package:my_pill/data/services/reminder_service.dart';
import 'package:my_pill/data/services/notification_service.dart';

part 'reminder_provider.g.dart';

@riverpod
class TodayReminders extends _$TodayReminders {
  @override
  Future<List<Reminder>> build() async {
    final storage = ref.watch(storageServiceProvider);
    return storage.getRemindersForDate(DateTime.now());
  }

  Future<void> markAsTaken(String reminderId) async {
    try {
      final storage = ref.read(storageServiceProvider);
      final reminderService = ReminderService(storage);

      // Use ReminderService to mark as taken (creates adherence record)
      await reminderService.markAsTaken(reminderId);

      // Cancel the notification
      await NotificationService().cancelReminder(reminderId);

      // Invalidate to refresh UI
      ref.invalidateSelf();
    } catch (e) {
      debugPrint('Failed to mark reminder as taken: $e');
      rethrow;
    }
  }

  Future<void> markAsSkipped(String reminderId) async {
    try {
      final storage = ref.read(storageServiceProvider);
      final reminderService = ReminderService(storage);

      // Use ReminderService to mark as skipped (creates adherence record)
      await reminderService.markAsSkipped(reminderId);

      // Cancel the notification
      await NotificationService().cancelReminder(reminderId);

      // Invalidate to refresh UI
      ref.invalidateSelf();
    } catch (e) {
      debugPrint('Failed to mark reminder as skipped: $e');
      rethrow;
    }
  }

  Future<void> snooze(String reminderId, Duration duration) async {
    try {
      final storage = ref.read(storageServiceProvider);
      final reminderService = ReminderService(storage);

      // Use ReminderService to snooze
      final updated = await reminderService.snooze(reminderId, duration: duration);

      // Cancel old notification and reschedule for snooze time
      await NotificationService().cancelReminder(reminderId);

      // Get medication info for the notification
      final medication = await storage.getMedication(updated.medicationId);
      if (medication != null) {
        // Create a temporary reminder with the snoozed time as scheduledTime
        final snoozedReminder = updated.copyWith(
          scheduledTime: updated.snoozedUntil ?? DateTime.now().add(duration),
        );

        await NotificationService().scheduleReminder(
          snoozedReminder,
          medication.name,
          '${medication.dosage} ${medication.dosageUnit.name}',
        );
      }

      // Invalidate to refresh UI
      ref.invalidateSelf();
    } catch (e) {
      debugPrint('Failed to snooze reminder: $e');
      rethrow;
    }
  }

  /// Generate today's reminders and schedule notifications
  Future<List<Reminder>> generateAndScheduleToday() async {
    try {
      final storage = ref.read(storageServiceProvider);
      final reminderService = ReminderService(storage);

      // Get all active schedules
      final schedules = await ref.read(scheduleListProvider.future);
      final activeSchedules = schedules.where((s) => s.isActive).toList();

      // Generate reminders for today
      final reminders = await reminderService.generateRemindersForDate(
        activeSchedules,
        DateTime.now(),
      );

      // Get all medications to build info map
      final medications = await ref.read(medicationListProvider.future);
      final medicationInfo = <String, ({String name, String dosage, bool isCritical})>{};

      for (final med in medications) {
        medicationInfo[med.id] = (
          name: med.name,
          dosage: '${med.dosage} ${med.dosageUnit.name}',
          isCritical: false,
        );
      }

      // Schedule notifications for pending reminders
      final pendingReminders = reminders
          .where((r) => r.status == ReminderStatus.pending)
          .toList();

      await NotificationService().scheduleTodayReminders(
        pendingReminders,
        medicationInfo,
      );

      // Invalidate to refresh UI
      ref.invalidateSelf();

      return reminders;
    } catch (e) {
      debugPrint('Failed to generate and schedule reminders: $e');
      rethrow;
    }
  }
}
