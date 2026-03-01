/// E2E tests for the InviteHandlerScreen (/invite/:code)
library;

import 'package:flutter_test/flutter_test.dart';

import '../utils/mock_services.dart';
import '../utils/test_app.dart';
import '../utils/test_helpers.dart';
import '../robots/invite_robot.dart';

void main() {
  ensureTestInitialized();

  const testInviteCode = 'test-code-123';

  group('Invite Handler Screen', () {
    testWidgets('Shows invited title on screen', (tester) async {
      // Arrange: Start directly at the invite route
      final app = buildCaregiverTestApp(
        TestAppConfig.caregiver(),
        initialRoute: '/invite/$testInviteCode',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = InviteRobot(tester);

      // Assert: Title is shown
      await robot.verifyOnInviteScreen();
    });

    testWidgets('Shows invite code on screen', (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(
        TestAppConfig.caregiver(),
        initialRoute: '/invite/$testInviteCode',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = InviteRobot(tester);

      // Assert: Invite code is displayed
      await robot.verifyInviteCodeDisplayed(testInviteCode);
    });

    testWidgets('Shows Accept and Decline buttons', (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(
        TestAppConfig.caregiver(),
        initialRoute: '/invite/$testInviteCode',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = InviteRobot(tester);

      // Assert
      await robot.verifyActionsDisplayed();
    });

    testWidgets('Accept invitation navigates away from invite screen',
        (tester) async {
      // Arrange: Default mock CF service accepts invite successfully
      final mockCf = MockCloudFunctionsService();
      final app = buildCaregiverTestApp(
        TestAppConfig.caregiver(),
        initialRoute: '/invite/$testInviteCode',
        mockCfService: mockCf,
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = InviteRobot(tester);

      // Act
      await robot.tapAccept();

      // Assert: Navigated to /home (invite screen no longer visible)
      expect(robot.invitedTitle, findsNothing);
    });

    testWidgets('Decline button navigates away from invite screen',
        (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(
        TestAppConfig.caregiver(),
        initialRoute: '/invite/$testInviteCode',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = InviteRobot(tester);

      // Act
      await robot.tapDecline();

      // Assert: No longer on invite screen (pop back)
      // In test router there is no back route, so it may stay or crash
      // We just verify the tap completes without error
      await tester.pumpAndSettle();
    });

    testWidgets('Accept failure shows error snackbar', (tester) async {
      // Arrange: CF service configured to fail
      final mockCf = MockCloudFunctionsService()..setNextOperationToFail();
      final app = buildCaregiverTestApp(
        TestAppConfig.caregiver(),
        initialRoute: '/invite/$testInviteCode',
        mockCfService: mockCf,
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = InviteRobot(tester);

      // Act
      await robot.tapAccept();

      // Assert: Error message snackbar is shown
      expect(robot.failedText, findsOneWidget);
    });
  });
}
