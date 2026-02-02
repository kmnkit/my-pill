import 'package:my_pill/data/models/reminder.dart';
import 'package:my_pill/data/models/schedule.dart';
import 'package:my_pill/data/models/adherence_record.dart';
import 'package:my_pill/data/enums/reminder_status.dart';
import 'package:my_pill/data/enums/schedule_type.dart';
import 'package:my_pill/data/services/storage_service.dart';
import 'package:uuid/uuid.dart';

class ReminderService {
  final StorageService _storage;

  ReminderService(this._storage);

  /// Generate today's reminders from active schedules
  /// Checks existing reminders to avoid duplicates
  Future<List<Reminder>> generateRemindersForDate(
    List<Schedule> activeSchedules,
    DateTime date,
  ) async {
    final existing = await _storage.getRemindersForDate(date);
    final newReminders = <Reminder>[];

    for (final schedule in activeSchedules) {
      if (!schedule.isActive) continue;

      // Check if this schedule should run on this date
      if (!_shouldGenerateForDate(schedule, date)) continue;

      // Parse schedule.times (List<String> like ["08:00", "12:00"])
      for (final timeString in schedule.times) {
        final scheduledTime = _parseTimeForDate(timeString, date);

        // Check if reminder already exists for this medicationId + scheduledTime
        final alreadyExists = existing.any((r) =>
            r.medicationId == schedule.medicationId &&
            r.scheduledTime.isAtSameMomentAs(scheduledTime));

        if (!alreadyExists) {
          final reminder = Reminder(
            id: const Uuid().v4(),
            medicationId: schedule.medicationId,
            scheduledTime: scheduledTime,
            status: ReminderStatus.pending,
          );
          newReminders.add(reminder);
        }
      }
    }

    // Save all new reminders
    for (final reminder in newReminders) {
      await _storage.saveReminder(reminder);
    }

    return [...existing, ...newReminders];
  }

  /// Check if schedule should generate a reminder for the given date
  bool _shouldGenerateForDate(Schedule schedule, DateTime date) {
    switch (schedule.type) {
      case ScheduleType.daily:
        return true;

      case ScheduleType.specificDays:
        // specificDays contains weekday numbers (1=Monday, 7=Sunday)
        return schedule.specificDays.contains(date.weekday);

      case ScheduleType.interval:
        // For interval schedules, we generate based on the interval hours
        // This is a simplified implementation - in production you might want
        // to track the last dose time more precisely
        return true;
    }
  }

  /// Parse time string (e.g., "08:00") and combine with date
  DateTime _parseTimeForDate(String timeString, DateTime date) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  /// Mark reminder as taken - also creates adherence record
  Future<Reminder> markAsTaken(String reminderId) async {
    final reminder = await _storage.getReminder(reminderId);
    if (reminder == null) throw Exception('Reminder not found');

    final updated = reminder.copyWith(
      status: ReminderStatus.taken,
      actionTime: DateTime.now(),
    );
    await _storage.saveReminder(updated);

    // Create adherence record
    await _createAdherenceRecord(updated, ReminderStatus.taken);

    return updated;
  }

  /// Mark reminder as skipped
  Future<Reminder> markAsSkipped(String reminderId) async {
    final reminder = await _storage.getReminder(reminderId);
    if (reminder == null) throw Exception('Reminder not found');

    final updated = reminder.copyWith(
      status: ReminderStatus.skipped,
      actionTime: DateTime.now(),
    );
    await _storage.saveReminder(updated);

    // Create adherence record
    await _createAdherenceRecord(updated, ReminderStatus.skipped);

    return updated;
  }

  /// Snooze - set snoozedUntil to current time + duration
  Future<Reminder> snooze(
    String reminderId, {
    Duration duration = const Duration(minutes: 15),
  }) async {
    final reminder = await _storage.getReminder(reminderId);
    if (reminder == null) throw Exception('Reminder not found');

    final updated = reminder.copyWith(
      status: ReminderStatus.snoozed,
      snoozedUntil: DateTime.now().add(duration),
    );
    await _storage.saveReminder(updated);

    return updated;
  }

  /// Auto-mark as missed if not acted on within window (1 hour after scheduled time)
  Future<List<Reminder>> checkAndMarkMissed() async {
    final today = await _storage.getRemindersForDate(DateTime.now());
    final now = DateTime.now();
    final updated = <Reminder>[];

    for (final reminder in today) {
      if (reminder.status == ReminderStatus.pending &&
          now.difference(reminder.scheduledTime).inMinutes > 60) {
        final missed = reminder.copyWith(
          status: ReminderStatus.missed,
          actionTime: now,
        );
        await _storage.saveReminder(missed);
        await _createAdherenceRecord(missed, ReminderStatus.missed);
        updated.add(missed);
      }
    }
    return updated;
  }

  /// Calculate next reminder time
  Future<DateTime?> getNextReminderTime() async {
    final today = await _storage.getRemindersForDate(DateTime.now());
    final pending = today
        .where((r) =>
            r.status == ReminderStatus.pending ||
            r.status == ReminderStatus.snoozed)
        .toList();

    if (pending.isEmpty) return null;

    pending.sort((a, b) {
      final aTime = a.status == ReminderStatus.snoozed && a.snoozedUntil != null
          ? a.snoozedUntil!
          : a.scheduledTime;
      final bTime = b.status == ReminderStatus.snoozed && b.snoozedUntil != null
          ? b.snoozedUntil!
          : b.scheduledTime;
      return aTime.compareTo(bTime);
    });

    final next = pending.first;
    return next.status == ReminderStatus.snoozed && next.snoozedUntil != null
        ? next.snoozedUntil
        : next.scheduledTime;
  }

  /// Create adherence record from reminder
  Future<void> _createAdherenceRecord(
    Reminder reminder,
    ReminderStatus status,
  ) async {
    final record = AdherenceRecord(
      id: const Uuid().v4(),
      medicationId: reminder.medicationId,
      date: DateTime(
        reminder.scheduledTime.year,
        reminder.scheduledTime.month,
        reminder.scheduledTime.day,
      ),
      status: status,
      scheduledTime: reminder.scheduledTime,
      actionTime: DateTime.now(),
    );
    await _storage.saveAdherenceRecord(record);
  }
}
