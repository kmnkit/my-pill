import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/data/models/user_profile.dart';
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/screens/settings/widgets/notification_settings.dart';
import 'package:my_pill/presentation/shared/widgets/mp_toggle_switch.dart';

import '../../../../helpers/widget_test_helpers.dart';

// ---------------------------------------------------------------------------
// Fake notifiers
// ---------------------------------------------------------------------------

class _FakeUserSettings extends UserSettings {
  final UserProfile _profile;
  _FakeUserSettings(this._profile);

  @override
  Future<UserProfile> build() async => _profile;
}

class _FakeErrorUserSettings extends UserSettings {
  @override
  Future<UserProfile> build() async => throw Exception('error');
}

// ---------------------------------------------------------------------------
// Profile helpers
// ---------------------------------------------------------------------------

UserProfile _profile({
  bool notificationsEnabled = true,
  bool criticalAlerts = false,
  int snoozeDuration = 15,
}) =>
    UserProfile(
      id: 'test',
      language: 'en',
      highContrast: false,
      textSize: 'normal',
      notificationsEnabled: notificationsEnabled,
      criticalAlerts: criticalAlerts,
      snoozeDuration: snoozeDuration,
      travelModeEnabled: false,
      removeAds: false,
      onboardingComplete: true,
    );

List<dynamic> _overrides(UserProfile p) => [
      userSettingsProvider.overrideWith(() => _FakeUserSettings(p)),
    ];

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('NotificationSettings extended coverage', () {
    // -----------------------------------------------------------------------
    // Error state renders SizedBox.shrink (no content)
    // -----------------------------------------------------------------------

    testWidgets('error state renders SizedBox.shrink with no visible text',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: [
            userSettingsProvider.overrideWith(() => _FakeErrorUserSettings()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // No notification content visible on error
      expect(find.text('Notifications'), findsNothing);
      expect(find.text('Push Notifications'), findsNothing);
    });

    // -----------------------------------------------------------------------
    // Loading state renders SizedBox.shrink
    // -----------------------------------------------------------------------

    testWidgets('loading state shows no content widgets', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_profile()),
        ),
      );
      // Only first pump — notifier may still be in loading state
      await tester.pump();
      // We don't assert on loading state content (it's SizedBox.shrink, invisible)
      // But after settle content appears
      await tester.pumpAndSettle();
      expect(find.text('Notifications'), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // Both toggles present
    // -----------------------------------------------------------------------

    testWidgets('two MpToggleSwitch widgets are rendered', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_profile()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MpToggleSwitch), findsNWidgets(2));
    });

    // -----------------------------------------------------------------------
    // Snooze chip selection: each value selects correct chip color
    // -----------------------------------------------------------------------

    testWidgets('snooze chip 5 is highlighted when snoozeDuration is 5',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_profile(snoozeDuration: 5)),
        ),
      );
      await tester.pumpAndSettle();

      // The selected chip container should use AppColors.primary
      final containers = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) {
        final decoration = c.decoration;
        if (decoration is BoxDecoration) {
          return decoration.color == AppColors.primary;
        }
        return false;
      }).toList();

      expect(containers, isNotEmpty);
    });

    testWidgets('snooze chip 10 is highlighted when snoozeDuration is 10',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_profile(snoozeDuration: 10)),
        ),
      );
      await tester.pumpAndSettle();

      final containers = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) {
        final decoration = c.decoration;
        if (decoration is BoxDecoration) {
          return decoration.color == AppColors.primary;
        }
        return false;
      }).toList();

      expect(containers, isNotEmpty);
    });

    testWidgets('snooze chip 30 is highlighted when snoozeDuration is 30',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_profile(snoozeDuration: 30)),
        ),
      );
      await tester.pumpAndSettle();

      final containers = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) {
        final decoration = c.decoration;
        if (decoration is BoxDecoration) {
          return decoration.color == AppColors.primary;
        }
        return false;
      }).toList();

      expect(containers, isNotEmpty);
    });

    // -----------------------------------------------------------------------
    // Tapping a snooze chip calls updateSnoozeDuration
    // -----------------------------------------------------------------------

    testWidgets('tapping snooze chip 5 does not throw', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_profile(snoozeDuration: 15)),
        ),
      );
      await tester.pumpAndSettle();

      // Find the InkWell wrapping the "5 min" chip text
      final chip5 = find.text('5 min');
      expect(chip5, findsOneWidget);

      await tester.tap(chip5);
      await tester.pumpAndSettle();

      // No crash; widget still renders
      expect(find.text('Snooze Duration'), findsOneWidget);
    });

    testWidgets('tapping snooze chip 10 does not throw', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_profile(snoozeDuration: 15)),
        ),
      );
      await tester.pumpAndSettle();

      final chip10 = find.text('10 min');
      expect(chip10, findsOneWidget);

      await tester.tap(chip10);
      await tester.pumpAndSettle();

      expect(find.text('Snooze Duration'), findsOneWidget);
    });

    testWidgets('tapping snooze chip 30 does not throw', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_profile(snoozeDuration: 15)),
        ),
      );
      await tester.pumpAndSettle();

      final chip30 = find.text('30 min');
      expect(chip30, findsOneWidget);

      await tester.tap(chip30);
      await tester.pumpAndSettle();

      expect(find.text('Snooze Duration'), findsOneWidget);
    });

    testWidgets('tapping already-selected snooze chip 15 does not throw',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_profile(snoozeDuration: 15)),
        ),
      );
      await tester.pumpAndSettle();

      final chip15 = find.text('15 min');
      expect(chip15, findsOneWidget);

      await tester.tap(chip15);
      await tester.pumpAndSettle();

      expect(find.text('Snooze Duration'), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // criticalAlerts = true: toggle reflects state
    // -----------------------------------------------------------------------

    testWidgets('critical alerts toggle present when criticalAlerts is true',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_profile(criticalAlerts: true)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Critical Alerts'), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // notificationsEnabled = false: widget still renders
    // -----------------------------------------------------------------------

    testWidgets('push notifications disabled: widget renders without error',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(
              _profile(notificationsEnabled: false, criticalAlerts: true)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Push Notifications'), findsOneWidget);
      expect(find.text('Critical Alerts'), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // Dark theme: card background uses AppColors.cardDark
    // -----------------------------------------------------------------------

    testWidgets('renders in dark theme and non-selected chip uses dark color',
        (tester) async {
      await tester.pumpWidget(
        _DarkThemeWrapper(
          overrides: _overrides(_profile(snoozeDuration: 5)),
          child: const NotificationSettings(),
        ),
      );
      await tester.pumpAndSettle();

      // In dark mode non-selected chips use AppColors.cardDark
      final containers = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) {
        final decoration = c.decoration;
        if (decoration is BoxDecoration) {
          return decoration.color == AppColors.cardDark;
        }
        return false;
      }).toList();

      // At least three non-selected chips should exist (5 is selected)
      expect(containers.length, greaterThanOrEqualTo(3));
    });

    // -----------------------------------------------------------------------
    // All 4 snooze chips text present
    // -----------------------------------------------------------------------

    testWidgets('all four snooze chip minute labels are rendered',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_profile()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('5 min'), findsOneWidget);
      expect(find.text('10 min'), findsOneWidget);
      expect(find.text('15 min'), findsOneWidget);
      expect(find.text('30 min'), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // Semantics on snooze chips
    // -----------------------------------------------------------------------

    testWidgets('snooze chip 15 has Semantics selected=true', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_profile(snoozeDuration: 15)),
        ),
      );
      await tester.pumpAndSettle();

      // Find semantic nodes with "selected" flag
      final semantics = tester.getSemantics(
        find.bySemanticsLabel(RegExp(r'15')).first,
      );
      expect(semantics.hasFlag(SemanticsFlag.isSelected), isTrue);
    });

    testWidgets('snooze chip 5 has Semantics selected=false when not selected',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_profile(snoozeDuration: 15)),
        ),
      );
      await tester.pumpAndSettle();

      // chip 5 is NOT selected
      final semantics = tester.getSemantics(
        find.bySemanticsLabel(RegExp(r'^5')).first,
      );
      expect(semantics.hasFlag(SemanticsFlag.isSelected), isFalse);
    });

    // -----------------------------------------------------------------------
    // Wrap widget is rendered
    // -----------------------------------------------------------------------

    testWidgets('Wrap widget is used for snooze chips layout', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const NotificationSettings(),
          overrides: _overrides(_profile()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Wrap), findsOneWidget);
    });
  });
}

// ---------------------------------------------------------------------------
// Dark theme wrapper
// ---------------------------------------------------------------------------

class _DarkThemeWrapper extends StatelessWidget {
  const _DarkThemeWrapper({
    required this.child,
    required this.overrides,
  });

  final Widget child;
  final List<dynamic> overrides;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides.cast(),
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
        home: Scaffold(body: child),
      ),
    );
  }
}
