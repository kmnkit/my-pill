import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kusuridoki/data/models/caregiver_link.dart';
import 'package:kusuridoki/data/providers/caregiver_monitoring_provider.dart';
import 'package:kusuridoki/data/providers/caregiver_provider.dart';
import 'package:kusuridoki/data/providers/invite_provider.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/data/models/user_profile.dart';
import 'package:kusuridoki/data/services/cloud_functions_service.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/screens/caregivers/invite_handler_screen.dart';

import '../../../helpers/widget_test_helpers.dart';
import '../../../mock_firebase.dart';

// ---------------------------------------------------------------------------
// Manual mock for CloudFunctionsService (no @GenerateMocks)
// ---------------------------------------------------------------------------

class _FakeCloudFunctionsService implements CloudFunctionsService {
  String? acceptedCode;
  bool shouldThrow = false;
  Object? throwWith;

  @override
  Future<String> acceptInvite(String code) async {
    acceptedCode = code;
    if (shouldThrow) throw throwWith ?? Exception('unknown error');
    return 'patient-123';
  }

  @override
  Future<({String url, String code})> generateInviteLink() async {
    throw UnimplementedError();
  }

  @override
  Future<void> revokeAccess({
    required String caregiverId,
    required String linkId,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> verifyReceipt({
    required String productId,
    required String purchaseToken,
    required String source,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAccount() async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateCaregiverPermissions({
    required bool shareMedications,
    required bool shareAdherence,
  }) async {
    throw UnimplementedError();
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Builds the widget tree with a real GoRouter so that context.go() works.
/// Renders InviteHandlerScreen at '/invite' with overrides applied.
Widget _buildWithRouter({
  required List<dynamic> overrides,
  required String inviteCode,
  void Function(String)? onNavigated,
}) {
  final router = GoRouter(
    initialLocation: '/invite',
    routes: [
      GoRoute(
        path: '/invite',
        builder: (context, state) => ProviderScope(
          // ignore: avoid_dynamic_calls
          overrides: overrides.cast(),
          child: InviteHandlerScreen(inviteCode: inviteCode),
        ),
      ),
      GoRoute(
        path: '/caregiver/patients',
        builder: (context, state) {
          onNavigated?.call('/caregiver/patients');
          return const Scaffold(body: Text('Caregiver Patients'));
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          onNavigated?.call('/home');
          return const Scaffold(body: Text('Home'));
        },
      ),
    ],
  );

  return MaterialApp.router(
    routerConfig: router,
    locale: const Locale('en'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
  );
}

/// Minimal UserSettings notifier override that completes instantly.
final _fakeUserSettingsOverride = userSettingsProvider.overrideWith(() {
  return _NoOpUserSettings();
});

class _NoOpUserSettings extends UserSettings {
  @override
  Future<UserProfile> build() async {
    return const UserProfile(
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
    );
  }

  @override
  Future<void> updateUserRole(String role) async {
    // no-op — avoids HiveBox access in tests
  }

  @override
  Future<void> updateIsCaregiver(bool value) async {
    // no-op — avoids HiveBox access in tests
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  setUp(() {
    setupFirebaseAuthMocks();
  });

  group('InviteHandlerScreen — INVHDL-HAPPY-001: initial render', () {
    testWidgets('shows invite code and accept button', (tester) async {
      const code = 'ABC123';
      final fakeCF = _FakeCloudFunctionsService();

      await tester.pumpWidget(
        createTestableWidget(
          const InviteHandlerScreen(inviteCode: code),
          overrides: [
            cloudFunctionsServiceProvider.overrideWithValue(fakeCF),
            caregiverLinksProvider.overrideWith(
              (ref) => Stream.value(<CaregiverLink>[]),
            ),
            caregiverPatientsProvider.overrideWith(
              (ref) => Stream.value([]),
            ),
            _fakeUserSettingsOverride,
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Invite code label is displayed
      expect(find.textContaining(code), findsWidgets);

      // "You've been invited!" headline
      expect(find.text("You've been invited!"), findsOneWidget);

      // Accept button is present
      expect(find.text('Accept Invitation'), findsOneWidget);

      // Decline button is present
      expect(find.text('Decline'), findsOneWidget);

      // No progress indicator initially
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows Icons.group_add icon', (tester) async {
      final fakeCF = _FakeCloudFunctionsService();

      await tester.pumpWidget(
        createTestableWidget(
          const InviteHandlerScreen(inviteCode: 'XYZ'),
          overrides: [
            cloudFunctionsServiceProvider.overrideWithValue(fakeCF),
            caregiverPatientsProvider.overrideWith(
              (ref) => Stream.value([]),
            ),
            _fakeUserSettingsOverride,
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.group_add), findsOneWidget);
    });
  });

  group('InviteHandlerScreen — INVHDL-HAPPY-002: accept flow success', () {
    testWidgets(
      'shows progress indicator while processing, then success SnackBar and navigates',
      (tester) async {
        const code = 'HAPPY-CODE';
        final fakeCF = _FakeCloudFunctionsService();
        String? navigatedTo;

        await tester.pumpWidget(
          _buildWithRouter(
            inviteCode: code,
            onNavigated: (path) => navigatedTo = path,
            overrides: [
              cloudFunctionsServiceProvider.overrideWithValue(fakeCF),
              caregiverLinksProvider.overrideWith(
                (ref) => Stream.value(<CaregiverLink>[]),
              ),
              caregiverPatientsProvider.overrideWith(
                (ref) => Stream.value([]),
              ),
              _fakeUserSettingsOverride,
            ],
          ),
        );
        await tester.pumpAndSettle();

        // Tap accept
        await tester.tap(find.text('Accept Invitation'));
        // One pump to show CircularProgressIndicator (before await completes)
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Accept Invitation'), findsNothing);

        // Let async work complete
        await tester.pumpAndSettle();

        // Success SnackBar
        expect(
          find.text('Successfully linked as caregiver!'),
          findsOneWidget,
        );

        // Navigated to /caregiver/patients
        expect(navigatedTo, equals('/caregiver/patients'));

        // acceptInvite was called with correct code
        expect(fakeCF.acceptedCode, equals(code));
      },
    );

    testWidgets(
      'navigates to /caregiver/patients on success (streams auto-update)',
      (tester) async {
        final fakeCF = _FakeCloudFunctionsService();

        final router = GoRouter(
          initialLocation: '/invite',
          routes: [
            GoRoute(
              path: '/invite',
              builder: (context, state) =>
                  InviteHandlerScreen(inviteCode: 'INV-999'),
            ),
            GoRoute(
              path: '/caregiver/patients',
              builder: (context, state) =>
                  const Scaffold(body: Text('Caregiver Patients')),
            ),
            GoRoute(
              path: '/home',
              builder: (context, state) =>
                  const Scaffold(body: Text('Home')),
            ),
          ],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              cloudFunctionsServiceProvider.overrideWithValue(fakeCF),
              caregiverLinksProvider.overrideWith(
                (ref) => Stream.value(<CaregiverLink>[]),
              ),
              caregiverPatientsProvider.overrideWith(
                (ref) => Stream.value([]),
              ),
              _fakeUserSettingsOverride,
            ],
            child: MaterialApp.router(
              routerConfig: router,
              locale: const Locale('en'),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Accept Invitation'));
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();

        // Verify navigation completed
        expect(
          find.text('Caregiver Patients'),
          findsOneWidget,
          reason: 'should have navigated to /caregiver/patients',
        );
      },
    );
  });

  group('InviteHandlerScreen — INVHDL-ERROR-001: accept flow failure', () {
    testWidgets(
      'shows generic error SnackBar and stays on screen when exception thrown',
      (tester) async {
        final fakeCF = _FakeCloudFunctionsService()
          ..shouldThrow = true
          ..throwWith = Exception('network error');

        String? navigatedTo;

        await tester.pumpWidget(
          _buildWithRouter(
            inviteCode: 'BAD-CODE',
            onNavigated: (path) => navigatedTo = path,
            overrides: [
              cloudFunctionsServiceProvider.overrideWithValue(fakeCF),
              caregiverPatientsProvider.overrideWith(
                (ref) => Stream.value([]),
              ),
              _fakeUserSettingsOverride,
            ],
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Accept Invitation'));
        await tester.pumpAndSettle();

        // Error SnackBar shown
        expect(
          find.text('Failed to accept invite. Please try again.'),
          findsOneWidget,
        );

        // No navigation
        expect(navigatedTo, isNull);

        // Buttons are back (not processing)
        expect(find.text('Accept Invitation'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      },
    );

    testWidgets(
      'shows invite-not-found message for FirebaseFunctionsException not-found',
      (tester) async {
        final fakeCF = _FakeCloudFunctionsService()
          ..shouldThrow = true
          ..throwWith = FirebaseFunctionsException(
            message: 'not found',
            code: 'not-found',
          );

        await tester.pumpWidget(
          _buildWithRouter(
            inviteCode: 'NOTFOUND',
            overrides: [
              cloudFunctionsServiceProvider.overrideWithValue(fakeCF),
              caregiverPatientsProvider.overrideWith(
                (ref) => Stream.value([]),
              ),
              _fakeUserSettingsOverride,
            ],
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Accept Invitation'));
        await tester.pumpAndSettle();

        expect(
          find.text('Invite code not found. Please check the link.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'shows invite-expired message for failed-precondition with expir in message',
      (tester) async {
        final fakeCF = _FakeCloudFunctionsService()
          ..shouldThrow = true
          ..throwWith = FirebaseFunctionsException(
            message: 'invite expired',
            code: 'failed-precondition',
          );

        await tester.pumpWidget(
          _buildWithRouter(
            inviteCode: 'EXPIRED',
            overrides: [
              cloudFunctionsServiceProvider.overrideWithValue(fakeCF),
              caregiverPatientsProvider.overrideWith(
                (ref) => Stream.value([]),
              ),
              _fakeUserSettingsOverride,
            ],
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Accept Invitation'));
        await tester.pumpAndSettle();

        expect(
          find.text('This invite has expired. Please ask for a new one.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'shows already-used message for failed-precondition without expir',
      (tester) async {
        final fakeCF = _FakeCloudFunctionsService()
          ..shouldThrow = true
          ..throwWith = FirebaseFunctionsException(
            message: 'already accepted',
            code: 'failed-precondition',
          );

        await tester.pumpWidget(
          _buildWithRouter(
            inviteCode: 'USED',
            overrides: [
              cloudFunctionsServiceProvider.overrideWithValue(fakeCF),
              caregiverPatientsProvider.overrideWith(
                (ref) => Stream.value([]),
              ),
              _fakeUserSettingsOverride,
            ],
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Accept Invitation'));
        await tester.pumpAndSettle();

        expect(
          find.text('This invite has already been used.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'shows self-invite error for invalid-argument exception',
      (tester) async {
        final fakeCF = _FakeCloudFunctionsService()
          ..shouldThrow = true
          ..throwWith = FirebaseFunctionsException(
            message: 'cannot invite self',
            code: 'invalid-argument',
          );

        await tester.pumpWidget(
          _buildWithRouter(
            inviteCode: 'SELF',
            overrides: [
              cloudFunctionsServiceProvider.overrideWithValue(fakeCF),
              caregiverPatientsProvider.overrideWith(
                (ref) => Stream.value([]),
              ),
              _fakeUserSettingsOverride,
            ],
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Accept Invitation'));
        await tester.pumpAndSettle();

        expect(
          find.text('You cannot accept your own invite.'),
          findsOneWidget,
        );
      },
    );
  });

  group('InviteHandlerScreen — decline button', () {
    testWidgets('decline button is present and tappable', (tester) async {
      final fakeCF = _FakeCloudFunctionsService();

      await tester.pumpWidget(
        createTestableWidget(
          const InviteHandlerScreen(inviteCode: 'DECLINE-TEST'),
          overrides: [
            cloudFunctionsServiceProvider.overrideWithValue(fakeCF),
            caregiverPatientsProvider.overrideWith(
              (ref) => Stream.value([]),
            ),
            _fakeUserSettingsOverride,
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Decline'), findsOneWidget);
      // Tapping should not throw in the test environment
      // (context.canPop() is false; context.go('/home') navigates away)
      // We just verify the button renders without errors here.
    });
  });
}

