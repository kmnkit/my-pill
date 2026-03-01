/// Robot/Page Object for InviteHandlerScreen (/invite/:code)
library;

import 'package:flutter_test/flutter_test.dart';

/// Robot pattern class for interacting with InviteHandlerScreen
class InviteRobot {
  final WidgetTester tester;

  InviteRobot(this.tester);

  // ===== FINDERS =====

  // Screen content
  Finder get invitedTitle => find.text("You've been invited!");
  Finder get acceptButton => find.text('Accept Invitation');
  Finder get declineButton => find.text('Decline');

  /// Find the invite code display by code string
  Finder inviteCodeText(String code) =>
      find.textContaining('Invite Code: $code');

  // Result states
  Finder get successText => find.text('Successfully linked as caregiver!');
  Finder get failedText =>
      find.text('Failed to accept invite. Please try again.');

  // ===== ASSERTIONS =====

  /// Verify we're on the InviteHandlerScreen
  Future<void> verifyOnInviteScreen() async {
    await tester.pumpAndSettle();
    expect(invitedTitle, findsOneWidget);
  }

  /// Verify the invite code is displayed
  Future<void> verifyInviteCodeDisplayed(String code) async {
    await tester.pumpAndSettle();
    expect(inviteCodeText(code), findsOneWidget);
  }

  /// Verify Accept and Decline buttons are present
  Future<void> verifyActionsDisplayed() async {
    await tester.pumpAndSettle();
    expect(acceptButton, findsOneWidget);
    expect(declineButton, findsOneWidget);
  }

  // ===== ACTIONS =====

  /// Tap Accept Invitation button
  Future<void> tapAccept() async {
    await tester.tap(acceptButton);
    await tester.pumpAndSettle();
  }

  /// Tap Decline button
  Future<void> tapDecline() async {
    await tester.tap(declineButton);
    await tester.pumpAndSettle();
  }
}
