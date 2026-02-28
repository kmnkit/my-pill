/// Robot/Page Object for login screen interactions
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';

/// Robot pattern class for interacting with the LoginScreen
class LoginRobot {
  final WidgetTester tester;

  LoginRobot(this.tester);

  // ===== FINDERS =====

  Finder get appIcon => find.byIcon(Icons.health_and_safety);
  Finder get englishButton => find.text('English');
  Finder get japaneseButton => find.text('日本語');
  Finder get googleSignInButton => find.textContaining('Google');
  Finder get appleSignInButton => find.textContaining('Apple');
  Finder get continueAnonymouslyButton =>
      find.textContaining('without an account');
  Finder get loadingIndicator => find.byType(CircularProgressIndicator);
  Finder get localDataOnlyNotice => find.textContaining('only on this device');

  // ===== ASSERTIONS =====

  /// Verify we're on the login screen
  Future<void> verifyOnLoginScreen() async {
    await tester.pumpAndSettle();
    expect(appIcon, findsOneWidget);
    expect(continueAnonymouslyButton, findsOneWidget);
  }

  /// Verify loading indicator is shown (sign-in buttons replaced)
  void verifyLoadingShown() {
    expect(loadingIndicator, findsOneWidget);
    expect(continueAnonymouslyButton, findsNothing);
  }

  /// Verify an error snackbar appeared
  Future<void> verifyErrorSnackbar() async {
    // Pump a couple of frames to allow SnackBar to appear
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(SnackBar), findsOneWidget);
  }

  /// Verify English button is highlighted with primary color
  void verifyEnglishHighlighted() {
    final widget = tester.widget<Text>(englishButton);
    expect(widget.style?.color, AppColors.primary);
  }

  /// Verify English button is NOT highlighted (muted)
  void verifyEnglishNotHighlighted() {
    final widget = tester.widget<Text>(englishButton);
    expect(widget.style?.color, isNot(AppColors.primary));
  }

  /// Verify Japanese button is highlighted with primary color
  void verifyJapaneseHighlighted() {
    final widget = tester.widget<Text>(japaneseButton);
    expect(widget.style?.color, AppColors.primary);
  }

  // ===== ACTIONS =====

  /// Tap the English language button
  Future<void> tapEnglish() async {
    await tester.tap(englishButton);
    await tester.pumpAndSettle();
  }

  /// Tap the Japanese language button
  Future<void> tapJapanese() async {
    await tester.tap(japaneseButton);
    await tester.pumpAndSettle();
  }

  /// Tap the "Continue without account" button
  Future<void> tapContinueAnonymously() async {
    await tester.tap(continueAnonymouslyButton);
    await tester.pumpAndSettle();
  }

  /// Tap the Google sign-in button
  Future<void> tapGoogleSignIn() async {
    await tester.tap(googleSignInButton.first);
    await tester.pumpAndSettle();
  }
}
