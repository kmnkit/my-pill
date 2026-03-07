import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

abstract final class AnalyticsService {
  static FirebaseAnalytics get _analytics => FirebaseAnalytics.instance;

  static Future<void> logMedicationAdded() =>
      _analytics.logEvent(name: 'medication_added');

  static Future<void> logMedicationEdited() =>
      _analytics.logEvent(name: 'medication_edited');

  static Future<void> logMedicationDeleted() =>
      _analytics.logEvent(name: 'medication_deleted');

  static Future<void> logNotificationToggled({required bool enabled}) =>
      _analytics.logEvent(
        name: 'notification_toggled',
        parameters: {'enabled': enabled},
      );

  static Future<void> logPdfExported({required String period}) =>
      _analytics.logEvent(
        name: 'pdf_exported',
        parameters: {'period': period},
      );

  static Future<void> logCaregiverInviteGenerated() =>
      _analytics.logEvent(name: 'caregiver_invite_generated');

  static Future<void> setUserId(String? uid) async {
    await _analytics.setUserId(id: uid);
    Sentry.configureScope(
      (scope) => scope.setUser(uid != null ? SentryUser(id: uid) : null),
    );
  }
}
