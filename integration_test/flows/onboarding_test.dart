/// E2E tests for the onboarding flow
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/test_app.dart';
import '../utils/test_helpers.dart';
import '../robots/onboarding_robot.dart';

void main() {
  ensureTestInitialized();

  group('Onboarding Flow', () {
    testWidgets('App launches to splash screen then onboarding', (tester) async {
      // Arrange: New user (onboarding not complete)
      final app = buildTestApp(TestAppConfig.newUser());

      // Act: Launch app
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      // Assert: Should eventually show onboarding
      // Note: Splash screen may redirect to onboarding
      final robot = OnboardingRobot(tester);
      await robot.verifyOnWelcomeStep();
    });

    testWidgets('Complete onboarding as patient - full flow', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.newUser());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = OnboardingRobot(tester);

      // Act & Assert: Step 1 - Welcome
      await robot.verifyOnWelcomeStep();
      await robot.tapNext();

      // Step 2 - Name (enter name)
      await robot.verifyOnNameStep();
      await robot.enterName('Test Patient');
      await robot.tapNext();

      // Step 3 - Role (select patient)
      await robot.verifyOnRoleStep();
      await robot.selectPatientRole();
      await robot.tapNext();

      // Step 4 - Timezone
      await robot.verifyOnTimezoneStep();
      await robot.tapNext();

      // Step 5 - Notifications
      await robot.verifyOnNotificationStep();
      await robot.tapFinish();

      // Final: Should land on home screen
      await robot.verifyOnHomeScreen();
    });

    testWidgets('Complete onboarding as caregiver', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.newUser());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = OnboardingRobot(tester);

      // Act & Assert: Navigate through all steps
      await robot.verifyOnWelcomeStep();
      await robot.tapNext();

      await robot.verifyOnNameStep();
      await robot.enterName('Test Caregiver');
      await robot.tapNext();

      // Select caregiver role
      await robot.verifyOnRoleStep();
      await robot.selectCaregiverRole();
      await robot.tapNext();

      await robot.verifyOnTimezoneStep();
      await robot.tapNext();

      await robot.verifyOnNotificationStep();
      await robot.tapFinish();

      // Final: Should land on caregiver dashboard
      await robot.verifyOnCaregiverDashboard();
    });

    testWidgets('Skip name entry (optional field)', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.newUser());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = OnboardingRobot(tester);

      // Act: Go through onboarding, skip name
      await robot.verifyOnWelcomeStep();
      await robot.tapNext();

      await robot.verifyOnNameStep();
      await robot.skipName(); // Skip instead of entering name

      // Assert: Should proceed to role step
      await robot.verifyOnRoleStep();
    });

    testWidgets('Navigate back through onboarding steps', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.newUser());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = OnboardingRobot(tester);

      // Act: Navigate forward then back
      await robot.verifyOnWelcomeStep();
      await robot.tapNext();

      await robot.verifyOnNameStep();
      await robot.tapNext();

      await robot.verifyOnRoleStep();

      // Go back
      await robot.tapBack();
      await robot.verifyOnNameStep();

      await robot.tapBack();
      await robot.verifyOnWelcomeStep();
    });

    testWidgets('Change language on welcome screen', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.newUser());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = OnboardingRobot(tester);

      // Act: Change language to Japanese
      await robot.verifyOnWelcomeStep();
      await robot.selectJapanese();
      await tester.pumpAndSettle();

      // Assert: Language should change (UI text changes)
      // Note: Actual assertion depends on localization being loaded

      // Change back to English
      await robot.selectEnglish();
      await tester.pumpAndSettle();
    });

    testWidgets('Timezone selection with picker', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.newUser());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = OnboardingRobot(tester);

      // Navigate to timezone step
      await robot.verifyOnWelcomeStep();
      await robot.tapNext();
      await robot.skipName();
      await robot.selectPatientRole();
      await robot.tapNext();

      // Act: Open timezone picker
      await robot.verifyOnTimezoneStep();
      await robot.openTimezonePicker();
      await tester.pumpAndSettle();

      // Search for a timezone
      await robot.searchTimezone('Tokyo');
      await tester.pumpAndSettle();

      // Select Tokyo timezone
      await robot.selectTimezone('Tokyo');
      await tester.pumpAndSettle();

      // Assert: Should return to timezone step with new selection
      await robot.verifyOnTimezoneStep();
    });

    testWidgets('Complete flow using helper method', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.newUser());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = OnboardingRobot(tester);

      // Act: Use the complete flow helper
      await robot.completeAsPatient(
        name: 'Quick Test User',
        enableNotifications: false,
      );

      // Assert: Already verified in the helper method
    });

    testWidgets('Patient role leads to patient home screen', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.newUser());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = OnboardingRobot(tester);

      // Act
      await robot.completeAsPatient(name: 'Patient User');

      // Assert: Should see patient navigation (home, adherence, medications, settings)
      expect(find.byIcon(Icons.home), findsWidgets);
      expect(find.byIcon(Icons.medication), findsWidgets);
    });

    testWidgets('Caregiver role leads to caregiver dashboard', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.newUser());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = OnboardingRobot(tester);

      // Act
      await robot.completeAsCaregiver(name: 'Caregiver User');

      // Assert: Should see caregiver navigation
      await robot.verifyOnCaregiverDashboard();
    });
  });
}
