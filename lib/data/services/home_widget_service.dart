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

  /// Update widget with today's medication data.
  ///
  /// Privacy design decision: only numeric counts (total, taken, pending) and
  /// the next scheduled time are written to shared widget storage.
  /// Medication names and dosage details are intentionally omitted
  /// (`next_med_name` and `next_med_dosage` are always empty strings) to
  /// prevent sensitive medical information from being visible on the lock
  /// screen or accessible via the widget's shared container.
  static Future<void> updateWidget({
    required List<Reminder> todayReminders,
    required Map<String, Medication> medications,
    required String summaryText,
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

      String nextMedTime = '';

      if (upcoming.isNotEmpty) {
        final next = upcoming.first;
        final hour = next.scheduledTime.hour;
        final minute = next.scheduledTime.minute;
        final amPm = hour >= 12 ? 'PM' : 'AM';
        final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        nextMedTime = '$displayHour:${minute.toString().padLeft(2, '0')} $amPm';
      }

      // Save data to shared storage
      // Medication name and dosage are omitted from the widget for privacy
      await HomeWidget.saveWidgetData('total_medications', total);
      await HomeWidget.saveWidgetData('taken_count', taken);
      await HomeWidget.saveWidgetData('pending_count', pending);
      await HomeWidget.saveWidgetData('next_med_name', '');
      await HomeWidget.saveWidgetData('next_med_time', nextMedTime);
      await HomeWidget.saveWidgetData('next_med_dosage', '');
      await HomeWidget.saveWidgetData('summary_text', summaryText);
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
