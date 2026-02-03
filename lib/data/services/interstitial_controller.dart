import 'package:my_pill/data/services/ad_service.dart';

/// Frequency capping controller for interstitial ads.
/// Session = cold start OR resume after >5 min background.
class InterstitialController {
  int _actionCount = 0;
  bool _interstitialShownThisSession = false;
  DateTime? _lastPausedAt;

  /// Record a significant user action (medication save, schedule save).
  void recordAction() {
    _actionCount++;
  }

  /// Whether an interstitial should be shown now.
  bool shouldShowInterstitial() {
    return _actionCount >= 3 && !_interstitialShownThisSession;
  }

  /// Call after interstitial was actually shown.
  void onInterstitialShown() {
    _interstitialShownThisSession = true;
    _actionCount = 0;
  }

  /// Call when app enters paused state.
  void onAppPaused() {
    _lastPausedAt = DateTime.now();
  }

  /// Call when app resumes. Only resets session if >5 min elapsed.
  void onAppResumed() {
    if (_lastPausedAt == null) return; // Cold start, already fresh
    final elapsed = DateTime.now().difference(_lastPausedAt!);
    if (elapsed > const Duration(minutes: 5)) {
      _interstitialShownThisSession = false;
      _actionCount = 0;
    }
    _lastPausedAt = null;
  }

  /// Attempt to show an interstitial ad if frequency conditions are met.
  /// Returns true if an ad was shown.
  Future<bool> maybeShow({
    required AdService adService,
    required bool adsRemoved,
  }) async {
    if (adsRemoved) return false;
    if (!shouldShowInterstitial()) return false;
    await adService.showInterstitial();
    onInterstitialShown();
    return true;
  }

  // Getters for testing
  int get actionCount => _actionCount;
  bool get interstitialShownThisSession => _interstitialShownThisSession;
}
