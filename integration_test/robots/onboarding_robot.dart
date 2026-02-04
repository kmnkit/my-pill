/// Robot/Page Object for onboarding flow interactions
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Robot pattern class for interacting with onboarding screens
class OnboardingRobot {
  final WidgetTester tester;

  OnboardingRobot(this.tester);

  // ===== FINDERS =====

  // Welcome step
  Finder get welcomeIcon => find.byIcon(Icons.health_and_safety);
  Finder get nextButton => find.text('Next');
  Finder get languageEnButton => find.text('EN');
  Finder get languageJpButton => find.text('JP');

  // Name step
  Finder get nameIcon => find.byIcon(Icons.person_outline);
  Finder get nameTextField => find.byType(TextField);
  Finder get skipButton => find.textContaining('Skip');
  Finder get backButton => find.byIcon(Icons.arrow_back);

  // Role step
  Finder get roleIcon => find.byIcon(Icons.people_outline);
  Finder get patientOption => find.byIcon(Icons.person);
  Finder get caregiverOption => find.byIcon(Icons.favorite);

  // Timezone step
  Finder get timezoneIcon => find.byIcon(Icons.access_time);
  Finder get changeTimezoneButton => find.byIcon(Icons.edit);
  Finder get timezoneSearchField => find.byType(TextField);

  // Notification step
  Finder get notificationIcon => find.byIcon(Icons.notifications_outlined);
  Finder get enableNotificationsButton => find.textContaining('Enable');
  Finder get skipNotificationsButton => find.textContaining('Skip');
  Finder get finishButton => find.text('Finish');

  // Progress indicator
  Finder get progressIndicator => find.byType(LinearProgressIndicator);

  // ===== ASSERTIONS =====

  /// Verify we're on the welcome step
  Future<void> verifyOnWelcomeStep() async {
    await tester.pumpAndSettle();
    expect(welcomeIcon, findsOneWidget);
    expect(find.textContaining('Welcome'), findsOneWidget);
  }

  /// Verify we're on the name step
  Future<void> verifyOnNameStep() async {
    await tester.pumpAndSettle();
    expect(nameIcon, findsOneWidget);
    expect(nameTextField, findsOneWidget);
  }

  /// Verify we're on the role step
  Future<void> verifyOnRoleStep() async {
    await tester.pumpAndSettle();
    expect(roleIcon, findsOneWidget);
    expect(patientOption, findsOneWidget);
    expect(caregiverOption, findsOneWidget);
  }

  /// Verify we're on the timezone step
  Future<void> verifyOnTimezoneStep() async {
    await tester.pumpAndSettle();
    expect(timezoneIcon, findsOneWidget);
  }

  /// Verify we're on the notification step
  Future<void> verifyOnNotificationStep() async {
    await tester.pumpAndSettle();
    expect(notificationIcon, findsOneWidget);
    expect(finishButton, findsOneWidget);
  }

  /// Verify onboarding is complete and we're on home screen
  Future<void> verifyOnHomeScreen() async {
    await tester.pumpAndSettle();
    // Look for home screen indicators - bottom navigation
    expect(find.byIcon(Icons.home), findsWidgets);
  }

  /// Verify we're on caregiver dashboard
  Future<void> verifyOnCaregiverDashboard() async {
    await tester.pumpAndSettle();
    // Look for caregiver dashboard indicators
    expect(find.textContaining('Patient'), findsWidgets);
  }

  // ===== ACTIONS =====

  /// Tap the next button
  Future<void> tapNext() async {
    await tester.tap(nextButton.first);
    await tester.pumpAndSettle();
  }

  /// Tap the back button
  Future<void> tapBack() async {
    await tester.tap(backButton.first);
    await tester.pumpAndSettle();
  }

  /// Select English language
  Future<void> selectEnglish() async {
    await tester.tap(languageEnButton);
    await tester.pumpAndSettle();
  }

  /// Select Japanese language
  Future<void> selectJapanese() async {
    await tester.tap(languageJpButton);
    await tester.pumpAndSettle();
  }

  /// Enter a name in the name field
  Future<void> enterName(String name) async {
    await tester.enterText(nameTextField, name);
    await tester.pumpAndSettle();
  }

  /// Skip the name entry
  Future<void> skipName() async {
    await tester.tap(skipButton.first);
    await tester.pumpAndSettle();
  }

  /// Select patient role
  Future<void> selectPatientRole() async {
    await tester.tap(patientOption);
    await tester.pumpAndSettle();
  }

  /// Select caregiver role
  Future<void> selectCaregiverRole() async {
    await tester.tap(caregiverOption);
    await tester.pumpAndSettle();
  }

  /// Open timezone picker
  Future<void> openTimezonePicker() async {
    await tester.tap(changeTimezoneButton);
    await tester.pumpAndSettle();
  }

  /// Search for a timezone in the picker
  Future<void> searchTimezone(String query) async {
    final searchField = find.byType(TextField).last;
    await tester.enterText(searchField, query);
    await tester.pumpAndSettle();
  }

  /// Select a timezone from the picker by its display name
  Future<void> selectTimezone(String displayName) async {
    await tester.tap(find.text(displayName).first);
    await tester.pumpAndSettle();
  }

  /// Enable notifications
  Future<void> enableNotifications() async {
    if (enableNotificationsButton.evaluate().isNotEmpty) {
      await tester.tap(enableNotificationsButton.first);
      await tester.pumpAndSettle();
    }
  }

  /// Skip notifications
  Future<void> skipNotifications() async {
    if (skipNotificationsButton.evaluate().isNotEmpty) {
      await tester.tap(skipNotificationsButton.first);
      await tester.pumpAndSettle();
    }
  }

  /// Finish onboarding
  Future<void> tapFinish() async {
    await tester.tap(finishButton);
    await tester.pumpAndSettle();
  }

  // ===== FLOWS =====

  /// Complete the full onboarding flow as a patient
  Future<void> completeAsPatient({
    String? name,
    bool enableNotifications = false,
  }) async {
    // Step 1: Welcome
    await verifyOnWelcomeStep();
    await tapNext();

    // Step 2: Name
    await verifyOnNameStep();
    if (name != null && name.isNotEmpty) {
      await enterName(name);
      await tapNext();
    } else {
      await skipName();
    }

    // Step 3: Role
    await verifyOnRoleStep();
    await selectPatientRole();
    await tapNext();

    // Step 4: Timezone
    await verifyOnTimezoneStep();
    await tapNext();

    // Step 5: Notifications
    await verifyOnNotificationStep();
    if (enableNotifications) {
      await this.enableNotifications();
    }
    await tapFinish();

    // Verify landing on home screen
    await verifyOnHomeScreen();
  }

  /// Complete the full onboarding flow as a caregiver
  Future<void> completeAsCaregiver({
    String? name,
    bool enableNotifications = false,
  }) async {
    // Step 1: Welcome
    await verifyOnWelcomeStep();
    await tapNext();

    // Step 2: Name
    await verifyOnNameStep();
    if (name != null && name.isNotEmpty) {
      await enterName(name);
      await tapNext();
    } else {
      await skipName();
    }

    // Step 3: Role
    await verifyOnRoleStep();
    await selectCaregiverRole();
    await tapNext();

    // Step 4: Timezone
    await verifyOnTimezoneStep();
    await tapNext();

    // Step 5: Notifications
    await verifyOnNotificationStep();
    if (enableNotifications) {
      await this.enableNotifications();
    }
    await tapFinish();

    // Verify landing on caregiver dashboard
    await verifyOnCaregiverDashboard();
  }
}
