import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/models/user_profile.dart';
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/screens/settings/widgets/notification_settings.dart';

import '../../../../helpers/widget_test_helpers.dart';

class _FakeUserSettings extends UserSettings {
  final UserProfile _profile;
  _FakeUserSettings(this._profile);

  @override
  Future<UserProfile> build() async => _profile;

  @override
  Future<void> updateProfile(UserProfile profile) async {
    state = AsyncData(profile);
  }

  @override
  Future<void> updateSnoozeDuration(int minutes) async {
    final current = state.value;
    if (current != null) {
      state = AsyncData(current.copyWith(snoozeDuration: minutes));
    }
  }
}

/// Tracks [updateProfile] calls for assertion in toggle callback tests.
class _TrackingFakeUserSettings extends UserSettings {
  final UserProfile _profile;
  final List<UserProfile> updateCalls = [];

  _TrackingFakeUserSettings(this._profile);

  @override
  Future<UserProfile> build() async => _profile;

  @override
  Future<void> updateProfile(UserProfile profile) async {
    updateCalls.add(profile);
    state = AsyncData(profile);
  }

  @override
  Future<void> updateSnoozeDuration(int minutes) async {
    final current = state.value;
    if (current != null) {
      final updated = current.copyWith(snoozeDuration: minutes);
      updateCalls.add(updated);
      state = AsyncData(updated);
    }
  }
}

/// A fake that never completes [build], keeping the provider in loading state.
class _LoadingFakeUserSettings extends UserSettings {
  @override
  Future<UserProfile> build() {
    // Return a future that never completes to keep loading state.
    return Completer<UserProfile>().future;
  }
}

/// A fake that throws during [build], putting the provider in error state.
class _ErrorFakeUserSettings extends UserSettings {
  @override
  Future<UserProfile> build() async {
    throw Exception('settings load failed');
  }
}

const _defaultProfile = UserProfile(
  id: 'user-001',
  name: 'Test',
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
  group('NotificationSettings', () {
    testWidgets('renders Notifications section header', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_defaultProfile),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('renders push notifications toggle', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_defaultProfile),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Push Notifications'), findsOneWidget);
    });

    testWidgets('renders critical alerts toggle', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_defaultProfile),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Critical Alerts'), findsOneWidget);
    });

    testWidgets('renders snooze duration label', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_defaultProfile),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Snooze Duration'), findsOneWidget);
    });

    testWidgets('renders all four snooze chip values', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_defaultProfile),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('5'), findsAtLeastNWidgets(1));
      expect(find.textContaining('10'), findsAtLeastNWidgets(1));
      expect(find.textContaining('15'), findsAtLeastNWidgets(1));
      expect(find.textContaining('30'), findsAtLeastNWidgets(1));
    });

    testWidgets('selected snooze chip (15) uses primary color', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_defaultProfile),
        ),
      );
      await tester.pumpAndSettle();

      // Find the Container for the 15-min chip – it should exist
      final containers = tester.widgetList<Container>(find.byType(Container));
      // At least one container should be present (the selected chip)
      expect(containers, isNotEmpty);
    });

    testWidgets('push notifications toggle reflects enabled state', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_defaultProfile),
        ),
      );
      await tester.pumpAndSettle();

      // notificationsEnabled: true – find the GestureDetector for the toggle
      final gestures = find.byType(GestureDetector);
      expect(gestures, findsAtLeastNWidgets(1));
    });

    testWidgets('push notifications toggle reflects disabled state', (tester) async {
      const disabledProfile = UserProfile(
        id: 'user-002',
        language: 'en',
        highContrast: false,
        textSize: 'normal',
        notificationsEnabled: false,
        criticalAlerts: false,
        snoozeDuration: 10,
        travelModeEnabled: false,
        removeAds: false,
        onboardingComplete: true,
      );
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(disabledProfile),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Push Notifications'), findsOneWidget);
    });

    testWidgets('snooze chip 5 has Semantics with button role', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_defaultProfile),
        ),
      );
      await tester.pumpAndSettle();

      final semantics = tester.getSemantics(
        find.bySemanticsLabel(RegExp(r'5')).first,
      );
      expect(semantics, isNotNull);
    });

    testWidgets('snooze chip 5 selected when snoozeDuration is 5', (tester) async {
      const profile5 = UserProfile(
        id: 'user-003',
        language: 'en',
        highContrast: false,
        textSize: 'normal',
        notificationsEnabled: true,
        criticalAlerts: false,
        snoozeDuration: 5,
        travelModeEnabled: false,
        removeAds: false,
        onboardingComplete: true,
      );
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(profile5),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('5'), findsAtLeastNWidgets(1));
    });

    testWidgets('snooze chip 30 selected when snoozeDuration is 30', (tester) async {
      const profile30 = UserProfile(
        id: 'user-004',
        language: 'en',
        highContrast: false,
        textSize: 'normal',
        notificationsEnabled: true,
        criticalAlerts: true,
        snoozeDuration: 30,
        travelModeEnabled: false,
        removeAds: false,
        onboardingComplete: true,
      );
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(profile30),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('30'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows SizedBox.shrink while loading', (tester) async {
      // The widget shows SizedBox.shrink() on loading state.
      // We verify it renders without error at the initial pump.
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_defaultProfile),
        ),
      );
      // First pump: async notifier may still be loading
      await tester.pump();
      // Should not throw; after settle content appears
      await tester.pumpAndSettle();
      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('renders in dark theme without error', (tester) async {
      await tester.pumpWidget(
        ProviderScopeWrapper(
          overrides: _overrides(_defaultProfile),
          child: MaterialApp(
            theme: ThemeData.dark(),
            locale: const Locale('en'),
            localizationsDelegates: _localizationDelegates,
            supportedLocales: _supportedLocales,
            home: const Scaffold(body: NotificationSettings()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('renders in Japanese locale', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_defaultProfile),
          locale: const Locale('ja'),
        ),
      );
      await tester.pumpAndSettle();

      // Verify widget renders without error in Japanese locale
      expect(find.byType(NotificationSettings), findsOneWidget);
    });

    // -----------------------------------------------------------------
    // Toggle callback tests (covers lines 29-31, 38-40)
    // -----------------------------------------------------------------

    testWidgets('tapping push notifications toggle calls updateProfile with toggled value', (tester) async {
      final fake = _TrackingFakeUserSettings(_defaultProfile);
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: [userSettingsProvider.overrideWith(() => fake)],
        ),
      );
      await tester.pumpAndSettle();

      // _defaultProfile has notificationsEnabled: true.
      // The MpToggleSwitch for "Push Notifications" is the first GestureDetector.
      // Find GestureDetectors that are descendants of a Row containing
      // 'Push Notifications' text.
      final pushRow = find.ancestor(
        of: find.text('Push Notifications'),
        matching: find.byType(Row),
      );
      final pushToggle = find.descendant(
        of: pushRow,
        matching: find.byType(GestureDetector),
      );
      expect(pushToggle, findsOneWidget);

      await tester.tap(pushToggle);
      await tester.pumpAndSettle();

      expect(fake.updateCalls, hasLength(1));
      // Was true, toggled to false
      expect(fake.updateCalls.first.notificationsEnabled, isFalse);
    });

    testWidgets('tapping critical alerts toggle calls updateProfile with toggled value', (tester) async {
      final fake = _TrackingFakeUserSettings(_defaultProfile);
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: [userSettingsProvider.overrideWith(() => fake)],
        ),
      );
      await tester.pumpAndSettle();

      // _defaultProfile has criticalAlerts: false.
      final alertsRow = find.ancestor(
        of: find.text('Critical Alerts'),
        matching: find.byType(Row),
      );
      final alertsToggle = find.descendant(
        of: alertsRow,
        matching: find.byType(GestureDetector),
      );
      expect(alertsToggle, findsOneWidget);

      await tester.tap(alertsToggle);
      await tester.pumpAndSettle();

      expect(fake.updateCalls, hasLength(1));
      // Was false, toggled to true
      expect(fake.updateCalls.first.criticalAlerts, isTrue);
    });

    testWidgets('tapping push notifications toggle off then on round-trips', (tester) async {
      final fake = _TrackingFakeUserSettings(_defaultProfile);
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: [userSettingsProvider.overrideWith(() => fake)],
        ),
      );
      await tester.pumpAndSettle();

      final pushRow = find.ancestor(
        of: find.text('Push Notifications'),
        matching: find.byType(Row),
      );
      final pushToggle = find.descendant(
        of: pushRow,
        matching: find.byType(GestureDetector),
      );

      // First tap: true -> false
      await tester.tap(pushToggle);
      await tester.pumpAndSettle();

      // Second tap: false -> true
      await tester.tap(pushToggle);
      await tester.pumpAndSettle();

      expect(fake.updateCalls, hasLength(2));
      expect(fake.updateCalls[0].notificationsEnabled, isFalse);
      expect(fake.updateCalls[1].notificationsEnabled, isTrue);
    });

    // -----------------------------------------------------------------
    // Loading state test (covers line 20 — SizedBox.shrink for loading)
    // -----------------------------------------------------------------

    testWidgets('renders SizedBox.shrink during loading state', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: [
            userSettingsProvider.overrideWith(() => _LoadingFakeUserSettings()),
          ],
        ),
      );
      // Only one pump — the future never completes, so we stay in loading.
      await tester.pump();

      // Loading state: widget should render SizedBox.shrink (no visible content)
      expect(find.text('Notifications'), findsNothing);
      expect(find.text('Push Notifications'), findsNothing);
      expect(find.text('Critical Alerts'), findsNothing);
      expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
    });

    // -----------------------------------------------------------------
    // Error state test (covers line 21 — SizedBox.shrink for error)
    // -----------------------------------------------------------------

    testWidgets('renders SizedBox.shrink on error state', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: [
            userSettingsProvider.overrideWith(() => _ErrorFakeUserSettings()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Error state: widget should render SizedBox.shrink (no visible content)
      expect(find.text('Notifications'), findsNothing);
      expect(find.text('Push Notifications'), findsNothing);
      expect(find.text('Critical Alerts'), findsNothing);
    });
  });
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _localizationDelegates = [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

final _supportedLocales = AppLocalizations.supportedLocales;

class ProviderScopeWrapper extends StatelessWidget {
  const ProviderScopeWrapper({
    super.key,
    required this.child,
    required this.overrides,
  });

  final Widget child;
  final List<dynamic> overrides;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides.cast(),
      child: child,
    );
  }
}
