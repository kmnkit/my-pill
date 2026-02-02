import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/services/interstitial_controller.dart';

void main() {
  late InterstitialController controller;

  setUp(() {
    controller = InterstitialController();
  });

  group('InterstitialController', () {
    test('action count increments correctly', () {
      expect(controller.actionCount, 0);
      controller.recordAction();
      expect(controller.actionCount, 1);
      controller.recordAction();
      expect(controller.actionCount, 2);
    });

    test('shouldShowInterstitial returns false before 3 actions', () {
      controller.recordAction();
      controller.recordAction();
      expect(controller.shouldShowInterstitial(), false);
    });

    test('shouldShowInterstitial returns true at 3 actions', () {
      controller.recordAction();
      controller.recordAction();
      controller.recordAction();
      expect(controller.shouldShowInterstitial(), true);
    });

    test('shouldShowInterstitial returns false after shown once in session', () {
      controller.recordAction();
      controller.recordAction();
      controller.recordAction();
      expect(controller.shouldShowInterstitial(), true);

      controller.onInterstitialShown();
      expect(controller.shouldShowInterstitial(), false);
      expect(controller.actionCount, 0);

      // Even after 3 more actions, shown flag prevents showing again
      controller.recordAction();
      controller.recordAction();
      controller.recordAction();
      expect(controller.shouldShowInterstitial(), false);
    });

    test('onAppResumed after <5 min does NOT reset session', () {
      // Show one interstitial
      controller.recordAction();
      controller.recordAction();
      controller.recordAction();
      controller.onInterstitialShown();
      expect(controller.interstitialShownThisSession, true);

      // Simulate short background pause
      controller.onAppPaused();
      // Simulate resume after <5 min by manipulating time
      // Since we can't easily mock DateTime.now(), we test the immediate case
      controller.onAppResumed();

      // Session should NOT be reset (elapsed < 5 min)
      expect(controller.interstitialShownThisSession, true);
    });

    test('cold start begins with fresh session state', () {
      // Fresh controller = fresh session
      expect(controller.interstitialShownThisSession, false);
      expect(controller.actionCount, 0);

      // onAppResumed without prior onAppPaused is a no-op
      controller.onAppResumed();
      expect(controller.interstitialShownThisSession, false);
      expect(controller.actionCount, 0);
    });

    test('onInterstitialShown resets action count to 0', () {
      controller.recordAction();
      controller.recordAction();
      controller.recordAction();
      expect(controller.actionCount, 3);

      controller.onInterstitialShown();
      expect(controller.actionCount, 0);
      expect(controller.interstitialShownThisSession, true);
    });
  });
}
