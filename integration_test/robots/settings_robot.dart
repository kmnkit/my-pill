/// Robot/Page Object for settings screen interactions
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Robot pattern class for interacting with settings screens
class SettingsRobot {
  final WidgetTester tester;

  SettingsRobot(this.tester);

  // ===== FINDERS =====

  // Settings screen elements
  Finder get settingsTitle => find.text('Settings');

  // Profile section
  Finder get profileSection => find.text('Profile');
  Finder get nameField => find.textContaining('Name');
  Finder get languageSelector => find.textContaining('Language');

  // Appearance section
  Finder get appearanceSection => find.text('Appearance');
  Finder get highContrastToggle => find.textContaining('High Contrast');
  Finder get textSizeSelector => find.textContaining('Text Size');

  // Notifications section
  Finder get notificationsSection => find.text('Notifications');
  Finder get notificationsToggle => find.textContaining('Notifications');
  Finder get criticalAlertsToggle => find.textContaining('Critical Alerts');
  Finder get snoozeSettings => find.textContaining('Snooze');

  // Travel mode
  Finder get travelModeOption => find.textContaining('Travel Mode');

  // Family/Caregivers
  Finder get familyOption => find.textContaining('Family');
  Finder get caregiversOption => find.textContaining('Caregiver');

  // Premium
  Finder get premiumOption => find.textContaining('Premium');
  Finder get removeAdsOption => find.textContaining('Remove Ads');

  // Account section
  Finder get accountSection => find.text('Account');
  Finder get signOutButton => find.text('Sign Out');
  Finder get deleteAccountButton => find.text('Delete Account');

  // About section
  Finder get aboutSection => find.text('About');
  Finder get versionInfo => find.textContaining('Version');
  Finder get privacyPolicy => find.text('Privacy Policy');
  Finder get termsOfService => find.text('Terms of Service');

  // Back button
  Finder get backButton => find.byIcon(Icons.arrow_back);

  // ===== ASSERTIONS =====

  /// Verify we're on the settings screen
  Future<void> verifyOnSettingsScreen() async {
    await tester.pumpAndSettle();
    expect(settingsTitle, findsOneWidget);
  }

  /// Verify travel mode screen
  Future<void> verifyOnTravelModeScreen() async {
    await tester.pumpAndSettle();
    expect(find.textContaining('Travel'), findsWidgets);
  }

  /// Verify family/caregivers screen
  Future<void> verifyOnFamilyScreen() async {
    await tester.pumpAndSettle();
    expect(find.textContaining('Family'), findsWidgets);
  }

  /// Verify premium screen
  Future<void> verifyOnPremiumScreen() async {
    await tester.pumpAndSettle();
    expect(find.textContaining('Premium'), findsWidgets);
  }

  // ===== ACTIONS =====

  /// Navigate to travel mode settings
  Future<void> openTravelMode() async {
    await _scrollAndTap(travelModeOption);
  }

  /// Navigate to family/caregivers settings
  Future<void> openFamilyCaregivers() async {
    await _scrollAndTap(familyOption);
  }

  /// Navigate to premium screen
  Future<void> openPremium() async {
    await _scrollAndTap(premiumOption);
  }

  /// Toggle high contrast mode
  Future<void> toggleHighContrast() async {
    await _scrollAndTap(highContrastToggle);
  }

  /// Toggle notifications
  Future<void> toggleNotifications() async {
    await _scrollAndTap(notificationsToggle);
  }

  /// Toggle critical alerts
  Future<void> toggleCriticalAlerts() async {
    await _scrollAndTap(criticalAlertsToggle);
  }

  /// Change language
  Future<void> changeLanguage(String language) async {
    await _scrollAndTap(languageSelector);
    await tester.pumpAndSettle();
    await tester.tap(find.text(language).last);
    await tester.pumpAndSettle();
  }

  /// Change text size
  Future<void> changeTextSize(String size) async {
    await _scrollAndTap(textSizeSelector);
    await tester.pumpAndSettle();
    await tester.tap(find.text(size).last);
    await tester.pumpAndSettle();
  }

  /// Sign out
  Future<void> signOut() async {
    await _scrollAndTap(signOutButton);
    // Confirm if dialog appears
    final confirmButton = find.text('Sign Out').last;
    if (confirmButton.evaluate().isNotEmpty) {
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();
    }
  }

  /// Request account deletion
  Future<void> deleteAccount() async {
    await _scrollAndTap(deleteAccountButton);
    // Confirm if dialog appears
    final confirmButton = find.text('Delete');
    if (confirmButton.evaluate().isNotEmpty) {
      await tester.tap(confirmButton.last);
      await tester.pumpAndSettle();
    }
  }

  /// Go back
  Future<void> goBack() async {
    await tester.tap(backButton);
    await tester.pumpAndSettle();
  }

  /// Helper to scroll to and tap a widget
  Future<void> _scrollAndTap(Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      50.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(finder.first);
    await tester.pumpAndSettle();
  }

  /// Scroll down in settings
  Future<void> scrollDown() async {
    await tester.drag(
      find.byType(Scrollable).first,
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
  }

  /// Scroll up in settings
  Future<void> scrollUp() async {
    await tester.drag(
      find.byType(Scrollable).first,
      const Offset(0, 200),
    );
    await tester.pumpAndSettle();
  }

  // ===== FLOWS =====

  /// Enable travel mode
  Future<void> enableTravelMode() async {
    await openTravelMode();
    await verifyOnTravelModeScreen();
    // Toggle travel mode on
    final toggleSwitch = find.byType(Switch).first;
    await tester.tap(toggleSwitch);
    await tester.pumpAndSettle();
    await goBack();
  }

  /// Disable travel mode
  Future<void> disableTravelMode() async {
    await openTravelMode();
    await verifyOnTravelModeScreen();
    // Toggle travel mode off
    final toggleSwitch = find.byType(Switch).first;
    await tester.tap(toggleSwitch);
    await tester.pumpAndSettle();
    await goBack();
  }
}
