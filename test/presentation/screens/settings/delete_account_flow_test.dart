// Tests for delete account flow: verifies reauthenticate() is NOT called.
// DEL-001: Before fix → FAIL (reauthenticate IS called)
//          After fix  → PASS (reauthenticate is NOT called)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/models/subscription_status.dart';
import 'package:kusuridoki/data/models/user_profile.dart';
import 'package:kusuridoki/data/providers/auth_provider.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/data/providers/subscription_provider.dart';
import 'package:kusuridoki/data/services/auth_service.dart';
import 'package:kusuridoki/presentation/screens/settings/settings_screen.dart';

import '../../../helpers/widget_test_helpers.dart';

// Tracks whether reauthenticate() was called during the delete flow.
class _TrackingAuthService extends AuthService {
  bool reauthCalled = false;

  @override
  Stream<User?> get authStateChanges => const Stream.empty();

  @override
  Future<bool> reauthenticate() async {
    reauthCalled = true;
    return true;
  }

  @override
  Future<void> signOut() async {}
}

class _FakeUserSettings extends UserSettings {
  final UserProfile _profile;
  _FakeUserSettings(this._profile);

  @override
  Future<UserProfile> build() async => _profile;
}

const _testProfile = UserProfile(
  id: 'user-001',
  name: 'Alice',
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

const _freeStatus = SubscriptionStatus(isPremium: false);

List<dynamic> _buildOverrides(_TrackingAuthService mockAuth) => [
      userSettingsProvider.overrideWith(
        () => _FakeUserSettings(_testProfile),
      ),
      authStateProvider.overrideWith((ref) => Stream.value(null)),
      isPremiumProvider.overrideWith((ref) => false),
      subscriptionStatusProvider.overrideWith((ref) => _freeStatus),
      authServiceProvider.overrideWithValue(mockAuth),
    ];

Future<void> _tapThroughBothConfirms(WidgetTester tester) async {
  // Scroll until Delete Account button is visible
  await tester.scrollUntilVisible(
    find.text('Delete Account'),
    500.0,
    scrollable: find.byType(Scrollable),
  );
  await tester.pumpAndSettle();

  await tester.tap(find.text('Delete Account'));
  await tester.pumpAndSettle();

  // First confirm dialog
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();

  // Second confirm dialog
  expect(find.text('Delete Everything'), findsOneWidget);
  await tester.tap(find.text('Delete Everything'));
  await tester.pumpAndSettle();
}

void main() {
  group('Delete account flow', () {
    // DEL-001: CloudFunctions.deleteAccount() uses server-side admin auth,
    // so the client does not need to re-authenticate the user first.
    // 2-step confirmation dialogs are sufficient for intent verification.
    testWidgets(
      'DEL-001: authenticated delete does NOT call reauthenticate()',
      (tester) async {
        final mockAuth = _TrackingAuthService();

        await tester.pumpWidget(
          createTestableWidget(
            const SettingsScreen(),
            overrides: _buildOverrides(mockAuth),
          ),
        );
        await tester.pumpAndSettle();

        await _tapThroughBothConfirms(tester);

        expect(
          mockAuth.reauthCalled,
          isFalse,
          reason: 'reauthenticate() should not be called; '
              'CloudFunctions uses server-side admin auth (context.auth.uid)',
        );
      },
    );
  });
}
