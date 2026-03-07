// ignore_for_file: depend_on_referenced_packages
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:kusuridoki/data/models/user_profile.dart';
import 'package:kusuridoki/data/providers/auth_provider.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/data/services/auth_service.dart';
import 'package:kusuridoki/presentation/screens/onboarding/login_screen.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../../helpers/widget_test_helpers.dart';
import '../../../mock_firebase.dart';

// ─── Firebase auth platform stub ─────────────────────────────────────────────

class _FakeFirebaseAuthPlatform extends FirebaseAuthPlatform
    with MockPlatformInterfaceMixin {
  _FakeFirebaseAuthPlatform() : super();

  @override
  UserPlatform? get currentUser => null;

  @override
  Stream<UserPlatform?> authStateChanges() =>
      Stream<UserPlatform?>.value(null);

  @override
  Stream<UserPlatform?> idTokenChanges() => Stream<UserPlatform?>.value(null);

  @override
  Stream<UserPlatform?> userChanges() => Stream<UserPlatform?>.value(null);

  @override
  FirebaseAuthPlatform delegateFor({
    required dynamic app,
    dynamic persistence,
  }) => this;

  @override
  FirebaseAuthPlatform setInitialValues({
    dynamic currentUser,
    String? languageCode,
  }) => this;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// ─── AuthService fakes ───────────────────────────────────────────────────────

/// AuthService whose signInWithGoogle returns null (user cancelled) — no nav.
class _CancelledGoogleAuthService extends AuthService {
  @override
  Future<UserCredential?> signInWithGoogle() async => null;

  @override
  User? get currentUser => null;
}

/// AuthService whose signInWithGoogle throws.
class _FailingGoogleAuthService extends AuthService {
  @override
  Future<UserCredential?> signInWithGoogle() async =>
      throw Exception('network error');

  @override
  User? get currentUser => null;
}

/// AuthService whose signInWithApple throws a generic Exception
/// (exercises the catch-all branch → appleSignInFailed SnackBar).
class _FailingAppleAuthService extends AuthService {
  @override
  Future<UserCredential?> signInWithApple() async =>
      throw Exception('apple network error');

  @override
  User? get currentUser => null;
}

/// AuthService whose signInWithGoogle future never resolves — used to assert
/// the loading state.
class _NeverCompletingAuthService extends AuthService {
  @override
  Future<UserCredential?> signInWithGoogle() =>
      Completer<UserCredential?>().future;

  @override
  User? get currentUser => null;
}

// ─── UserSettings fake ───────────────────────────────────────────────────────

const _testProfile = UserProfile(
  id: 'local',
  name: null,
  language: 'en',
  highContrast: false,
  textSize: 'normal',
  notificationsEnabled: true,
  criticalAlerts: false,
  snoozeDuration: 15,
  travelModeEnabled: false,
  removeAds: false,
  onboardingComplete: true,
);

class _FakeUserSettings extends UserSettings {
  @override
  Future<UserProfile> build() async => _testProfile;

  @override
  Future<void> updateLanguage(String language) async {}
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

List<dynamic> _overrides(AuthService authService) {
  return [
    authServiceProvider.overrideWithValue(authService),
    authStateProvider.overrideWith((ref) => Stream.value(null)),
    userSettingsProvider.overrideWith(() => _FakeUserSettings()),
  ];
}

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  setUp(() {
    setupFirebaseAuthMocks();
    FirebaseAuthPlatform.instance = _FakeFirebaseAuthPlatform();
  });

  group('LoginScreen', () {
    testWidgets('renders sign in title', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LoginScreen(),
          overrides: _overrides(_CancelledGoogleAuthService()),
        ),
      );
      await tester.pumpAndSettle();

      // l10n: signIn -> "Sign In"
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('renders Google sign-in button', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LoginScreen(),
          overrides: _overrides(_CancelledGoogleAuthService()),
        ),
      );
      await tester.pumpAndSettle();

      // l10n: signInWithGoogle -> "Sign in with Google"
      expect(find.text('Sign in with Google'), findsOneWidget);
    });

    // LOGIN-ERROR-001: Google sign-in throws → error SnackBar shown.
    testWidgets('shows SnackBar when Google sign-in throws', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LoginScreen(),
          overrides: _overrides(_FailingGoogleAuthService()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign in with Google'));
      await tester.pumpAndSettle();

      // l10n: googleSignInFailed('network error') -> "Google sign in failed: ..."
      expect(find.textContaining('Google sign in failed'), findsOneWidget);
    });

    // LOGIN-ERROR-002: Apple sign-in throws → error SnackBar shown (iOS only).
    // The Apple button only renders on iOS. When absent (CI / Android), skip.
    testWidgets(
      'shows SnackBar when Apple sign-in throws (iOS-only button)',
      (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            const LoginScreen(),
            overrides: _overrides(_FailingAppleAuthService()),
          ),
        );
        await tester.pumpAndSettle();

        final appleButton = find.text('Sign in with Apple');
        if (appleButton.evaluate().isEmpty) {
          // Not iOS — button absent. Nothing to test here.
          return;
        }

        await tester.tap(appleButton);
        await tester.pumpAndSettle();

        // l10n: appleSignInFailed('...') -> "Apple sign in failed: ..."
        expect(find.textContaining('Apple sign in failed'), findsOneWidget);
      },
    );

    testWidgets('shows loading indicator while sign-in is in progress',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LoginScreen(),
          overrides: _overrides(_NeverCompletingAuthService()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign in with Google'));
      await tester.pump(); // one frame — _isLoading = true

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Sign-in buttons are hidden while loading.
      expect(find.text('Sign in with Google'), findsNothing);
    });

    testWidgets('renders try-without-account button', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LoginScreen(),
          overrides: _overrides(_CancelledGoogleAuthService()),
        ),
      );
      await tester.pumpAndSettle();

      // l10n: tryWithoutAccount -> "Try without an account"
      expect(find.text('Try without an account'), findsOneWidget);
    });
  });
}
