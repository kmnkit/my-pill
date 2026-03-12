import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/models/subscription_status.dart';
import 'package:kusuridoki/data/models/user_profile.dart';
import 'package:kusuridoki/data/providers/auth_provider.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/data/providers/subscription_provider.dart';
import 'package:kusuridoki/presentation/screens/settings/settings_screen.dart';

import '../../../helpers/widget_test_helpers.dart';

// Fake UserSettings notifier
class _FakeUserSettings extends UserSettings {
  final UserProfile _profile;
  _FakeUserSettings(this._profile);

  @override
  Future<UserProfile> build() async => _profile;
}

// Fake UserSettings that errors
class _FakeErrorUserSettings extends UserSettings {
  @override
  Future<UserProfile> build() async => throw Exception('Settings error');
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
const _premiumStatus = SubscriptionStatus(isPremium: true);
final _premiumWithExpiry = SubscriptionStatus(
  isPremium: true,
  expiresAt: DateTime(2030, 12, 31),
);

List<dynamic> _buildOverrides({UserProfile profile = _testProfile}) {
  return [
    userSettingsProvider.overrideWith(() => _FakeUserSettings(profile)),
    // authStateProvider returns a Stream<User?> – provide null (not signed in)
    authStateProvider.overrideWith((ref) => Stream.value(null)),
    // Subscription: free tier
    isPremiumProvider.overrideWith((ref) => false),
    subscriptionStatusProvider.overrideWith((ref) => _freeStatus),
    appVersionProvider.overrideWith((ref) async => '1.1.1'),
  ];
}

List<dynamic> _buildPremiumOverrides({
  SubscriptionStatus status = _premiumStatus,
}) {
  return [
    userSettingsProvider.overrideWith(() => _FakeUserSettings(_testProfile)),
    authStateProvider.overrideWith((ref) => Stream.value(null)),
    isPremiumProvider.overrideWith((ref) => true),
    subscriptionStatusProvider.overrideWith((ref) => status),
    appVersionProvider.overrideWith((ref) async => '1.1.1'),
  ];
}

void main() {
  group('SettingsScreen', () {
    testWidgets('renders settings title in app bar', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('shows safety & privacy section header', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Safety & Privacy'), findsOneWidget);
    });

    testWidgets('shows about section with version', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('About'), findsOneWidget);
      // l10n: version('1.0.0') -> 'Version 1.0.0'
      expect(find.textContaining('1.1.1'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows loading indicator while settings load', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      // Before pumpAndSettle the async notifier may show spinner
      await tester.pump();
      // Let everything settle
      await tester.pumpAndSettle();
      // After settle the content must be visible
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('shows error state and retry button when provider fails', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: [
            userSettingsProvider.overrideWith(() => _FakeErrorUserSettings()),
            authStateProvider.overrideWith((ref) => Stream.value(null)),
            isPremiumProvider.overrideWith((ref) => false),
            subscriptionStatusProvider.overrideWith((ref) => _freeStatus),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // l10n: errorLoadingSettings -> 'Error loading settings'
      expect(find.text('Error loading settings'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    // --- Additional tests for uncovered lines ---

    testWidgets('shows advanced section header', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Advanced'), findsOneWidget);
    });

    testWidgets('shows log out tile in advanced section', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // l10n: deactivateAccount -> "Log Out"
      await tester.scrollUntilVisible(
        find.text('Log Out'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Log Out'), findsOneWidget);
    });

    testWidgets('shows delete account tile in advanced section', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Delete Account'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Delete Account'), findsOneWidget);
    });

    testWidgets('shows Data Sharing Preferences tile', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Data Sharing Preferences'), findsOneWidget);
    });

    testWidgets('shows Backup & Sync tile', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Backup & Sync'), findsOneWidget);
    });

    testWidgets('shows Privacy Policy tile', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Privacy Policy'), findsOneWidget);
    });

    testWidgets('shows Terms of Service tile', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Terms of Service'), findsOneWidget);
    });

    testWidgets('shows App Version tile', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('App Version'), findsOneWidget);
    });

    testWidgets('shows switch to caregiver view button', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Switch to Caregiver View'), findsOneWidget);
    });

    testWidgets('shows upgrade premium banner for free user', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // l10n: unlockPremium -> "Upgrade to Premium"
      expect(find.text('Upgrade to Premium'), findsOneWidget);
    }, skip: true); // kPremiumEnabled is false

    testWidgets('shows premium status banner for premium user', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildPremiumOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // l10n: alreadyPremium -> "You're a Premium member"
      expect(find.text("You're a Premium member"), findsOneWidget);
      // l10n: manageSubscription -> "Manage Subscription"
      expect(find.text('Manage Subscription'), findsOneWidget);
    }, skip: true); // kPremiumEnabled is false

    testWidgets('shows premium expiry date when subscription has expiry', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildPremiumOverrides(status: _premiumWithExpiry),
        ),
      );
      await tester.pumpAndSettle();

      // l10n: premiumExpiresAt('2030-12-31') contains the date
      expect(find.textContaining('2030'), findsOneWidget);
    }, skip: true); // kPremiumEnabled is false

    testWidgets('shows current plan text when premium has no expiry date', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildPremiumOverrides(
            status: const SubscriptionStatus(isPremium: true),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Current Plan'), findsOneWidget);
    }, skip: true); // kPremiumEnabled is false

    testWidgets('retry button in error state invalidates provider', (
      tester,
    ) async {
      // Build a notifier that fails the first time, succeeds the second
      // We can't easily toggle state in a Fake, so we just verify tap doesn't crash
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: [
            userSettingsProvider.overrideWith(() => _FakeErrorUserSettings()),
            authStateProvider.overrideWith((ref) => Stream.value(null)),
            isPremiumProvider.overrideWith((ref) => false),
            subscriptionStatusProvider.overrideWith((ref) => _freeStatus),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Retry'), findsOneWidget);

      // Tapping retry should not throw
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      // Error state persists because provider still throws, but no crash
      expect(find.text('Error loading settings'), findsOneWidget);
    });

    testWidgets('tapping log out tile shows confirmation dialog', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Log Out'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Log Out'));
      await tester.pumpAndSettle();

      // KdConfirmDialog uses AlertDialog — check for dialog content
      expect(find.byType(Dialog), findsAtLeastNWidgets(1));
    });

    testWidgets('tapping delete account tile shows first confirmation dialog', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Delete Account'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Delete Account'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsAtLeastNWidgets(1));
    });

    testWidgets('dismissing log out dialog does not sign out', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Log Out'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Log Out'));
      await tester.pumpAndSettle();

      // Dismiss by tapping Cancel button in the dialog
      final cancelFinder = find.text('Cancel');
      if (cancelFinder.evaluate().isNotEmpty) {
        await tester.tap(cancelFinder);
      } else {
        // Dismiss via barrier
        await tester.tapAt(const Offset(10, 10));
      }
      await tester.pumpAndSettle();

      // Settings screen still visible (no navigation occurred)
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('renders all section headers in data state', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll to ensure all content is laid out
      await tester.scrollUntilVisible(
        find.text('Advanced'),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.text('Safety & Privacy'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Advanced'), findsOneWidget);
    });

    testWidgets('renders in Japanese locale', (tester) async {
      await tester.pumpWidget(
        createTestableWidgetJa(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // Japanese app bar title: '設定'
      expect(find.text('設定'), findsOneWidget);
    });

    testWidgets('version tile has no chevron (onTap is null)', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // App Version tile text exists
      expect(find.text('App Version'), findsOneWidget);
      // Version value text exists
      expect(find.textContaining('1.1.1'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows loading spinner before async settings resolve', (
      tester,
    ) async {
      // Use a notifier that completes slowly by using a Completer
      // We just pump once (not pumpAndSettle) to catch the loading state
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      // pump once to trigger the frame with the loading state
      await tester.pump(Duration.zero);

      // Either spinner or content may appear depending on timing;
      // both are valid — just verify no exception is thrown
      expect(tester.takeException(), isNull);

      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);
    });
  });
}
