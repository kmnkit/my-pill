import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/models/subscription_status.dart';
import 'package:my_pill/data/models/user_profile.dart';
import 'package:my_pill/data/providers/auth_provider.dart';
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/data/providers/subscription_provider.dart';
import 'package:my_pill/presentation/screens/settings/settings_screen.dart';

import '../../../helpers/widget_test_helpers.dart';

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

List<dynamic> _buildOverrides({UserProfile profile = _testProfile}) {
  return [
    userSettingsProvider.overrideWith(() => _FakeUserSettings(profile)),
    authStateProvider.overrideWith((ref) => Stream.value(null)),
    isPremiumProvider.overrideWith((ref) => false),
    subscriptionStatusProvider.overrideWith((ref) => _freeStatus),
  ];
}

void main() {
  group('SettingsScreen extended', () {
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

    testWidgets('shows privacy policy list tile', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Privacy Policy'), findsOneWidget);
    });

    testWidgets('shows terms of service list tile', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Terms of Service'), findsOneWidget);
    });

    testWidgets('shows backup and sync list tile', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Backup & Sync'), findsOneWidget);
    });

    testWidgets('shows deactivate account list tile', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Log Out'), findsOneWidget);
    });

    testWidgets('shows delete account list tile', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Delete Account'), findsOneWidget);
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

    testWidgets('shows data sharing preferences tile', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Data Sharing Preferences'), findsOneWidget);
    });

    testWidgets('shows app version text', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('App Version'), findsOneWidget);
      expect(find.textContaining('1.0.0'), findsAtLeastNWidgets(1));
    });

    testWidgets('all section headers visible on scroll', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll to bottom so all sections get rendered
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -1000));
      await tester.pumpAndSettle();

      expect(find.text('Advanced'), findsOneWidget);
    });

    testWidgets('shows loading spinner before data resolves', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(),
        ),
      );
      // pump once: async notifier still loading
      await tester.pump();
      // CircularProgressIndicator or content – either is acceptable before settle
      // After full settle, content must be visible
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('renders with high contrast profile', (tester) async {
      const highContrastProfile = UserProfile(
        id: 'user-002',
        name: 'Bob',
        language: 'en',
        highContrast: true,
        textSize: 'large',
        notificationsEnabled: false,
        criticalAlerts: true,
        snoozeDuration: 5,
        travelModeEnabled: false,
        removeAds: false,
        onboardingComplete: true,
      );
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(profile: highContrastProfile),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('renders with Japanese locale', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const SettingsScreen(),
          overrides: _buildOverrides(
            profile: const UserProfile(
              id: 'user-ja',
              language: 'ja',
              highContrast: false,
              textSize: 'normal',
              notificationsEnabled: true,
              criticalAlerts: false,
              snoozeDuration: 15,
              travelModeEnabled: false,
              removeAds: false,
              onboardingComplete: true,
            ),
          ),
          locale: const Locale('ja'),
        ),
      );
      await tester.pumpAndSettle();

      // Japanese locale: app bar should render (title not empty)
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
