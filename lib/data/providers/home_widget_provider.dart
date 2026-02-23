import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/providers/reminder_provider.dart';
import 'package:my_pill/data/providers/medication_provider.dart';
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/data/services/home_widget_service.dart';
import 'package:my_pill/data/enums/reminder_status.dart';

part 'home_widget_provider.g.dart';

@riverpod
Future<void> homeWidgetUpdater(Ref ref) async {
  // Watch both providers - this will re-run whenever either changes
  final reminders = await ref.watch(todayRemindersProvider.future);
  final medications = await ref.watch(medicationListProvider.future);
  final userProfile = await ref.watch(userSettingsProvider.future);

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
