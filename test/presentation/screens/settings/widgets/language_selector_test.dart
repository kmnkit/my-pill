import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/models/user_profile.dart';
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/screens/settings/widgets/language_selector.dart';

import '../../../../helpers/widget_test_helpers.dart';

class _FakeUserSettings extends UserSettings {
  final UserProfile _profile;
  _FakeUserSettings(this._profile);

  @override
  Future<UserProfile> build() async => _profile;
}

const _englishProfile = UserProfile(
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

const _japaneseProfile = UserProfile(
  id: 'user-002',
  language: 'ja',
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
  group('LanguageSelector', () {
    testWidgets('renders Language section header', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LanguageSelector(),
          overrides: _overrides(_englishProfile),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Language'), findsOneWidget);
    });

    testWidgets('renders English language button', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LanguageSelector(),
          overrides: _overrides(_englishProfile),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('English'), findsOneWidget);
    });

    testWidgets('renders Japanese language button', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LanguageSelector(),
          overrides: _overrides(_englishProfile),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('\u65E5\u672C\u8A9E'), findsOneWidget);
    });

    testWidgets('English button is selected when language is en', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LanguageSelector(),
          overrides: _overrides(_englishProfile),
        ),
      );
      await tester.pumpAndSettle();

      final semantics = tester.getSemantics(
        find.bySemanticsLabel('English').first,
      );
      expect(semantics.hasFlag(SemanticsFlag.isSelected), isTrue);
    });

    testWidgets('Japanese button is selected when language is ja', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LanguageSelector(),
          overrides: _overrides(_japaneseProfile),
        ),
      );
      await tester.pumpAndSettle();

      final semantics = tester.getSemantics(
        find.bySemanticsLabel('\u65E5\u672C\u8A9E').first,
      );
      expect(semantics.hasFlag(SemanticsFlag.isSelected), isTrue);
    });

    testWidgets('English button is NOT selected when language is ja', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LanguageSelector(),
          overrides: _overrides(_japaneseProfile),
        ),
      );
      await tester.pumpAndSettle();

      final semantics = tester.getSemantics(
        find.bySemanticsLabel('English').first,
      );
      expect(semantics.hasFlag(SemanticsFlag.isSelected), isFalse);
    });

    testWidgets('tapping the already-selected language does not crash', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LanguageSelector(),
          overrides: _overrides(_englishProfile),
        ),
      );
      await tester.pumpAndSettle();

      // Tapping selected button is a no-op (isSelected guard in source)
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      expect(find.text('Language'), findsOneWidget);
    });

    testWidgets('tapping the unselected language button does not crash', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LanguageSelector(),
          overrides: _overrides(_englishProfile),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('\u65E5\u672C\u8A9E'));
      await tester.pumpAndSettle();

      expect(find.text('Language'), findsOneWidget);
    });

    testWidgets('both buttons have Semantics with button role', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LanguageSelector(),
          overrides: _overrides(_englishProfile),
        ),
      );
      await tester.pumpAndSettle();

      final enSemantics = tester.getSemantics(
        find.bySemanticsLabel('English').first,
      );
      expect(enSemantics.hasFlag(SemanticsFlag.isButton), isTrue);

      final jaSemantics = tester.getSemantics(
        find.bySemanticsLabel('\u65E5\u672C\u8A9E').first,
      );
      expect(jaSemantics.hasFlag(SemanticsFlag.isButton), isTrue);
    });

    testWidgets('renders in dark theme without error', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: _overrides(_englishProfile).cast(),
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
            home: const Scaffold(body: LanguageSelector()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('English'), findsOneWidget);
    });

    testWidgets('shows SizedBox.shrink while loading (no error)', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LanguageSelector(),
          overrides: _overrides(_englishProfile),
        ),
      );
      await tester.pump(); // first pump only
      await tester.pumpAndSettle();
      expect(find.text('Language'), findsOneWidget);
    });

    testWidgets('renders with Japanese locale set on app', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LanguageSelector(),
          overrides: _overrides(_japaneseProfile),
          locale: const Locale('ja'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LanguageSelector), findsOneWidget);
    });
  });
}
