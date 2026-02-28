/// Robot/Page Object for patient-side Settings screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Robot pattern class for interacting with SettingsScreen (/settings)
class SettingsRobot {
  final WidgetTester tester;

  SettingsRobot(this.tester);

  // ===== FINDERS =====

  // Screen title (MpAppBar)
  Finder get settingsTitle => find.text('Settings');

  // Language section
  Finder get languageHeader => find.text('Language');
  Finder get englishButton => find.text('English');
  Finder get japaneseButton => find.text('\u65E5\u672C\u8A9E');

  // Notifications section
  Finder get notificationsHeader => find.text('Notifications');
  Finder get pushNotifications => find.text('Push Notifications');
  Finder get criticalAlerts => find.text('Critical Alerts');
  Finder get snoozeDuration => find.text('Snooze Duration');

  // Features section
  Finder get featuresHeader => find.text('Features');
  Finder get familyCaregivers => find.text('Family & Caregivers');
  Finder get travelMode => find.text('Travel Mode');

  // Safety & Privacy section
  Finder get safetyPrivacyHeader => find.text('Safety & Privacy');
  Finder get dataSharingPreferences => find.text('Data Sharing Preferences');
  Finder get backupAndSync => find.text('Backup & Sync');
  Finder get privacyPolicy => find.text('Privacy Policy');
  Finder get termsOfService => find.text('Terms of Service');

  // About section
  Finder get aboutHeader => find.text('About');
  Finder get appVersion => find.text('App Version');
  Finder get versionNumber => find.text('Version 1.0.0');

  // Advanced section
  Finder get advancedHeader => find.text('Advanced');
  Finder get logOutTile => find.widgetWithText(ListTile, 'Log Out');
  Finder get deleteAccountTile =>
      find.widgetWithText(ListTile, 'Delete Account');

  // Log Out confirmation dialog
  Finder get logOutDialogMessage => find.textContaining('You will be signed out');
  Finder get cancelButton => find.text('Cancel');

  // Navigation target: FamilyScreen
  Finder get linkedCaregiversSection => find.text('Linked Caregivers');

  // ===== ASSERTIONS =====

  /// Verify we're on the Settings screen
  Future<void> verifyOnSettingsScreen() async {
    await tester.pumpAndSettle();
    expect(settingsTitle, findsOneWidget);
  }

  /// Verify Account section renders (the body loaded successfully)
  Future<void> verifyAccountSectionDisplayed() async {
    await tester.pumpAndSettle();
    // When userSettingsProvider resolves, the SingleChildScrollView body
    // renders. AccountSection is the first child — verify the next section
    // (Language) also loaded, proving the body is visible.
    expect(settingsTitle, findsOneWidget);
    expect(languageHeader, findsOneWidget);
  }

  /// Verify Notifications section elements are displayed
  Future<void> verifyNotificationsSectionDisplayed() async {
    await tester.pumpAndSettle();
    expect(notificationsHeader, findsOneWidget);
    expect(pushNotifications, findsOneWidget);
    expect(criticalAlerts, findsOneWidget);
    expect(snoozeDuration, findsOneWidget);
  }

  /// Verify Family & Caregivers item is displayed
  Future<void> verifyFamilyCaregiversDisplayed() async {
    await _scrollTo(familyCaregivers);
    expect(familyCaregivers, findsOneWidget);
  }

  /// Verify Language section is displayed
  Future<void> verifyLanguageSectionDisplayed() async {
    await tester.pumpAndSettle();
    expect(languageHeader, findsOneWidget);
    expect(englishButton, findsOneWidget);
    expect(japaneseButton, findsOneWidget);
  }

  /// Verify Log Out dialog is shown
  Future<void> verifyLogOutDialogShown() async {
    await tester.pumpAndSettle();
    expect(logOutDialogMessage, findsOneWidget);
  }

  /// Verify navigated to FamilyScreen
  Future<void> verifyOnFamilyScreen() async {
    await tester.pumpAndSettle();
    expect(linkedCaregiversSection, findsOneWidget);
  }

  // ===== ACTIONS =====

  /// Tap Family & Caregivers ListTile
  Future<void> tapFamilyCaregivers() async {
    await _scrollAndTap(familyCaregivers);
  }

  /// Scroll to and tap Log Out
  Future<void> tapLogOut() async {
    await _scrollAndTap(logOutTile);
  }

  /// Tap Cancel in the Log Out dialog
  Future<void> tapCancelInDialog() async {
    await tester.tap(cancelButton);
    await tester.pumpAndSettle();
  }

  // ===== HELPERS =====

  /// Scroll to make a finder visible
  Future<void> _scrollTo(Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      50.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  /// Scroll to a finder and tap it
  Future<void> _scrollAndTap(Finder finder) async {
    await _scrollTo(finder);
    await tester.tap(finder.first);
    await tester.pumpAndSettle();
  }
}
