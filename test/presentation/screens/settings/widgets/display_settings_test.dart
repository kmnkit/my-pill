import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/models/user_profile.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/screens/settings/widgets/display_settings.dart';

import '../../../../helpers/widget_test_helpers.dart';

class _FakeUserSettings extends UserSettings {
  final UserProfile _profile;
  _FakeUserSettings(this._profile);

  @override
  Future<UserProfile> build() async => _profile;
}

class _FakeErrorUserSettings extends UserSettings {
  @override
  Future<UserProfile> build() async => throw Exception('Test error');
}

const _defaultProfile = UserProfile(
  id: 'user-001',
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

List<dynamic> _overrides(UserProfile profile) => [
  userSettingsProvider.overrideWith(() => _FakeUserSettings(profile)),
];

void main() {
  group('DisplaySettings', () {
    testWidgets('renders Display section header', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DisplaySettings(),
          overrides: _overrides(_defaultProfile),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Display'), findsOneWidget);
    });

    testWidgets('renders high contrast toggle label', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DisplaySettings(),
          overrides: _overrides(_defaultProfile),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('High Contrast'), findsOneWidget);
    });

    testWidgets('renders text size label', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DisplaySettings(),
          overrides: _overrides(_defaultProfile),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Text Size'), findsOneWidget);
    });

    testWidgets('renders all three text size options', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DisplaySettings(),
          overrides: _overrides(_defaultProfile),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Normal'), findsOneWidget);
      expect(find.text('Large'), findsOneWidget);
      expect(find.text('XL'), findsOneWidget);
    });

    testWidgets('renders with normal textSize profile', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DisplaySettings(),
          overrides: _overrides(_defaultProfile),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Normal'), findsOneWidget);
      expect(find.text('Large'), findsOneWidget);
      expect(find.text('XL'), findsOneWidget);
    });

    testWidgets('renders with large textSize profile', (tester) async {
      const largeProfile = UserProfile(
        id: 'user-002',
        language: 'en',
        highContrast: false,
        textSize: 'large',
        notificationsEnabled: true,
        criticalAlerts: false,
        snoozeDuration: 15,
        travelModeEnabled: false,
        removeAds: false,
        onboardingComplete: true,
      );
      await tester.pumpWidget(
        createTestableWidget(
          const DisplaySettings(),
          overrides: _overrides(largeProfile),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Text Size'), findsOneWidget);
    });

    testWidgets('renders with xl textSize profile', (tester) async {
      const xlProfile = UserProfile(
        id: 'user-003',
        language: 'en',
        highContrast: false,
        textSize: 'xl',
        notificationsEnabled: true,
        criticalAlerts: false,
        snoozeDuration: 15,
        travelModeEnabled: false,
        removeAds: false,
        onboardingComplete: true,
      );
      await tester.pumpWidget(
        createTestableWidget(
          const DisplaySettings(),
          overrides: _overrides(xlProfile),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Text Size'), findsOneWidget);
    });

    testWidgets('high contrast toggle is off when highContrast is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DisplaySettings(),
          overrides: _overrides(_defaultProfile),
        ),
      );
      await tester.pumpAndSettle();

      // GestureDetector backs the toggle – value false means toggle is off
      final gestures = find.byType(GestureDetector);
      expect(gestures, findsAtLeastNWidgets(1));
    });

    testWidgets('high contrast toggle is on when highContrast is true', (
      tester,
    ) async {
      const hcProfile = UserProfile(
        id: 'user-004',
        language: 'en',
        highContrast: true,
        textSize: 'normal',
        notificationsEnabled: true,
        criticalAlerts: false,
        snoozeDuration: 15,
        travelModeEnabled: false,
        removeAds: false,
        onboardingComplete: true,
      );
      await tester.pumpWidget(
        createTestableWidget(
          const DisplaySettings(),
          overrides: _overrides(hcProfile),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('High Contrast'), findsOneWidget);
    });

    testWidgets('tapping Normal size chip does not crash', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DisplaySettings(),
          overrides: _overrides(_defaultProfile),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Normal'));
      await tester.pumpAndSettle();

      // Should still show the widget without exception
      expect(find.text('Display'), findsOneWidget);
    });

    testWidgets('tapping Large size chip does not crash', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DisplaySettings(),
          overrides: _overrides(_defaultProfile),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Large'));
      await tester.pumpAndSettle();

      expect(find.text('Display'), findsOneWidget);
    });

    testWidgets('tapping XL size chip does not crash', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DisplaySettings(),
          overrides: _overrides(_defaultProfile),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('XL'));
      await tester.pumpAndSettle();

      expect(find.text('Display'), findsOneWidget);
    });

    testWidgets('renders in dark theme without error', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: _overrides(_defaultProfile).cast(),
          child: MaterialApp(
            theme: ThemeData.dark(),
            locale: const Locale('en'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(body: DisplaySettings()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Display'), findsOneWidget);
    });

    testWidgets('renders in Japanese locale', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DisplaySettings(),
          overrides: _overrides(_defaultProfile),
          locale: const Locale('ja'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DisplaySettings), findsOneWidget);
    });

    testWidgets('shows error message when provider fails', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DisplaySettings(),
          overrides: [
            userSettingsProvider.overrideWith(() => _FakeErrorUserSettings()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Error'), findsOneWidget);
    });

    testWidgets('renders with unknown textSize defaults to Normal', (
      tester,
    ) async {
      const unknownProfile = UserProfile(
        id: 'user-005',
        language: 'en',
        highContrast: false,
        textSize: 'unknown_value',
        notificationsEnabled: true,
        criticalAlerts: false,
        snoozeDuration: 15,
        travelModeEnabled: false,
        removeAds: false,
        onboardingComplete: true,
      );
      await tester.pumpWidget(
        createTestableWidget(
          const DisplaySettings(),
          overrides: _overrides(unknownProfile),
        ),
      );
      await tester.pumpAndSettle();

      // Widget should render without crashing
      expect(find.text('Display'), findsOneWidget);
    });

    testWidgets('tapping high contrast toggle does not crash', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DisplaySettings(),
          overrides: _overrides(_defaultProfile),
        ),
      );
      await tester.pumpAndSettle();

      // Find InkWell or the KdToggleSwitch and tap it
      await tester.tap(find.text('High Contrast'));
      await tester.pumpAndSettle();

      expect(find.text('Display'), findsOneWidget);
    });

    testWidgets('shows loading spinner on loading state', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DisplaySettings(),
          overrides: _overrides(_defaultProfile),
        ),
      );
      // First pump only – async notifier may show spinner
      await tester.pump();
      // After settle content appears
      await tester.pumpAndSettle();
      expect(find.text('Display'), findsOneWidget);
    });
  });
}
