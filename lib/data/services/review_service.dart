import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:kusuridoki/data/enums/reminder_status.dart';
import 'package:kusuridoki/data/services/storage_service.dart';

class ReviewService {
  ReviewService(this._storage);

  final StorageService _storage;

  static const String _lastPromptKey = 'review_last_prompt_date';
  static const int _requiredDays = 3;
  static const int _cooldownDays = 90;

  /// Check eligibility and request review if conditions are met.
  /// Call this after a successful markAsTaken action.
  Future<void> requestReviewIfEligible() async {
    try {
      if (await _wasRecentlyPrompted()) return;
      if (!await _hasEnoughAdherenceDays()) return;

      final inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
        await _recordPromptDate();
      }
    } catch (e) {
      // Never let review logic crash the app
      debugPrint('ReviewService: $e');
    }
  }

  Future<bool> _wasRecentlyPrompted() async {
    final lastPrompt = await _storage.getSetting(_lastPromptKey);
    if (lastPrompt == null) return false;

    final lastDate = DateTime.tryParse(lastPrompt);
    if (lastDate == null) return false;

    return DateTime.now().difference(lastDate).inDays < _cooldownDays;
  }

  Future<bool> _hasEnoughAdherenceDays() async {
    final records = await _storage.getAdherenceRecords(
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now(),
    );

    final takenDays = records
        .where((r) => r.status == ReminderStatus.taken)
        .map((r) => DateTime(r.date.year, r.date.month, r.date.day))
        .toSet();

    return takenDays.length >= _requiredDays;
  }

  Future<void> _recordPromptDate() async {
    await _storage.saveSetting(
      _lastPromptKey,
      DateTime.now().toIso8601String(),
    );
  }
}
