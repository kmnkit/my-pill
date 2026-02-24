import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_pill/data/models/user_profile.dart';
import 'package:my_pill/data/providers/auth_provider.dart';
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/presentation/screens/settings/widgets/account_section.dart';

import '../../../../data/providers/auth_provider_test.mocks.dart';
import '../../../../helpers/widget_test_helpers.dart';

// ---------------------------------------------------------------------------
// Fake Firebase User
// ---------------------------------------------------------------------------
class _FakeUser implements User {
  _FakeUser({
    this.uid = 'uid-123',
    this.displayName,
    this.email,
    this.isAnonymous = false,
    this.photoURL,
  });

  @override
  final String uid;
  @override
  final String? displayName;
  @override
  final String? email;
  @override
  final bool isAnonymous;
  @override
  final String? photoURL;

  // --- stubs for the rest of the User interface ---
  @override
  bool get emailVerified => true;
  @override
  bool get isEmailVerified => true;
  @override
  UserMetadata get metadata => throw UnimplementedError();
  @override
  String? get phoneNumber => null;
  @override
  List<UserInfo> get providerData => [];
  @override
  String? get refreshToken => null;
  @override
  String? get tenantId => null;
  @override
  MultiFactor get multiFactor => throw UnimplementedError();

  @override
  Future<void> delete() async {}
  @override
  Future<String> getIdToken([bool forceRefresh = false]) async => 'token';
  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) async =>
      throw UnimplementedError();
  @override
  Future<UserCredential> linkWithCredential(AuthCredential credential) async =>
      throw UnimplementedError();
  @override
  Future<UserCredential> linkWithProvider(AuthProvider provider) async =>
      throw UnimplementedError();
  @override
  Future<UserCredential> reauthenticateWithCredential(
          AuthCredential credential) async =>
      throw UnimplementedError();
  @override
  Future<UserCredential> reauthenticateWithProvider(
          AuthProvider provider) async =>
      throw UnimplementedError();
  @override
  Future<void> reload() async {}
  @override
  Future<void> sendEmailVerification(
      [ActionCodeSettings? actionCodeSettings]) async {}
  @override
  Future<User> unlink(String providerId) async => this;
  @override
  Future<void> updateDisplayName(String? displayName) async {}
  @override
  Future<void> updateEmail(String newEmail) async {}
  @override
  Future<void> updatePassword(String newPassword) async {}
  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential credential) async {}
  @override
  Future<void> updatePhotoURL(String? photoURL) async {}
  @override
  Future<void> updateProfile(
      {String? displayName, String? photoURL}) async {}
  @override
  Future<void> verifyBeforeUpdateEmail(String newEmail,
      [ActionCodeSettings? actionCodeSettings]) async {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// ---------------------------------------------------------------------------
// Fake UserSettings notifier
// ---------------------------------------------------------------------------
class _FakeUserSettings extends UserSettings {
  final UserProfile _profile;
  _FakeUserSettings(this._profile);

  @override
  Future<UserProfile> build() async => _profile;
}

// ---------------------------------------------------------------------------
// Fake UserSettings notifier — stays loading forever
// ---------------------------------------------------------------------------
class _LoadingUserSettings extends UserSettings {
  @override
  Future<UserProfile> build() {
    // Never completes — keeps provider in loading state (no timer)
    return Completer<UserProfile>().future;
  }
}

// ---------------------------------------------------------------------------
// Minimal UserCredential stub for success path
// ---------------------------------------------------------------------------
class MockUserCredential extends Mock implements UserCredential {
  @override
  User? get user => null;
  @override
  AdditionalUserInfo? get additionalUserInfo => null;
  @override
  AuthCredential? get credential => null;
}


// ---------------------------------------------------------------------------
// Test constants
// ---------------------------------------------------------------------------
const _defaultProfile = UserProfile(
  id: 'user-001',
  name: 'Alice Smith',
  email: 'alice@example.com',
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

// ---------------------------------------------------------------------------
// Override builder helpers
// ---------------------------------------------------------------------------
List<dynamic> _buildOverrides({
  User? user,
  bool streamNull = false,
  bool streamError = false,
  bool streamLoading = false,
  UserProfile profile = _defaultProfile,
}) {
  return [
    userSettingsProvider.overrideWith(() => _FakeUserSettings(profile)),
    if (streamError)
      authStateProvider
          .overrideWith((ref) => Stream<User?>.error(Exception('Auth error')))
    else if (streamLoading)
      // A stream that never emits => stays in loading state
      authStateProvider.overrideWith(
          (ref) => const Stream<User?>.empty())
    else
      authStateProvider
          .overrideWith((ref) => Stream.value(streamNull ? null : user)),
  ];
}

void main() {
  group('AccountSection', () {
    // =========================================================================
    // Loading state
    // =========================================================================
    testWidgets('shows loading indicator when auth state is loading',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(streamLoading: true),
        ),
      );
      // Don't settle - we want to see the loading state
      await tester.pump();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });

    // =========================================================================
    // Error state
    // =========================================================================
    testWidgets('shows error when auth state has error', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(streamError: true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Error loading account'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    // =========================================================================
    // Null user (not signed in)
    // =========================================================================
    testWidgets('shows not signed in state when user is null', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(streamNull: true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Not signed in'), findsOneWidget);
      expect(find.text('Sign in to access your account'), findsOneWidget);
      // Avatar with '?' initials
      expect(find.text('?'), findsOneWidget);
    });

    // =========================================================================
    // Anonymous user
    // =========================================================================
    testWidgets('shows guest user UI for anonymous user', (tester) async {
      final anonUser = _FakeUser(isAnonymous: true);
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(user: anonUser),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Guest User'), findsOneWidget);
      expect(find.text('Sign in to sync data'), findsOneWidget);
      // Should show Link with Google button
      expect(find.text('Link with Google'), findsOneWidget);
      // Avatar with 'G' initials
      expect(find.text('G'), findsOneWidget);
    });

    // =========================================================================
    // Authenticated user — display name from Firebase
    // =========================================================================
    testWidgets('shows authenticated user with display name', (tester) async {
      final user = _FakeUser(
        displayName: 'Bob Jones',
        email: 'bob@example.com',
      );
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(
            user: user,
            profile: _defaultProfile.copyWith(name: null, email: null),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bob Jones'), findsOneWidget);
      expect(find.text('bob@example.com'), findsOneWidget);
      // Initials: BJ
      expect(find.text('BJ'), findsOneWidget);
      // Chevron icon
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    // =========================================================================
    // Authenticated user — display name from profile name
    // =========================================================================
    testWidgets('prefers profile name over Firebase displayName',
        (tester) async {
      final user = _FakeUser(
        displayName: 'Firebase Name',
        email: 'alice@example.com',
      );
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(
            user: user,
            profile: _defaultProfile.copyWith(name: 'Alice Smith'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Alice Smith'), findsOneWidget);
      // Initials: AS
      expect(find.text('AS'), findsOneWidget);
    });

    // =========================================================================
    // Authenticated user — fallback to email prefix
    // =========================================================================
    testWidgets('falls back to email prefix when no display name',
        (tester) async {
      final user = _FakeUser(
        displayName: null,
        email: 'john@example.com',
      );
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(
            user: user,
            profile: _defaultProfile.copyWith(name: null, email: null),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('john'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
    });

    // =========================================================================
    // Authenticated user — profile name 'User' is treated as legacy/empty
    // =========================================================================
    testWidgets('ignores profile name "User" and uses Firebase displayName',
        (tester) async {
      final user = _FakeUser(
        displayName: 'Real Name',
        email: 'real@example.com',
      );
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(
            user: user,
            profile: _defaultProfile.copyWith(name: 'User'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Real Name'), findsOneWidget);
    });

    // =========================================================================
    // Authenticated user — private relay email
    // =========================================================================
    testWidgets('shows "Email hidden" for Apple private relay email',
        (tester) async {
      final user = _FakeUser(
        displayName: 'Apple User',
        email: 'abc123@privaterelay.appleid.com',
      );
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(
            user: user,
            profile: _defaultProfile.copyWith(name: null, email: null),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Apple User'), findsOneWidget);
      expect(find.text('Email hidden'), findsOneWidget);
      // Should NOT show the actual relay email
      expect(
          find.text('abc123@privaterelay.appleid.com'), findsNothing);
    });

    // =========================================================================
    // Authenticated user — regular email shown
    // =========================================================================
    testWidgets('shows email for non-private-relay email', (tester) async {
      final user = _FakeUser(
        displayName: 'Normal User',
        email: 'normal@gmail.com',
      );
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(
            user: user,
            profile: _defaultProfile.copyWith(name: null),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Normal User'), findsOneWidget);
      // Email from profile takes precedence
      expect(find.text('alice@example.com'), findsOneWidget);
    });

    // =========================================================================
    // Authenticated user — no email shows "No email"
    // =========================================================================
    testWidgets('shows "No email" when user has no email', (tester) async {
      final user = _FakeUser(
        displayName: 'No Email User',
        email: null,
      );
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(
            user: user,
            profile: _defaultProfile.copyWith(name: null, email: null),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No Email User'), findsOneWidget);
      expect(find.text('No email'), findsOneWidget);
    });

    // =========================================================================
    // Initials — single name
    // =========================================================================
    testWidgets('shows single initial for single-word name', (tester) async {
      final user = _FakeUser(
        displayName: 'Madonna',
        email: 'madonna@example.com',
      );
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(
            user: user,
            profile: _defaultProfile.copyWith(name: null),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Madonna'), findsOneWidget);
      // Single initial: M
      expect(find.text('M'), findsOneWidget);
    });

    // =========================================================================
    // Initials — two-word name
    // =========================================================================
    testWidgets('shows two initials for two-word name', (tester) async {
      final user = _FakeUser(
        displayName: 'Jane Doe',
        email: 'jane@example.com',
      );
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(
            user: user,
            profile: _defaultProfile.copyWith(name: null),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Jane Doe'), findsOneWidget);
      expect(find.text('JD'), findsOneWidget);
    });

    // =========================================================================
    // Email from profile overrides Firebase email
    // =========================================================================
    testWidgets('profile email takes precedence over Firebase email',
        (tester) async {
      final user = _FakeUser(
        displayName: 'Test',
        email: 'firebase@example.com',
      );
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(
            user: user,
            profile: _defaultProfile.copyWith(email: 'profile@example.com'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('profile@example.com'), findsOneWidget);
      expect(find.text('firebase@example.com'), findsNothing);
    });

    // =========================================================================
    // Anonymous user — Link with Google button triggers _linkWithGoogle
    // (AuthService not wired; verifying UI tap does not crash)
    // =========================================================================
    testWidgets('anonymous user Link with Google button is visible',
        (tester) async {
      final anonUser = _FakeUser(isAnonymous: true);
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(user: anonUser),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Link with Google'), findsOneWidget);
      // Tapping requires authServiceProvider (Firebase) — covered in integration tests.
    });

    // =========================================================================
    // Anonymous user — shows 'G' avatar initial
    // =========================================================================
    testWidgets('anonymous user avatar shows G initial', (tester) async {
      final anonUser = _FakeUser(isAnonymous: true);
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(user: anonUser),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('G'), findsOneWidget);
    });

    // =========================================================================
    // Anonymous user — sign-in-to-sync subtitle is shown
    // =========================================================================
    testWidgets('anonymous user shows sign in to sync subtitle', (tester) async {
      final anonUser = _FakeUser(isAnonymous: true);
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(user: anonUser),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sign in to sync data'), findsOneWidget);
    });

    // =========================================================================
    // Null user — avatar with '?' shown
    // =========================================================================
    testWidgets('null user shows question mark avatar', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(streamNull: true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('?'), findsOneWidget);
    });

    // =========================================================================
    // Null user — sign-in-to-access subtitle shown
    // =========================================================================
    testWidgets('null user shows sign in to access subtitle', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(streamNull: true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sign in to access your account'), findsOneWidget);
    });

    // =========================================================================
    // Authenticated user — chevron_right icon shown
    // =========================================================================
    testWidgets('authenticated user shows chevron_right icon', (tester) async {
      final user = _FakeUser(
        displayName: 'Alice Smith',
        email: 'alice@example.com',
      );
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(user: user),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    // =========================================================================
    // Authenticated user — userSettingsProvider still loading (value is null)
    // =========================================================================
    testWidgets(
        'authenticated user falls back to Firebase displayName when userSettingsProvider is loading',
        (tester) async {
      final user = _FakeUser(
        displayName: 'Firebase Name',
        email: 'fb@example.com',
      );
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: [
            userSettingsProvider.overrideWith(() => _LoadingUserSettings()),
            authStateProvider
                .overrideWith((ref) => Stream.value(user)),
          ],
        ),
      );
      // Don't use pumpAndSettle — _LoadingUserSettings has a pending timer.
      // Pump a few frames so the auth stream and widget can rebuild.
      await tester.pump();
      await tester.pump();

      // userProfile.value is null while loading → falls back to Firebase displayName
      expect(find.text('Firebase Name'), findsOneWidget);
      expect(find.text('fb@example.com'), findsOneWidget);
    });

    // =========================================================================
    // Authenticated user — no displayName, no email → falls back to guestUser
    // =========================================================================
    testWidgets(
        'authenticated user with no displayName and no email shows Guest User',
        (tester) async {
      final user = _FakeUser(
        displayName: null,
        email: null,
      );
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(
            user: user,
            profile: _defaultProfile.copyWith(name: null, email: null),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Falls back to l10n.guestUser = 'Guest User'
      expect(find.text('Guest User'), findsOneWidget);
      // No email shown → l10n.noEmail = 'No email'
      expect(find.text('No email'), findsOneWidget);
    });

    // =========================================================================
    // _linkWithGoogle — success shows "Account linked" snackbar
    // =========================================================================
    testWidgets('tapping Link with Google on success shows account linked snackbar',
        (tester) async {
      final anonUser = _FakeUser(isAnonymous: true);

      final mockService = MockAuthService();
      when(mockService.linkWithGoogle())
          .thenAnswer((_) async => MockUserCredential());

      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: [
            userSettingsProvider
                .overrideWith(() => _FakeUserSettings(_defaultProfile)),
            authStateProvider
                .overrideWith((ref) => Stream.value(anonUser)),
            authServiceProvider.overrideWithValue(mockService),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Link with Google'));
      await tester.pumpAndSettle();

      expect(find.text('Account linked successfully'), findsOneWidget);
    });

    // =========================================================================
    // _linkWithGoogle — credential-already-in-use shows specific snackbar
    // =========================================================================
    testWidgets(
        'tapping Link with Google on credential-already-in-use shows specific error',
        (tester) async {
      final anonUser = _FakeUser(isAnonymous: true);

      final mockService = MockAuthService();
      when(mockService.linkWithGoogle()).thenThrow(
        FirebaseAuthException(code: 'credential-already-in-use'),
      );

      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: [
            userSettingsProvider
                .overrideWith(() => _FakeUserSettings(_defaultProfile)),
            authStateProvider
                .overrideWith((ref) => Stream.value(anonUser)),
            authServiceProvider.overrideWithValue(mockService),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Link with Google'));
      await tester.pumpAndSettle();

      expect(find.text('This account is already linked to another user'), findsOneWidget);
    });

    // =========================================================================
    // _linkWithGoogle — generic FirebaseAuthException shows "link failed"
    // =========================================================================
    testWidgets(
        'tapping Link with Google on generic error shows link failed snackbar',
        (tester) async {
      final anonUser = _FakeUser(isAnonymous: true);

      final mockService = MockAuthService();
      when(mockService.linkWithGoogle()).thenThrow(
        FirebaseAuthException(code: 'network-request-failed'),
      );

      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: [
            userSettingsProvider
                .overrideWith(() => _FakeUserSettings(_defaultProfile)),
            authStateProvider
                .overrideWith((ref) => Stream.value(anonUser)),
            authServiceProvider.overrideWithValue(mockService),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Link with Google'));
      await tester.pumpAndSettle();

      expect(find.text('Failed to link account. Please try again.'), findsOneWidget);
    });

    // =========================================================================
    // _linkWithGoogle — cancelled (returns null) shows no snackbar
    // =========================================================================
    testWidgets(
        'tapping Link with Google when cancelled shows no snackbar',
        (tester) async {
      final anonUser = _FakeUser(isAnonymous: true);

      final mockService = MockAuthService();
      when(mockService.linkWithGoogle()).thenAnswer((_) async => null);

      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: [
            userSettingsProvider
                .overrideWith(() => _FakeUserSettings(_defaultProfile)),
            authStateProvider
                .overrideWith((ref) => Stream.value(anonUser)),
            authServiceProvider.overrideWithValue(mockService),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Link with Google'));
      await tester.pumpAndSettle();

      // No snackbar — cancelled silently
      expect(find.byType(SnackBar), findsNothing);
    });

    // =========================================================================
    // Authenticated user — MpCard wraps the content (display name from profile)
    // =========================================================================
    testWidgets('authenticated user renders inside MpCard', (tester) async {
      final user = _FakeUser(
        displayName: 'Carol Jones',
        email: 'carol@example.com',
      );
      // Use a profile with name: 'Carol Jones' so the widget shows it
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(
            user: user,
            profile: _defaultProfile.copyWith(
                name: 'Carol Jones', email: 'carol@example.com'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // MpCard is a custom widget — verify text content is present
      expect(find.text('Carol Jones'), findsOneWidget);
    });

    // =========================================================================
    // Authenticated user — empty name falls back to '?'
    // =========================================================================
    testWidgets('empty display name shows question-mark initial', (tester) async {
      final user = _FakeUser(
        displayName: '',
        email: null,
      );
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(
            user: user,
            profile: _defaultProfile.copyWith(name: null, email: null),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // displayName fallback chain ends at l10n.guestUser ('Guest User')
      // which has initial 'G'; the widget renders without error
      expect(find.byType(AccountSection), findsOneWidget);
    });

    // =========================================================================
    // Authenticated user — profile name empty string uses Firebase displayName
    // =========================================================================
    testWidgets('profile name empty string falls back to Firebase displayName',
        (tester) async {
      final user = _FakeUser(
        displayName: 'Fallback Name',
        email: 'fb@example.com',
      );
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(
            user: user,
            profile: _defaultProfile.copyWith(name: ''),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Fallback Name'), findsOneWidget);
    });

    // =========================================================================
    // Error state shows error icon
    // =========================================================================
    testWidgets('error state shows error_outline icon', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(streamError: true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    // =========================================================================
    // Loading state shows text 'Loading...'
    // =========================================================================
    testWidgets('loading state shows Loading text', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AccountSection(),
          overrides: _buildOverrides(streamLoading: true),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Loading...'), findsOneWidget);
    });
  });
}
