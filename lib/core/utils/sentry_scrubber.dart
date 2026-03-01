// ignore_for_file: deprecated_member_use
// extra is deprecated in favor of Contexts, but we must still scrub it
// defensively — third-party code or older SDK paths may populate it.
import 'package:sentry_flutter/sentry_flutter.dart';

/// Scrubs PHI (Protected Health Information) from Sentry events
/// before transmission.
///
/// Returns `null` to drop the event if scrubbing fails —
/// dropping is safer than leaking.
SentryEvent? scrubPhiFromEvent(SentryEvent event, Hint hint) {
  try {
    var result = event;

    // Remove medication-related data from extras
    if (event.extra != null) {
      final cleanedExtra = Map<String, dynamic>.from(event.extra!)
        ..remove('medicationName')
        ..remove('dosage')
        ..remove('pillColor')
        ..remove('pillShape');
      result = result.copyWith(extra: cleanedExtra);
    }

    // Strip user PII — keep only Firebase UID
    if (event.user != null) {
      result = result.copyWith(user: SentryUser(id: event.user!.id));
    }

    return result;
  } catch (_) {
    // Drop event rather than risk leaking PHI
    return null;
  }
}
