/// E2E tests for the caregiver dashboard and tab navigation
library;

import 'package:flutter_test/flutter_test.dart';

import '../utils/test_app.dart';
import '../utils/test_data.dart';
import '../utils/test_helpers.dart';
import '../robots/caregiver_robot.dart';

void main() {
  ensureTestInitialized();

  group('Caregiver Dashboard — Empty State', () {
    testWidgets('Shows My Patients title', (tester) async {
      // Arrange: Caregiver with no patients linked
      final app = buildCaregiverTestApp(TestAppConfig.caregiver());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = CaregiverRobot(tester);

      // Assert: Dashboard title is visible
      await robot.verifyOnDashboard();
    });

    testWidgets('Shows empty state when no patients linked', (tester) async {
      // Arrange: Caregiver with no patients — auth is null so provider returns []
      final app = buildCaregiverTestApp(TestAppConfig.caregiver());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = CaregiverRobot(tester);

      // Assert: Empty state with Scan QR Code button is shown
      await robot.verifyEmptyDashboard();
    });

    testWidgets('Scan QR Code button is visible in empty state', (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(TestAppConfig.caregiver());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = CaregiverRobot(tester);

      // Assert
      expect(robot.scanQrCodeButton, findsOneWidget);
    });
  });

  group('Caregiver Dashboard — With Patients', () {
    testWidgets('Shows patient card when patients are linked', (tester) async {
      // Arrange: Provide a linked patient via override
      final app = buildCaregiverTestApp(
        TestAppConfig.caregiver(),
        patientsOverride: [
          (
            patientId: TestData.linkedPatientData['patientId'] as String,
            patientName: TestData.linkedPatientData['patientName'] as String,
            linkedAt: null,
          ),
        ],
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = CaregiverRobot(tester);

      // Assert: Patient name is displayed
      await robot.verifyPatientCardDisplayed('Tanaka Hanako');
    });

    testWidgets('Dashboard title still shows with patients', (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(
        TestAppConfig.caregiver(),
        patientsOverride: [
          (patientId: 'p-1', patientName: 'Test Patient', linkedAt: null),
        ],
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = CaregiverRobot(tester);

      // Assert: "My Patients" title and patient card both visible
      await robot.verifyOnDashboard();
      await robot.verifyPatientCardDisplayed('Test Patient');
    });
  });

  group('Caregiver Tab Navigation', () {
    testWidgets('Navigate to Notifications tab', (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(TestAppConfig.caregiver());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = CaregiverRobot(tester);

      // Act
      await robot.goToNotifications();

      // Assert
      await robot.verifyOnNotifications();
    });

    testWidgets('Navigate to Alerts tab', (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(TestAppConfig.caregiver());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = CaregiverRobot(tester);

      // Act
      await robot.goToAlerts();

      // Assert
      await robot.verifyOnAlerts();
    });

    testWidgets('Navigate to Settings tab', (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(TestAppConfig.caregiver());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = CaregiverRobot(tester);

      // Act
      await robot.goToSettings();

      // Assert
      await robot.verifyOnSettings();
    });

    testWidgets('Navigate through all 4 tabs', (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(TestAppConfig.caregiver());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = CaregiverRobot(tester);

      // Act & Assert: Traverse all tabs
      await robot.verifyOnDashboard();
      await robot.goToNotifications();
      await robot.verifyOnNotifications();
      await robot.goToAlerts();
      await robot.verifyOnAlerts();
      await robot.goToSettings();
      await robot.verifyOnSettings();
      await robot.goToPatients();
      await robot.verifyOnDashboard();
    });
  });

  group('Caregiver Notifications Tab', () {
    testWidgets('Shows no notifications placeholder', (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(
        TestAppConfig.caregiver(),
        initialRoute: '/caregiver/notifications',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = CaregiverRobot(tester);

      // Assert
      await robot.verifyOnNotifications();
    });
  });

  group('Caregiver Dashboard — QR Scan Navigation', () {
    testWidgets('CQ-01: Scan QR Code button tap navigates to QrScannerScreen',
        (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(TestAppConfig.caregiver());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = CaregiverRobot(tester);

      // Act
      await robot.tapScanQrCodeButton();

      // Assert: QrScannerScreen is shown (unique instruction overlay text)
      await robot.verifyQrScannerScreenShown();
    });

    testWidgets(
        'CQ-02: QrScannerScreen shows guide overlay and AppBar title',
        (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(TestAppConfig.caregiver());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = CaregiverRobot(tester);

      // Act
      await robot.tapScanQrCodeButton();

      // Assert: instruction overlay and AppBar title are both visible
      await robot.verifyQrScannerScreenShown();
      // AppBar title matches scanQrCode l10n key (findsWidgets: button is gone,
      // only the AppBar title remains after navigation)
      expect(find.text('Scan QR Code'), findsOneWidget);
    });

    testWidgets(
        'CQ-03: No valid QR code scanned — screen remains, no crash',
        (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(TestAppConfig.caregiver());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = CaregiverRobot(tester);

      // Act: open scanner and wait without scanning any QR code
      await robot.tapScanQrCodeButton();
      await tester.pump(const Duration(seconds: 1));

      // Assert: screen is still visible — no unhandled exception, no pop
      await robot.verifyQrScannerScreenShown();
    });
  });

  group('Caregiver Alerts Tab', () {
    testWidgets('Shows alert type cards', (tester) async {
      // Arrange
      final app = buildCaregiverTestApp(
        TestAppConfig.caregiver(),
        initialRoute: '/caregiver/alerts',
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = CaregiverRobot(tester);

      // Assert: Missed Dose and Low Stock alert type previews are shown
      await robot.verifyOnAlerts();
      await robot.verifyAlertTypesDisplayed();
    });
  });
}
