import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract final class AnalyticsService {
  static FirebaseAnalytics get _analytics => FirebaseAnalytics.instance;

  // Analytics errors are non-critical. Silently ignore if Firebase is
  // unavailable (e.g., in unit tests or when SDK is not initialized).
  static Future<void> _log(
    String name, [
    Map<String, Object>? parameters,
  ]) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (_) {}
  }

  static Future<void> logMedicationAdded() => _log('medication_added');

  static Future<void> logMedicationEdited() => _log('medication_edited');

  static Future<void> logMedicationDeleted() => _log('medication_deleted');

  static Future<void> logNotificationToggled({required bool enabled}) =>
      _log('notification_toggled', {'enabled': enabled});

  static Future<void> logPdfExported({required String period}) =>
      _log('pdf_exported', {'period': period});

  static Future<void> logCaregiverInviteGenerated() =>
      _log('caregiver_invite_generated');

  // --- Ads conversion events (Google Ads / Firebase Ads tracking) ---

  static Future<void> logDoseTaken() => _log('dose_taken');

  static Future<void> logReminderSet() => _log('reminder_set');

  static Future<void> setUserId(String? uid) async {
    try {
      await _analytics.setUserId(id: uid);
    } catch (_) {}
    Sentry.configureScope(
      (scope) => scope.setUser(uid != null ? SentryUser(id: uid) : null),
    );
  }
}
