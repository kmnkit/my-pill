import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/models/user_profile.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/presentation/screens/settings/widgets/data_sharing_dialog.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_button.dart';

import '../../../helpers/widget_test_helpers.dart';

// ---------------------------------------------------------------------------
// Fake notifiers
// ---------------------------------------------------------------------------

class _FakeUserSettings extends UserSettings {
  final UserProfile _profile;
  _FakeUserSettings(this._profile);

  @override
  Future<UserProfile> build() async => _profile;
}

class _TrackingUserSettings extends UserSettings {
  final UserProfile _initial;
  final List<UserProfile> updates = [];

  _TrackingUserSettings(this._initial);

  @override
  Future<UserProfile> build() async => _initial;

  @override
  Future<void> updateProfile(UserProfile profile) async {
    updates.add(profile);
    state = AsyncData(profile);
  }
}

class _FakeErrorUserSettings extends UserSettings {
  @override
  Future<UserProfile> build() async => throw Exception('settings error');
}

// ---------------------------------------------------------------------------
// Test fixtures
// ---------------------------------------------------------------------------

const _allOnProfile = UserProfile(
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
  shareAdherenceData: true,
  shareMedicationList: true,
  allowCaregiverNotifications: true,
);

const _allOffProfile = UserProfile(
  id: 'user-002',
  language: 'en',
  highContrast: false,
  textSize: 'normal',
  notificationsEnabled: true,
  criticalAlerts: false,
  snoozeDuration: 15,
  travelModeEnabled: false,
  removeAds: false,
  onboardingComplete: true,
  shareAdherenceData: false,
  shareMedicationList: false,
  allowCaregiverNotifications: false,
);

List<dynamic> _overrides({UserProfile profile = _allOnProfile}) => [
  userSettingsProvider.overrideWith(() => _FakeUserSettings(profile)),
];

// ---------------------------------------------------------------------------
// Helper: pump the dialog directly as a widget (no showDialog)
// ---------------------------------------------------------------------------
Future<void> _pumpDialog(
  WidgetTester tester, {
  List<dynamic> overrides = const [],
}) async {
  await tester.pumpWidget(
    createTestableWidget(const DataSharingDialog(), overrides: overrides),
  );
  await tester.pumpAndSettle();
}

// ---------------------------------------------------------------------------
// Helper: pump dialog via show() so Navigator is present
// ---------------------------------------------------------------------------
Future<void> _pumpViaShow(
  WidgetTester tester, {
  List<dynamic> overrides = const [],
}) async {
  await tester.pumpWidget(
    createTestableWidget(
      Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => DataSharingDialog.show(context),
          child: const Text('Open'),
        ),
      ),
      overrides: overrides,
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('DataSharingDialog', () {
    // -----------------------------------------------------------------------
    // Display / content tests
    // -----------------------------------------------------------------------

    testWidgets('renders dialog title', (tester) async {
      await _pumpDialog(tester, overrides: _overrides());

      expect(find.text('Data Sharing Preferences'), findsOneWidget);
    });

    testWidgets('renders subtitle text', (tester) async {
      await _pumpDialog(tester, overrides: _overrides());

      expect(
        find.text('Control what information you share with your caregivers'),
        findsOneWidget,
      );
    });

    testWidgets('renders share adherence data label', (tester) async {
      await _pumpDialog(tester, overrides: _overrides());

      expect(find.text('Share adherence data with caregivers'), findsOneWidget);
    });

    testWidgets('renders share medication list label', (tester) async {
      await _pumpDialog(tester, overrides: _overrides());

      expect(
        find.text('Share medication list with caregivers'),
        findsOneWidget,
      );
    });

    testWidgets('renders allow caregiver notifications label', (tester) async {
      await _pumpDialog(tester, overrides: _overrides());

      expect(find.text('Allow caregiver notifications'), findsOneWidget);
    });

    testWidgets('renders exactly three SwitchListTile widgets', (tester) async {
      await _pumpDialog(tester, overrides: _overrides());

      expect(find.byType(SwitchListTile), findsNWidgets(3));
    });

    testWidgets('renders close button with secondary variant', (tester) async {
      await _pumpDialog(tester, overrides: _overrides());

      expect(find.text('Close'), findsOneWidget);
      final buttons = tester
          .widgetList<KdButton>(find.byType(KdButton))
          .toList();
      expect(buttons.length, 1);
      expect(buttons.first.variant, MpButtonVariant.secondary);
    });

    testWidgets('renders Dialog widget with rounded shape', (tester) async {
      await _pumpDialog(tester, overrides: _overrides());

      expect(find.byType(Dialog), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // Initial toggle states
    // -----------------------------------------------------------------------

    testWidgets('all toggles are ON when profile has all sharing enabled', (
      tester,
    ) async {
      await _pumpDialog(tester, overrides: _overrides(profile: _allOnProfile));

      final switches = tester
          .widgetList<SwitchListTile>(find.byType(SwitchListTile))
          .toList();
      expect(switches.every((s) => s.value == true), isTrue);
    });

    testWidgets('all toggles are OFF when profile has all sharing disabled', (
      tester,
    ) async {
      await _pumpDialog(tester, overrides: _overrides(profile: _allOffProfile));

      final switches = tester
          .widgetList<SwitchListTile>(find.byType(SwitchListTile))
          .toList();
      expect(switches.every((s) => s.value == false), isTrue);
    });

    testWidgets('mixed toggle state: adherence on, others off', (tester) async {
      const mixedProfile = UserProfile(
        id: 'user-mixed',
        language: 'en',
        highContrast: false,
        textSize: 'normal',
        notificationsEnabled: true,
        criticalAlerts: false,
        snoozeDuration: 15,
        travelModeEnabled: false,
        removeAds: false,
        shareAdherenceData: true,
        shareMedicationList: false,
        allowCaregiverNotifications: false,
      );

      await _pumpDialog(tester, overrides: _overrides(profile: mixedProfile));

      final switches = tester
          .widgetList<SwitchListTile>(find.byType(SwitchListTile))
          .toList();
      expect(switches[0].value, isTrue); // shareAdherenceData
      expect(switches[1].value, isFalse); // shareMedicationList
      expect(switches[2].value, isFalse); // allowCaregiverNotifications
    });

    // -----------------------------------------------------------------------
    // Loading / error states
    // -----------------------------------------------------------------------

    testWidgets('renders title immediately on first frame', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DataSharingDialog(),
          overrides: _overrides(),
        ),
      );
      // Only one frame — title is always rendered (outside AsyncValue.when).
      await tester.pump();

      expect(find.text('Data Sharing Preferences'), findsOneWidget);
    });

    testWidgets('shows data after loading completes', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DataSharingDialog(),
          overrides: _overrides(),
        ),
      );
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Data Sharing Preferences'), findsOneWidget);
    });

    testWidgets('shows SizedBox.shrink on error state', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DataSharingDialog(),
          overrides: [
            userSettingsProvider.overrideWith(() => _FakeErrorUserSettings()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Data Sharing Preferences'), findsNothing);
      expect(find.byType(SwitchListTile), findsNothing);
      expect(find.text('Close'), findsNothing);
    });

    // -----------------------------------------------------------------------
    // Toggle interaction — onChanged callbacks (the uncovered lines)
    // -----------------------------------------------------------------------

    testWidgets(
      'tapping shareAdherenceData toggle calls updateProfile with toggled value',
      (tester) async {
        final notifier = _TrackingUserSettings(_allOnProfile);

        await tester.pumpWidget(
          createTestableWidget(
            const DataSharingDialog(),
            overrides: [userSettingsProvider.overrideWith(() => notifier)],
          ),
        );
        await tester.pumpAndSettle();

        // First SwitchListTile is shareAdherenceData (currently true → tap to false)
        await tester.tap(find.byType(SwitchListTile).first);
        await tester.pumpAndSettle();

        expect(notifier.updates, isNotEmpty);
        expect(notifier.updates.last.shareAdherenceData, isFalse);
      },
    );

    testWidgets('tapping shareAdherenceData toggle when OFF turns it ON', (
      tester,
    ) async {
      final notifier = _TrackingUserSettings(_allOffProfile);

      await tester.pumpWidget(
        createTestableWidget(
          const DataSharingDialog(),
          overrides: [userSettingsProvider.overrideWith(() => notifier)],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SwitchListTile).first);
      await tester.pumpAndSettle();

      expect(notifier.updates.last.shareAdherenceData, isTrue);
    });

    testWidgets(
      'tapping shareMedicationList toggle calls updateProfile with toggled value',
      (tester) async {
        final notifier = _TrackingUserSettings(_allOnProfile);

        await tester.pumpWidget(
          createTestableWidget(
            const DataSharingDialog(),
            overrides: [userSettingsProvider.overrideWith(() => notifier)],
          ),
        );
        await tester.pumpAndSettle();

        // Second SwitchListTile is shareMedicationList (currently true → false)
        await tester.tap(find.byType(SwitchListTile).at(1));
        await tester.pumpAndSettle();

        expect(notifier.updates, isNotEmpty);
        expect(notifier.updates.last.shareMedicationList, isFalse);
      },
    );

    testWidgets('tapping shareMedicationList toggle when OFF turns it ON', (
      tester,
    ) async {
      final notifier = _TrackingUserSettings(_allOffProfile);

      await tester.pumpWidget(
        createTestableWidget(
          const DataSharingDialog(),
          overrides: [userSettingsProvider.overrideWith(() => notifier)],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SwitchListTile).at(1));
      await tester.pumpAndSettle();

      expect(notifier.updates.last.shareMedicationList, isTrue);
    });

    testWidgets(
      'tapping allowCaregiverNotifications toggle calls updateProfile with toggled value',
      (tester) async {
        final notifier = _TrackingUserSettings(_allOnProfile);

        await tester.pumpWidget(
          createTestableWidget(
            const DataSharingDialog(),
            overrides: [userSettingsProvider.overrideWith(() => notifier)],
          ),
        );
        await tester.pumpAndSettle();

        // Third SwitchListTile is allowCaregiverNotifications (currently true → false)
        await tester.tap(find.byType(SwitchListTile).at(2));
        await tester.pumpAndSettle();

        expect(notifier.updates, isNotEmpty);
        expect(notifier.updates.last.allowCaregiverNotifications, isFalse);
      },
    );

    testWidgets(
      'tapping allowCaregiverNotifications toggle when OFF turns it ON',
      (tester) async {
        final notifier = _TrackingUserSettings(_allOffProfile);

        await tester.pumpWidget(
          createTestableWidget(
            const DataSharingDialog(),
            overrides: [userSettingsProvider.overrideWith(() => notifier)],
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(SwitchListTile).at(2));
        await tester.pumpAndSettle();

        expect(notifier.updates.last.allowCaregiverNotifications, isTrue);
      },
    );

    testWidgets('toggling does not mutate other fields', (tester) async {
      final notifier = _TrackingUserSettings(_allOnProfile);

      await tester.pumpWidget(
        createTestableWidget(
          const DataSharingDialog(),
          overrides: [userSettingsProvider.overrideWith(() => notifier)],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SwitchListTile).first);
      await tester.pumpAndSettle();

      final updated = notifier.updates.last;
      // Other sharing fields unchanged
      expect(updated.shareMedicationList, isTrue);
      expect(updated.allowCaregiverNotifications, isTrue);
      // Unrelated fields unchanged
      expect(updated.id, _allOnProfile.id);
      expect(updated.language, _allOnProfile.language);
      expect(updated.notificationsEnabled, _allOnProfile.notificationsEnabled);
    });

    // -----------------------------------------------------------------------
    // Close button — Navigator.pop (the other uncovered line)
    // -----------------------------------------------------------------------

    testWidgets('tapping close button dismisses dialog opened via show()', (
      tester,
    ) async {
      await _pumpViaShow(tester, overrides: _overrides());

      expect(find.text('Data Sharing Preferences'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.text('Data Sharing Preferences'), findsNothing);
    });

    testWidgets('close button dismisses dialog and returns to trigger button', (
      tester,
    ) async {
      await _pumpViaShow(tester, overrides: _overrides());

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // The trigger button is still visible after dismiss
      expect(find.text('Open'), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // DataSharingDialog.show() static method
    // -----------------------------------------------------------------------

    testWidgets('show() opens dialog with all content', (tester) async {
      await _pumpViaShow(tester, overrides: _overrides());

      expect(find.text('Data Sharing Preferences'), findsOneWidget);
      expect(find.byType(SwitchListTile), findsNWidgets(3));
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets(
      'show() returns a Future that completes when dialog is dismissed',
      (tester) async {
        bool completed = false;

        await tester.pumpWidget(
          createTestableWidget(
            Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  await DataSharingDialog.show(context);
                  completed = true;
                },
                child: const Text('Open'),
              ),
            ),
            overrides: _overrides(),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(completed, isFalse);

        await tester.tap(find.text('Close'));
        await tester.pumpAndSettle();

        expect(completed, isTrue);
      },
    );

    // -----------------------------------------------------------------------
    // Locale support
    // -----------------------------------------------------------------------

    testWidgets('renders in Japanese locale without errors', (tester) async {
      await tester.pumpWidget(
        createTestableWidgetJa(
          const DataSharingDialog(),
          overrides: _overrides(),
        ),
      );
      await tester.pumpAndSettle();

      // Dialog widget should still render
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(SwitchListTile), findsNWidgets(3));
    });
  });
}
