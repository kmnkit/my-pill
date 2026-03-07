import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kusuridoki/data/providers/reminder_provider.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/data/services/home_widget_service.dart';
import 'package:kusuridoki/data/enums/reminder_status.dart';

part 'home_widget_provider.g.dart';

@riverpod
Future<void> homeWidgetUpdater(Ref ref) async {
  // Watch providers directly (no .future) to avoid proxy subscription assertion
  final reminders = ref.watch(todayRemindersProvider).asData?.value;
  final medications = ref.watch(medicationListProvider).asData?.value;
  final userProfile = ref.watch(userSettingsProvider).asData?.value;

  // Wait until all data is available
  if (reminders == null || medications == null || userProfile == null) return;

  // Convert medications list to map keyed by id
  final medicationMap = {for (final med in medications) med.id: med};

  // Build localized summary text
  final taken = reminders.where((r) => r.status == ReminderStatus.taken).length;
  final total = reminders.length;
  final summaryText = userProfile.language == 'ja'
      ? '$taken/$total 服用済み'
      : '$taken/$total taken';

  try {
    await HomeWidgetService.updateWidget(
      todayReminders: reminders,
      medications: medicationMap,
      summaryText: summaryText,
    );
  } catch (e) {
    debugPrint('Failed to update home widget: $e');
  }
}
