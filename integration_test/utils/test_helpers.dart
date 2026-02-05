/// Common test utilities and helpers for E2E tests
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'firebase_test_setup.dart';

/// Initialize integration test binding
IntegrationTestWidgetsFlutterBinding ensureTestInitialized() {
  setupFirebaseCoreMocks();
  return IntegrationTestWidgetsFlutterBinding.ensureInitialized();
}

/// Extension methods for WidgetTester to simplify common operations
extension WidgetTesterExtensions on WidgetTester {
  /// Pump and settle with a timeout
  Future<void> pumpAndSettleWithTimeout({
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      timeout,
    );
  }

  /// Wait for a widget to appear
  Future<void> waitForWidget(
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final endTime = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(endTime)) {
      await pump(const Duration(milliseconds: 100));

      if (finder.evaluate().isNotEmpty) {
        return;
      }
    }

    throw TestFailure('Widget not found within timeout: $finder');
  }

  /// Wait for a widget to disappear
  Future<void> waitForWidgetToDisappear(
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final endTime = DateTime.now().add(timeout);

    while (DateTime.now().isBefore(endTime)) {
      await pump(const Duration(milliseconds: 100));

      if (finder.evaluate().isEmpty) {
        return;
      }
    }

    throw TestFailure('Widget still present after timeout: $finder');
  }

  /// Tap and wait for navigation to settle
  Future<void> tapAndSettle(Finder finder) async {
    await tap(finder);
    await pumpAndSettle();
  }

  /// Enter text and wait for UI to update
  Future<void> enterTextAndSettle(Finder finder, String text) async {
    await enterText(finder, text);
    await pumpAndSettle();
  }

  /// Scroll until a widget is visible
  Future<void> scrollUntilVisible(
    Finder finder,
    Finder scrollable, {
    double delta = 100.0,
    int maxScrolls = 20,
    Duration duration = const Duration(milliseconds: 50),
  }) async {
    int scrolls = 0;

    while (finder.evaluate().isEmpty && scrolls < maxScrolls) {
      await drag(scrollable, Offset(0, -delta));
      await pump(duration);
      scrolls++;
    }

    if (finder.evaluate().isEmpty) {
      throw TestFailure('Widget not found after scrolling: $finder');
    }
  }

  /// Long press and wait for UI to update
  Future<void> longPressAndSettle(Finder finder) async {
    await longPress(finder);
    await pumpAndSettle();
  }

  /// Verify a snackbar appears with the given text
  Future<void> expectSnackbar(String text) async {
    await pumpAndSettle();
    expect(find.text(text), findsOneWidget);
  }

  /// Dismiss any open dialogs
  Future<void> dismissDialog() async {
    final dialogFinder = find.byType(AlertDialog);
    if (dialogFinder.evaluate().isNotEmpty) {
      await tapOutside();
      await pumpAndSettle();
    }
  }

  /// Tap outside of the current widget to dismiss overlays
  Future<void> tapOutside() async {
    await tapAt(Offset.zero);
    await pumpAndSettle();
  }
}

/// Custom finders for common widget patterns
class AppFinders {
  AppFinders._();

  /// Find a button by its text
  static Finder buttonByText(String text) {
    return find.widgetWithText(ElevatedButton, text);
  }

  /// Find a text button by its text
  static Finder textButtonByText(String text) {
    return find.widgetWithText(TextButton, text);
  }

  /// Find an icon button by its icon
  static Finder iconButton(IconData icon) {
    return find.widgetWithIcon(IconButton, icon);
  }

  /// Find a text field by its label
  static Finder textFieldByLabel(String label) {
    return find.widgetWithText(TextField, label);
  }

  /// Find a text field by its hint
  static Finder textFieldByHint(String hint) {
    return find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.hintText == hint,
    );
  }

  /// Find a list tile by its title
  static Finder listTileByTitle(String title) {
    return find.widgetWithText(ListTile, title);
  }

  /// Find a card containing specific text
  static Finder cardWithText(String text) {
    return find.ancestor(
      of: find.text(text),
      matching: find.byType(Card),
    );
  }

  /// Find a bottom navigation bar item by its label
  static Finder bottomNavItem(String label) {
    return find.widgetWithText(NavigationDestination, label);
  }

  /// Find a switch widget
  static Finder switchWidget() {
    return find.byType(Switch);
  }

  /// Find a checkbox widget
  static Finder checkbox() {
    return find.byType(Checkbox);
  }

  /// Find a radio button
  static Finder radio<T>() {
    return find.byType(Radio<T>);
  }

  /// Find a dropdown button
  static Finder dropdown<T>() {
    return find.byType(DropdownButton<T>);
  }

  /// Find a loading indicator
  static Finder loadingIndicator() {
    return find.byType(CircularProgressIndicator);
  }

  /// Find an error message
  static Finder errorMessage(String message) {
    return find.text(message);
  }

  /// Find a snackbar
  static Finder snackbar() {
    return find.byType(SnackBar);
  }

  /// Find a dialog
  static Finder dialog() {
    return find.byType(AlertDialog);
  }

  /// Find a bottom sheet
  static Finder bottomSheet() {
    return find.byType(BottomSheet);
  }
}

/// Matchers for common assertions
class AppMatchers {
  AppMatchers._();

  /// Check if a widget is enabled
  static Matcher isEnabled() {
    return _IsEnabledMatcher(true);
  }

  /// Check if a widget is disabled
  static Matcher isDisabled() {
    return _IsEnabledMatcher(false);
  }

  /// Check if a switch is on
  static Matcher isSwitchedOn() {
    return _SwitchStateMatcher(true);
  }

  /// Check if a switch is off
  static Matcher isSwitchedOff() {
    return _SwitchStateMatcher(false);
  }
}

class _IsEnabledMatcher extends Matcher {
  final bool _expectedEnabled;

  _IsEnabledMatcher(this._expectedEnabled);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is Widget) {
      if (item is ElevatedButton) {
        return (item.onPressed != null) == _expectedEnabled;
      }
      if (item is TextButton) {
        return (item.onPressed != null) == _expectedEnabled;
      }
      if (item is IconButton) {
        return (item.onPressed != null) == _expectedEnabled;
      }
    }
    return false;
  }

  @override
  Description describe(Description description) {
    return description.add(_expectedEnabled ? 'is enabled' : 'is disabled');
  }
}

class _SwitchStateMatcher extends Matcher {
  final bool _expectedState;

  _SwitchStateMatcher(this._expectedState);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is Switch) {
      return item.value == _expectedState;
    }
    return false;
  }

  @override
  Description describe(Description description) {
    return description.add(_expectedState ? 'is switched on' : 'is switched off');
  }
}

/// Test utilities for time-based testing
class TestTime {
  TestTime._();

  /// Get a DateTime for today at the specified time
  static DateTime todayAt(int hour, [int minute = 0]) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  /// Get a DateTime for yesterday at the specified time
  static DateTime yesterdayAt(int hour, [int minute = 0]) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return DateTime(yesterday.year, yesterday.month, yesterday.day, hour, minute);
  }

  /// Get a DateTime for tomorrow at the specified time
  static DateTime tomorrowAt(int hour, [int minute = 0]) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return DateTime(tomorrow.year, tomorrow.month, tomorrow.day, hour, minute);
  }

  /// Get the start of today (midnight)
  static DateTime get startOfToday {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Get the end of today (23:59:59)
  static DateTime get endOfToday {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59);
  }
}

/// Screenshot helper for visual regression testing
class ScreenshotHelper {
  final IntegrationTestWidgetsFlutterBinding binding;
  int _screenshotCount = 0;

  ScreenshotHelper(this.binding);

  /// Take a screenshot with an auto-generated name
  Future<void> take(String name) async {
    _screenshotCount++;
    final screenshotName = '${_screenshotCount.toString().padLeft(3, '0')}_$name';
    await binding.takeScreenshot(screenshotName);
  }

  /// Take a screenshot on test failure
  Future<void> takeOnFailure(String testName) async {
    await binding.takeScreenshot('failure_$testName');
  }
}
