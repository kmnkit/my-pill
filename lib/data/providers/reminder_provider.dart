import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kusuridoki/core/utils/analytics_service.dart';
import 'package:kusuridoki/data/models/reminder.dart';
import 'package:kusuridoki/data/enums/reminder_status.dart';
import 'package:kusuridoki/data/providers/adherence_provider.dart';
import 'package:kusuridoki/data/providers/storage_service_provider.dart';
import 'package:kusuridoki/data/providers/schedule_provider.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/data/repositories/medication_repository.dart';
import 'package:kusuridoki/data/services/reminder_service.dart';
import 'package:kusuridoki/data/services/notification_service.dart';
import 'package:kusuridoki/data/services/review_service.dart';
import 'package:kusuridoki/data/providers/timezone_provider.dart';

part 'reminder_provider.g.dart';

@riverpod
class TodayReminders extends _$TodayReminders {
  @override
  Future<List<Reminder>> build() async {
    final storage = ref.watch(storageServiceProvider);

    // Re-schedule reminders when timezone settings change
    ref.listen(timezoneSettingsProvider, (prev, next) {
      if (prev != next) {
        _rescheduleAll();
      }
    });

    return storage.getRemindersForDate(DateTime.now());
  }

  Future<void> markAsTaken(String reminderId) async {
    try {
      final storage = ref.read(storageServiceProvider);
      final reminderService = ReminderService(storage);

      // Use ReminderService to mark as taken (creates adherence record)
      final reminder = await reminderService.markAsTaken(reminderId);
      unawaited(AnalyticsService.logDoseTaken());

      // Deduct inventory (non-blocking — failure must not undo the taken record)
      try {
        await MedicationRepository(storage).deductInventory(reminder.medicationId);
        ref.invalidate(medicationListProvider);
        ref.invalidate(medicationProvider(reminder.medicationId));
      } catch (e) {
        debugPrint('Inventory deduction skipped: $e');
      }

      // Cancel the notification
      await NotificationService().cancelReminder(reminderId);

      // Update state directly to refresh UI, then invalidate adherence providers
      await _refreshState();
      ref.invalidate(overallAdherenceProvider);
      ref.invalidate(weeklyAdherenceProvider);
      ref.invalidate(medicationBreakdownProvider);

      // Check if eligible for in-app review (non-blocking)
      ReviewService(storage).requestReviewIfEligible();
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

      // Update state directly to refresh UI, then invalidate adherence providers
      await _refreshState();
      ref.invalidate(overallAdherenceProvider);
      ref.invalidate(weeklyAdherenceProvider);
      ref.invalidate(medicationBreakdownProvider);
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
      final updated = await reminderService.snooze(
        reminderId,
        duration: duration,
      );

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

      // Update state directly to refresh UI, then invalidate adherence providers
      await _refreshState();
      ref.invalidate(overallAdherenceProvider);
      ref.invalidate(weeklyAdherenceProvider);
      ref.invalidate(medicationBreakdownProvider);
    } catch (e) {
      debugPrint('Failed to snooze reminder: $e');
      rethrow;
    }
  }

  /// Generate today's reminders and schedule notifications
  Future<List<Reminder>> generateAndScheduleToday() async {
    try {
      final storage = ref.read(storageServiceProvider);
      final timezoneService = ref.read(timezoneServiceProvider);
      final reminderService = ReminderService(
        storage,
        timezoneService: timezoneService,
      );

      // Get all active schedules
      final schedules = await ref.read(scheduleListProvider.future);
      if (!ref.mounted) return [];
      final activeSchedules = schedules.where((s) => s.isActive).toList();

      // Read timezone settings for travel mode adjustment
      final tzSettings = ref.read(timezoneSettingsProvider);

      // Generate reminders for today, with timezone adjustment if enabled
      final reminders = await reminderService.generateRemindersForDate(
        activeSchedules,
        DateTime.now(),
        homeTimezone: tzSettings.enabled ? tzSettings.homeTimezone : null,
        currentTimezone: tzSettings.enabled ? tzSettings.currentTimezone : null,
        timezoneMode: tzSettings.mode,
      );
      if (!ref.mounted) return reminders;

      // Get all medications to build info map
      final medications = await ref.read(medicationListProvider.future);
      if (!ref.mounted) return reminders;
      final medicationInfo =
          <
            String,
            ({
              String name,
              String dosage,
              bool isCritical,
              String? dosageTimingLabel,
            })
          >{};

      for (final med in medications) {
        // Find dosageTimings from the medication's active schedule
        String? dosageTimingLabel;
        final medSchedules = activeSchedules.where(
          (s) => s.medicationId == med.id,
        );
        if (medSchedules.isNotEmpty &&
            medSchedules.first.dosageTimings.isNotEmpty) {
          dosageTimingLabel = medSchedules.first.dosageTimings
              .map((t) => t.label)
              .join('・');
        }

        medicationInfo[med.id] = (
          name: med.name,
          dosage: '${med.dosage} ${med.dosageUnit.name}',
          isCritical: med.isCritical,
          dosageTimingLabel: dosageTimingLabel,
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
      if (!ref.mounted) return reminders;

      // Update state directly to refresh UI
      await _refreshState();

      return reminders;
    } catch (e) {
      debugPrint('Failed to generate and schedule reminders: $e');
      rethrow;
    }
  }

  Future<void> _rescheduleAll() async {
    try {
      await NotificationService().cancelAll();
      await generateAndScheduleToday();
    } catch (e) {
      debugPrint('Failed to reschedule reminders after timezone change: $e');
    }
  }

  Future<void> _refreshState() async {
    state = AsyncData(
      await ref
          .read(storageServiceProvider)
          .getRemindersForDate(DateTime.now()),
    );
  }
}
