/// E2E tests for the patient-side Settings screen
library;

import 'package:flutter_test/flutter_test.dart';

import '../utils/test_app.dart';
import '../utils/test_helpers.dart';
import '../robots/settings_robot.dart';

void main() {
  ensureTestInitialized();

  group('Settings Screen — Account Section', () {
    testWidgets('PS-01: Account section is displayed', (tester) async {
      // Arrange: Patient with completed onboarding
      final app = buildPatientTestApp(TestAppConfig.patient());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = SettingsRobot(tester);

      // Assert: Settings screen loaded with account section visible
      await robot.verifyAccountSectionDisplayed();
    });
  });

  group('Settings Screen — Notifications Section', () {
    testWidgets('PS-02: Notifications section elements are displayed',
        (tester) async {
      // Arrange
      final app = buildPatientTestApp(TestAppConfig.patient());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = SettingsRobot(tester);

      // Assert: Notifications header and all toggles visible
      await robot.verifyNotificationsSectionDisplayed();
    });
  });

  group('Settings Screen — Features Section', () {
    testWidgets('PS-03: Family & Caregivers item is displayed',
        (tester) async {
      // Arrange
      final app = buildPatientTestApp(TestAppConfig.patient());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = SettingsRobot(tester);

      // Assert: Family & Caregivers ListTile visible (may need scroll)
      await robot.verifyFamilyCaregiversDisplayed();
    });

    testWidgets('PS-04: Family & Caregivers tap navigates to FamilyScreen',
        (tester) async {
      // Arrange
      final app = buildPatientTestApp(TestAppConfig.patient());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = SettingsRobot(tester);

      // Act: Tap Family & Caregivers
      await robot.tapFamilyCaregivers();

      // Assert: Navigated to FamilyScreen
      await robot.verifyOnFamilyScreen();
    });
  });

  group('Settings Screen — Sign Out', () {
    testWidgets('PS-05: Log Out tap shows confirmation dialog',
        (tester) async {
      // Arrange
      final app = buildPatientTestApp(TestAppConfig.patient());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = SettingsRobot(tester);

      // Act: Scroll to and tap Log Out
      await robot.tapLogOut();

      // Assert: Confirmation dialog is shown
      await robot.verifyLogOutDialogShown();
    });

    testWidgets('PS-06: Cancel in Log Out dialog stays on Settings',
        (tester) async {
      // Arrange
      final app = buildPatientTestApp(TestAppConfig.patient());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = SettingsRobot(tester);

      // Act: Open dialog then cancel
      await robot.tapLogOut();
      await robot.verifyLogOutDialogShown();
      await robot.tapCancelInDialog();

      // Assert: Still on Settings screen, dialog dismissed
      await robot.verifyOnSettingsScreen();
      expect(robot.logOutDialogMessage, findsNothing);
    });
  });

  group('Settings Screen — Language Section', () {
    testWidgets('PS-07: Language section with English and Japanese buttons',
        (tester) async {
      // Arrange
      final app = buildPatientTestApp(TestAppConfig.patient());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = SettingsRobot(tester);

      // Assert: Language header and both buttons visible
      await robot.verifyLanguageSectionDisplayed();
    });
  });
}
