/// E2E tests for the caregiver settings screen
library;

import 'package:flutter_test/flutter_test.dart';

import '../utils/test_app.dart';
import '../utils/test_helpers.dart';
import '../robots/caregiver_robot.dart';

void main() {
  ensureTestInitialized();

  group('Caregiver Settings', () {
    testWidgets('Settings screen shows Switch to Patient View option',
        (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(
        TestAppConfig.caregiver(),
        initialRoute: '/caregiver/settings',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = CaregiverRobot(tester);

      // Assert: Key settings items are visible
      await robot.verifyOnSettings();
      expect(robot.switchToPatientViewOption, findsOneWidget);
    });

    testWidgets('Settings screen shows Sign Out option', (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(
        TestAppConfig.caregiver(),
        initialRoute: '/caregiver/settings',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = CaregiverRobot(tester);

      // Assert
      expect(robot.signOutOption, findsOneWidget);
    });

    testWidgets('Switch to Patient View navigates to /home', (tester) async {
      // Arrange: test router has /home → empty Scaffold
      final app = buildCaregiverTestApp(
        TestAppConfig.caregiver(),
        initialRoute: '/caregiver/settings',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = CaregiverRobot(tester);

      // Act
      await robot.tapSwitchToPatientView();

      // Assert: No longer on settings (settings options gone)
      expect(robot.switchToPatientViewOption, findsNothing);
    });

    testWidgets('Sign Out tap shows confirmation dialog', (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(
        TestAppConfig.caregiver(),
        initialRoute: '/caregiver/settings',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = CaregiverRobot(tester);

      // Act
      await robot.tapSignOut();

      // Assert: Confirmation dialog appears
      expect(robot.signOutConfirmText, findsOneWidget);
      expect(robot.cancelButton, findsOneWidget);
    });

    testWidgets('Sign Out dialog can be cancelled', (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(
        TestAppConfig.caregiver(),
        initialRoute: '/caregiver/settings',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = CaregiverRobot(tester);

      // Act: Open dialog then cancel
      await robot.tapSignOut();
      expect(robot.signOutConfirmText, findsOneWidget);
      await robot.cancelSignOut();

      // Assert: Still on settings screen after cancel
      await robot.verifyOnSettings();
    });
  });
}
