/// Robot/Page Object for caregiver shell screens
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Robot pattern class for interacting with caregiver shell screens
class CaregiverRobot {
  final WidgetTester tester;

  CaregiverRobot(this.tester);

  // ===== FINDERS =====

  // Bottom navigation tabs
  Finder get patientsTab => find.byWidgetPredicate(
    (widget) =>
        widget is Icon &&
        (widget.icon == Icons.people ||
            widget.icon == Icons.people_outlined ||
            widget.icon == Icons.people_outline),
  );

  Finder get notificationsTab => find.byWidgetPredicate(
    (widget) =>
        widget is Icon &&
        (widget.icon == Icons.notifications ||
            widget.icon == Icons.notifications_outlined),
  );

  Finder get alertsTab => find.byWidgetPredicate(
    (widget) =>
        widget is Icon &&
        (widget.icon == Icons.warning_amber ||
            widget.icon == Icons.warning_amber_outlined),
  );

  Finder get settingsTab => find.byWidgetPredicate(
    (widget) =>
        widget is Icon &&
        (widget.icon == Icons.settings ||
            widget.icon == Icons.settings_outlined),
  );

  // Dashboard elements
  Finder get myPatientsTitle => find.text('My Patients');
  Finder get noPatientsLinkedText => find.text('No patients linked');
  Finder get scanQrCodeButton => find.text('Scan QR Code');

  /// Find a patient card by patient name
  Finder patientCard(String patientName) => find.text(patientName);

  // Notifications tab elements
  Finder get noNotificationsText => find.text('No notifications yet');

  // Alerts tab elements
  Finder get alertTypesTitle => find.text('Alert Types');
  Finder get missedDoseAlert => find.text('Missed Dose');
  Finder get lowStockAlert => find.text('Low Stock');

  // QR Scanner Screen elements
  Finder get qrScannerInstruction =>
      find.text('Position the QR code within the frame');

  // Settings tab elements
  Finder get switchToPatientViewOption => find.text('Switch to Patient View');
  Finder get signOutOption => find.text('Sign Out');
  Finder get signOutConfirmText =>
      find.text('Are you sure you want to sign out?');
  Finder get cancelButton => find.text('Cancel');

  // ===== ASSERTIONS =====

  /// Verify we're on the dashboard (Patients) tab
  Future<void> verifyOnDashboard() async {
    await tester.pumpAndSettle();
    expect(myPatientsTitle, findsOneWidget);
  }

  /// Verify dashboard shows empty state
  Future<void> verifyEmptyDashboard() async {
    await tester.pumpAndSettle();
    expect(noPatientsLinkedText, findsOneWidget);
    expect(scanQrCodeButton, findsOneWidget);
  }

  /// Verify a patient card is displayed by name
  Future<void> verifyPatientCardDisplayed(String patientName) async {
    await tester.pumpAndSettle();
    expect(patientCard(patientName), findsOneWidget);
  }

  /// Verify we're on the Notifications tab
  Future<void> verifyOnNotifications() async {
    await tester.pumpAndSettle();
    expect(noNotificationsText, findsOneWidget);
  }

  /// Verify we're on the Alerts tab
  Future<void> verifyOnAlerts() async {
    await tester.pumpAndSettle();
    expect(alertTypesTitle, findsOneWidget);
  }

  /// Verify alert type cards are shown
  Future<void> verifyAlertTypesDisplayed() async {
    await tester.pumpAndSettle();
    expect(missedDoseAlert, findsOneWidget);
    expect(lowStockAlert, findsOneWidget);
  }

  /// Verify we're on the Settings tab
  Future<void> verifyOnSettings() async {
    await tester.pumpAndSettle();
    expect(switchToPatientViewOption, findsOneWidget);
    expect(signOutOption, findsOneWidget);
  }

  // ===== ACTIONS =====

  /// Navigate to Patients tab
  Future<void> goToPatients() async {
    await _tapTab(patientsTab, 'Patients tab');
  }

  /// Navigate to Notifications tab
  Future<void> goToNotifications() async {
    await _tapTab(notificationsTab, 'Notifications tab');
  }

  /// Navigate to Alerts tab
  Future<void> goToAlerts() async {
    await _tapTab(alertsTab, 'Alerts tab');
  }

  /// Navigate to Settings tab
  Future<void> goToSettings() async {
    await _tapTab(settingsTab, 'Settings tab');
  }

  /// Tap the Scan QR Code button in empty dashboard state
  Future<void> tapScanQrCode() async {
    await tester.tap(scanQrCodeButton);
    await tester.pumpAndSettle();
  }

  /// Tap the Scan QR Code button and wait for the MaterialPageRoute transition.
  ///
  /// Uses fixed-duration pumps instead of pumpAndSettle to avoid timing out
  /// on MobileScanner's native camera initialisation.
  Future<void> tapScanQrCodeButton() async {
    await tester.tap(scanQrCodeButton);
    await tester.pump(); // begin transition frame
    await tester.pump(const Duration(milliseconds: 400)); // complete animation
  }

  /// Verify QrScannerScreen is shown by asserting its unique instruction text.
  Future<void> verifyQrScannerScreenShown() async {
    expect(qrScannerInstruction, findsOneWidget);
  }

  /// Tap Switch to Patient View
  Future<void> tapSwitchToPatientView() async {
    await tester.tap(switchToPatientViewOption);
    await tester.pumpAndSettle();
  }

  /// Tap Sign Out option (opens dialog)
  Future<void> tapSignOut() async {
    await tester.tap(signOutOption);
    await tester.pumpAndSettle();
  }

  /// Cancel the sign out dialog
  Future<void> cancelSignOut() async {
    await tester.tap(cancelButton);
    await tester.pumpAndSettle();
  }

  // ===== FLOWS =====

  /// Navigate through all 4 tabs and return to Dashboard
  Future<void> navigateAllTabs() async {
    await goToPatients();
    await goToNotifications();
    await goToAlerts();
    await goToSettings();
    await goToPatients();
  }

  // ===== HELPERS =====

  Future<void> _tapTab(Finder tabFinder, String tabName) async {
    const maxAttempts = 20;
    const attemptDelay = Duration(milliseconds: 100);

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      await tester.pump(attemptDelay);
      if (tabFinder.evaluate().isNotEmpty) {
        await tester.tap(tabFinder.first);
        await tester.pumpAndSettle();
        return;
      }
    }

    throw TestFailure(
      '$tabName not found after ${maxAttempts * attemptDelay.inMilliseconds}ms.',
    );
  }
}
