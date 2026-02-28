/// Robot/Page Object for patient-side Family & Caregivers screen
library;

import 'package:flutter_test/flutter_test.dart';

/// Robot pattern class for interacting with FamilyScreen (/settings/family)
class FamilyRobot {
  final WidgetTester tester;

  FamilyRobot(this.tester);

  // ===== FINDERS =====

  // Screen content
  Finder get linkedCaregiversSection => find.text('Linked Caregivers');
  Finder get noCaregiversText => find.text('No caregivers linked yet');
  Finder get privacyNoticeTitle => find.text('Privacy Notice');

  // Invite section
  Finder get generateInviteLinkButton => find.text('Generate Invite Link');
  Finder get newLinkButton => find.text('New Link');

  // Caregiver status badges
  Finder get connectedBadge => find.text('Connected');
  Finder get pendingBadge => find.text('Pending');

  // Revoke flow
  Finder get revokeAccessOption => find.text('Revoke Access');
  Finder get revokeButton => find.text('Revoke');
  Finder get cancelButton => find.text('Cancel');

  /// Find a caregiver tile by caregiver name
  Finder caregiverTile(String caregiverName) => find.text(caregiverName);

  // ===== ASSERTIONS =====

  /// Verify we're on the FamilyScreen
  Future<void> verifyOnFamilyScreen() async {
    await tester.pumpAndSettle();
    expect(linkedCaregiversSection, findsOneWidget);
  }

  /// Verify empty state (no caregivers linked)
  Future<void> verifyEmptyState() async {
    await tester.pumpAndSettle();
    expect(noCaregiversText, findsOneWidget);
  }

  /// Verify a caregiver is displayed by name
  Future<void> verifyCaregiverDisplayed(String caregiverName) async {
    await tester.pumpAndSettle();
    expect(caregiverTile(caregiverName), findsOneWidget);
  }

  /// Verify Connected status badge is shown
  Future<void> verifyConnectedBadge() async {
    await tester.pumpAndSettle();
    expect(connectedBadge, findsWidgets);
  }

  /// Verify Privacy Notice section is displayed
  Future<void> verifyPrivacyNoticeDisplayed() async {
    await tester.pumpAndSettle();
    expect(privacyNoticeTitle, findsOneWidget);
  }

  /// Verify Generate Invite Link button is present
  Future<void> verifyGenerateInviteButton() async {
    await tester.pumpAndSettle();
    expect(generateInviteLinkButton, findsOneWidget);
  }

  // ===== ACTIONS =====

  /// Tap Generate Invite Link button
  Future<void> tapGenerateInviteLink() async {
    await tester.tap(generateInviteLinkButton);
    await tester.pumpAndSettle();
  }

  /// Long press on caregiver tile to show revoke menu
  Future<void> longPressCaregiverTile(String caregiverName) async {
    await tester.longPress(caregiverTile(caregiverName));
    await tester.pumpAndSettle();
  }

  /// Tap Revoke Access from context menu or tile action
  Future<void> tapRevokeAccess() async {
    await tester.tap(revokeAccessOption);
    await tester.pumpAndSettle();
  }

  /// Confirm revoke in the confirmation dialog
  Future<void> confirmRevoke() async {
    await tester.tap(revokeButton);
    await tester.pumpAndSettle();
  }

  /// Cancel the revoke confirmation dialog
  Future<void> cancelRevoke() async {
    await tester.tap(cancelButton);
    await tester.pumpAndSettle();
  }
}
