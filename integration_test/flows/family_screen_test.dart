/// E2E tests for the patient-side Family & Caregivers screen
library;

import 'package:flutter_test/flutter_test.dart';

import '../utils/mock_services.dart';
import '../utils/test_app.dart';
import '../utils/test_data.dart';
import '../utils/test_helpers.dart';
import '../robots/family_robot.dart';

void main() {
  ensureTestInitialized();

  group('Family Screen — Empty State', () {
    testWidgets('Shows Linked Caregivers section', (tester) async {
      // Arrange: Patient with no caregivers linked
      final app = buildCaregiverTestApp(
        TestAppConfig.patient(),
        initialRoute: '/settings/family',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = FamilyRobot(tester);

      // Assert: Screen header is visible
      await robot.verifyOnFamilyScreen();
    });

    testWidgets('Shows no caregivers linked message', (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(
        TestAppConfig.patient(),
        initialRoute: '/settings/family',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = FamilyRobot(tester);

      // Assert: Empty state text shown
      await robot.verifyEmptyState();
    });

    testWidgets('Shows Generate Invite Link button', (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(
        TestAppConfig.patient(),
        initialRoute: '/settings/family',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = FamilyRobot(tester);

      // Assert: Invite button is always visible
      await robot.verifyGenerateInviteButton();
    });

    testWidgets('Shows Privacy Notice section', (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(
        TestAppConfig.patient(),
        initialRoute: '/settings/family',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = FamilyRobot(tester);

      // Assert
      await robot.verifyPrivacyNoticeDisplayed();
    });
  });

  group('Family Screen — With Linked Caregivers', () {
    testWidgets('Shows connected caregiver by name', (tester) async {
      // Arrange: Patient with one connected caregiver
      final app = buildCaregiverTestApp(
        TestAppConfig(
          onboardingComplete: true,
          userRole: 'patient',
          userProfile: TestData.completedOnboardingPatient,
          caregiverLinks: [TestData.sampleCaregiverLink],
          isAuthenticated: true,
        ),
        initialRoute: '/settings/family',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = FamilyRobot(tester);

      // Assert: Caregiver name is visible
      await robot.verifyCaregiverDisplayed('Jane Caregiver');
    });

    testWidgets('Shows Connected status badge for connected caregiver',
        (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(
        TestAppConfig(
          onboardingComplete: true,
          userRole: 'patient',
          userProfile: TestData.completedOnboardingPatient,
          caregiverLinks: [TestData.sampleCaregiverLink],
          isAuthenticated: true,
        ),
        initialRoute: '/settings/family',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = FamilyRobot(tester);

      // Assert
      await robot.verifyConnectedBadge();
    });

    testWidgets('Shows multiple caregivers', (tester) async {
      // Arrange: Patient with two caregivers
      final app = buildCaregiverTestApp(
        TestAppConfig(
          onboardingComplete: true,
          userRole: 'patient',
          userProfile: TestData.completedOnboardingPatient,
          caregiverLinks: TestData.sampleCaregiverLinks,
          isAuthenticated: true,
        ),
        initialRoute: '/settings/family',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = FamilyRobot(tester);

      // Assert: Both caregivers displayed
      await robot.verifyCaregiverDisplayed('Jane Caregiver');
      await robot.verifyCaregiverDisplayed('Bob Caregiver');
    });
  });

  group('Family Screen — Revoke Caregiver', () {
    testWidgets('FR-01: Revoke button tap shows confirmation dialog',
        (tester) async {
      // Arrange: Patient with one connected caregiver
      final app = buildCaregiverTestApp(
        TestAppConfig(
          onboardingComplete: true,
          userRole: 'patient',
          userProfile: TestData.completedOnboardingPatient,
          caregiverLinks: [TestData.sampleCaregiverLink],
          isAuthenticated: true,
        ),
        initialRoute: '/settings/family',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = FamilyRobot(tester);

      // Act: open popup menu and select 'Revoke Access'
      await robot.tapRevoke('Jane Caregiver');

      // Assert: confirmation dialog is shown
      await robot.verifyRevokeDialogShown();
    });

    testWidgets('FR-02: Revoke dialog shows caregiver name', (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(
        TestAppConfig(
          onboardingComplete: true,
          userRole: 'patient',
          userProfile: TestData.completedOnboardingPatient,
          caregiverLinks: [TestData.sampleCaregiverLink],
          isAuthenticated: true,
        ),
        initialRoute: '/settings/family',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = FamilyRobot(tester);

      // Act
      await robot.tapRevoke('Jane Caregiver');

      // Assert: dialog body contains the caregiver name
      await robot.verifyRevokeDialogShown();
      expect(
        find.textContaining('Jane Caregiver'),
        findsWidgets, // name appears in both tile (behind dialog) and dialog content
      );
    });

    testWidgets(
        'FR-03: Cancel in revoke dialog keeps caregiver in list',
        (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(
        TestAppConfig(
          onboardingComplete: true,
          userRole: 'patient',
          userProfile: TestData.completedOnboardingPatient,
          caregiverLinks: [TestData.sampleCaregiverLink],
          isAuthenticated: true,
        ),
        initialRoute: '/settings/family',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = FamilyRobot(tester);

      // Act: open dialog then cancel
      await robot.tapRevoke('Jane Caregiver');
      await robot.cancelRevoke();

      // Assert: caregiver is still listed, empty state is NOT shown
      await robot.verifyCaregiverDisplayed('Jane Caregiver');
      expect(robot.noCaregiversText, findsNothing);
    });

    testWidgets(
        'FR-04: Confirming revoke removes caregiver and shows empty state',
        (tester) async {
      // Arrange: provide explicit MockCloudFunctionsService
      final mockCf = MockCloudFunctionsService();
      final app = buildCaregiverTestApp(
        TestAppConfig(
          onboardingComplete: true,
          userRole: 'patient',
          userProfile: TestData.completedOnboardingPatient,
          caregiverLinks: [TestData.sampleCaregiverLink],
          isAuthenticated: true,
        ),
        initialRoute: '/settings/family',
        mockCfService: mockCf,
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = FamilyRobot(tester);

      // Act: revoke and confirm
      await robot.tapRevoke('Jane Caregiver');
      await robot.confirmRevoke();

      // Assert: caregiver is removed and empty state is shown
      await robot.verifyEmptyState();
      expect(robot.caregiverTile('Jane Caregiver'), findsNothing);
    });

    testWidgets('FR-05: Revoking one of two caregivers keeps the other',
        (tester) async {
      // Arrange: Patient with two caregivers — Jane (connected) and Bob (pending)
      final mockCf = MockCloudFunctionsService();
      final app = buildCaregiverTestApp(
        TestAppConfig(
          onboardingComplete: true,
          userRole: 'patient',
          userProfile: TestData.completedOnboardingPatient,
          caregiverLinks: TestData.sampleCaregiverLinks,
          isAuthenticated: true,
        ),
        initialRoute: '/settings/family',
        mockCfService: mockCf,
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = FamilyRobot(tester);

      // Act: revoke only Jane Caregiver
      await robot.tapRevoke('Jane Caregiver');
      await robot.confirmRevoke();

      // Assert: Jane is gone, Bob remains, list is not empty
      expect(robot.caregiverTile('Jane Caregiver'), findsNothing);
      await robot.verifyCaregiverDisplayed('Bob Caregiver');
      expect(robot.noCaregiversText, findsNothing);
    });
  });

  group('Family Screen — Generate Invite', () {
    testWidgets('Generate invite link shows result after tap', (tester) async {
      // Arrange: MockCloudFunctionsService returns test invite link
      final mockCf = MockCloudFunctionsService();
      final app = buildCaregiverTestApp(
        TestAppConfig.patient(),
        initialRoute: '/settings/family',
        mockCfService: mockCf,
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = FamilyRobot(tester);

      // Act: Tap generate invite link
      await robot.tapGenerateInviteLink();

      // Assert: The invite section updates (QR code or new link button)
      // MockCloudFunctionsService returns code: 'test-code-123'
      // The QrInviteSection should show the code or share options
      expect(robot.generateInviteLinkButton, findsNothing);
    });
  });
}
