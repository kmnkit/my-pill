// ignore_for_file: deprecated_member_use
// extra is deprecated in favor of Contexts, but we must still scrub it
// defensively — third-party code or older SDK paths may populate it.
import 'package:sentry_flutter/sentry_flutter.dart';

/// Scrubs PHI (Protected Health Information) from Sentry events
/// before transmission.
///
/// Returns `null` to drop the event if scrubbing fails —
/// dropping is safer than leaking.
/// PHI-related keywords used to identify medication data in breadcrumbs.
const _phiKeywords = [
  'medication',
  'dosage',
  'pill',
  'drug',
  'prescription',
  'dose',
  'tablet',
  'capsule',
];

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

    // Scrub breadcrumbs that may contain PHI
    if (event.breadcrumbs != null && event.breadcrumbs!.isNotEmpty) {
      final cleanedBreadcrumbs = event.breadcrumbs!.where((crumb) {
        final message = crumb.message?.toLowerCase() ?? '';
        final category = crumb.category?.toLowerCase() ?? '';
        return !_phiKeywords.any(
          (kw) => message.contains(kw) || category.contains(kw),
        );
      }).toList();
      result = result.copyWith(breadcrumbs: cleanedBreadcrumbs);
    }

    // Remove screenshot and view hierarchy attachments as defense-in-depth
    hint.screenshot = null;
    hint.viewHierarchy = null;

    return result;
  } catch (_) {
    // Drop event rather than risk leaking PHI
    return null;
  }
}
