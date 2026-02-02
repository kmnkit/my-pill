import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/services/home_widget_service.dart';
import 'package:my_pill/data/providers/reminder_provider.dart';
import 'package:my_pill/data/providers/medication_provider.dart';

part 'home_widget_provider.g.dart';

// Provider that automatically updates the home widget when reminders change
@riverpod
Future<void> homeWidgetUpdater(Ref ref) async {
  final reminders = await ref.watch(todayRemindersProvider.future);
  final medications = await ref.watch(medicationListProvider.future);

  final medMap = {for (final med in medications) med.id: med};

  await HomeWidgetService.updateWidget(
    todayReminders: reminders,
    medications: medMap,
  );
}
