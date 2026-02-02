import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/models/reminder.dart';
import 'package:my_pill/data/enums/reminder_status.dart';
import 'package:my_pill/data/providers/storage_service_provider.dart';

part 'reminder_provider.g.dart';

@riverpod
class TodayReminders extends _$TodayReminders {
  @override
  Future<List<Reminder>> build() async {
    final storage = ref.watch(storageServiceProvider);
    return storage.getRemindersForDate(DateTime.now());
  }

  Future<void> markAsTaken(String reminderId) async {
    final storage = ref.read(storageServiceProvider);
    final reminder = await storage.getReminder(reminderId);
    if (reminder != null) {
      final updated = reminder.copyWith(
        status: ReminderStatus.taken,
        actionTime: DateTime.now(),
      );
      await storage.saveReminder(updated);
      ref.invalidateSelf();
    }
  }

  Future<void> markAsSkipped(String reminderId) async {
    final storage = ref.read(storageServiceProvider);
    final reminder = await storage.getReminder(reminderId);
    if (reminder != null) {
      final updated = reminder.copyWith(
        status: ReminderStatus.skipped,
        actionTime: DateTime.now(),
      );
      await storage.saveReminder(updated);
      ref.invalidateSelf();
    }
  }

  Future<void> snooze(String reminderId, Duration duration) async {
    final storage = ref.read(storageServiceProvider);
    final reminder = await storage.getReminder(reminderId);
    if (reminder != null) {
      final updated = reminder.copyWith(
        status: ReminderStatus.snoozed,
        snoozedUntil: DateTime.now().add(duration),
      );
      await storage.saveReminder(updated);
      ref.invalidateSelf();
    }
  }
}
