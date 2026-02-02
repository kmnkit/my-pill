import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:my_pill/data/models/reminder.dart';
import 'package:my_pill/data/models/medication.dart';
import 'package:my_pill/data/enums/reminder_status.dart';

class HomeWidgetService {
  static const String _appGroupId = 'group.com.mypill.app';
  static const String _androidWidgetName = 'MedicationWidgetProvider';
  static const String _iOSWidgetName = 'MedicationWidget';

  /// Initialize home widget
  static Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId(_appGroupId);
    } catch (e) {
      debugPrint('Home widget not configured: $e');
    }
  }

  /// Update widget with today's medication data
  static Future<void> updateWidget({
    required List<Reminder> todayReminders,
    required Map<String, Medication> medications,
  }) async {
    try {
      // Calculate summary
      final total = todayReminders.length;
      final taken = todayReminders.where((r) => r.status == ReminderStatus.taken).length;
      final pending = todayReminders.where((r) => r.status == ReminderStatus.pending).length;

      // Find next upcoming medication
      final upcoming = todayReminders
          .where((r) => r.status == ReminderStatus.pending || r.status == ReminderStatus.snoozed)
          .toList()
        ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));

      String nextMedName = '';
      String nextMedTime = '';
      String nextMedDosage = '';

      if (upcoming.isNotEmpty) {
        final next = upcoming.first;
        final med = medications[next.medicationId];
        nextMedName = med?.name ?? 'Unknown';
        nextMedDosage = '${med?.dosage ?? ''} ${med?.dosageUnit.name ?? ''}';
        final hour = next.scheduledTime.hour;
        final minute = next.scheduledTime.minute;
        final amPm = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        nextMedTime = '$displayHour:${minute.toString().padLeft(2, '0')} $amPm';
      }

      // Save data to shared storage
      await HomeWidget.saveWidgetData('total_medications', total);
      await HomeWidget.saveWidgetData('taken_count', taken);
      await HomeWidget.saveWidgetData('pending_count', pending);
      await HomeWidget.saveWidgetData('next_med_name', nextMedName);
      await HomeWidget.saveWidgetData('next_med_time', nextMedTime);
      await HomeWidget.saveWidgetData('next_med_dosage', nextMedDosage);
      await HomeWidget.saveWidgetData('summary_text', '$taken/$total taken');
      await HomeWidget.saveWidgetData('last_updated', DateTime.now().toIso8601String());

      // Trigger widget update
      await HomeWidget.updateWidget(
        androidName: _androidWidgetName,
        iOSName: _iOSWidgetName,
      );
    } catch (e) {
      debugPrint('Failed to update home widget: $e');
    }
  }

  /// Handle widget interaction (e.g., "Taken" button)
  static Future<Uri?> getInitialAction() async {
    try {
      return await HomeWidget.initiallyLaunchedFromHomeWidget();
    } catch (e) {
      debugPrint('Failed to get widget action: $e');
      return null;
    }
  }

  /// Register callback for widget interactions
  static Future<void> registerInteractivityCallback(Future<void> Function(Uri?) callback) async {
    try {
      await HomeWidget.registerInteractivityCallback(callback);
    } catch (e) {
      debugPrint('Failed to register widget callback: $e');
    }
  }
}
