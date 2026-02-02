import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/providers/reminder_provider.dart';
import 'package:my_pill/data/providers/medication_provider.dart';
import 'package:my_pill/data/services/home_widget_service.dart';

part 'home_widget_provider.g.dart';

@riverpod
Future<void> homeWidgetUpdater(Ref ref) async {
  // Watch both providers - this will re-run whenever either changes
  final reminders = await ref.watch(todayRemindersProvider.future);
  final medications = await ref.watch(medicationListProvider.future);

  // Convert medications list to map keyed by id
  final medicationMap = {for (final med in medications) med.id: med};

  try {
    await HomeWidgetService.updateWidget(
      todayReminders: reminders,
      medications: medicationMap,
    );
  } catch (e) {
    debugPrint('Failed to update home widget: $e');
  }
}
