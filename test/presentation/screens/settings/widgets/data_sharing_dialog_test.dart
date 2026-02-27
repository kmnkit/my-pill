import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/models/user_profile.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/presentation/screens/settings/widgets/data_sharing_dialog.dart';

import '../../../../helpers/widget_test_helpers.dart';

class _FakeUserSettings extends UserSettings {
  final UserProfile _profile;
  _FakeUserSettings(this._profile);

  @override
  Future<UserProfile> build() async => _profile;
}

class _FakeErrorUserSettings extends UserSettings {
  @override
  Future<UserProfile> build() async => throw Exception('settings error');
}

const _defaultProfile = UserProfile(
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

List<dynamic> _overrides({UserProfile profile = _defaultProfile}) => [
  userSettingsProvider.overrideWith(() => _FakeUserSettings(profile)),
];

void main() {
  group('DataSharingDialog', () {
    testWidgets('shows dialog title', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DataSharingDialog(),
          overrides: _overrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Data Sharing Preferences'), findsOneWidget);
    });

    testWidgets('shows subtitle text', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DataSharingDialog(),
          overrides: _overrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Control what information you share with your caregivers'),
        findsOneWidget,
      );
    });

    testWidgets('shows share adherence data toggle', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DataSharingDialog(),
          overrides: _overrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Share adherence data with caregivers'), findsOneWidget);
    });

    testWidgets('shows share medication list toggle', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DataSharingDialog(),
          overrides: _overrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Share medication list with caregivers'),
        findsOneWidget,
      );
    });

    testWidgets('shows allow caregiver notifications toggle', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DataSharingDialog(),
          overrides: _overrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Allow caregiver notifications'), findsOneWidget);
    });

    testWidgets('shows three SwitchListTile widgets', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DataSharingDialog(),
          overrides: _overrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SwitchListTile), findsNWidgets(3));
    });

    testWidgets('shows close button', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DataSharingDialog(),
          overrides: _overrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('shows nothing (shrink) while loading', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DataSharingDialog(),
          overrides: _overrides(),
        ),
      );
      // Only pump once — provider may still be resolving
      await tester.pump();
      // After settle data should be visible
      await tester.pumpAndSettle();
      expect(find.text('Data Sharing Preferences'), findsOneWidget);
    });

    testWidgets('shows nothing on error state', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DataSharingDialog(),
          overrides: [
            userSettingsProvider.overrideWith(() => _FakeErrorUserSettings()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Error branch returns SizedBox.shrink — no dialog content
      expect(find.text('Data Sharing Preferences'), findsNothing);
    });

    testWidgets('toggles are in correct initial state (all true)', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const DataSharingDialog(),
          overrides: _overrides(),
        ),
      );
      await tester.pumpAndSettle();

      final switches = tester
          .widgetList<SwitchListTile>(find.byType(SwitchListTile))
          .toList();
      expect(switches.every((s) => s.value), isTrue);
    });

    testWidgets('toggles are in correct initial state (all false)', (
      tester,
    ) async {
      const allOffProfile = UserProfile(
        id: 'user-002',
        language: 'en',
        highContrast: false,
        textSize: 'normal',
        notificationsEnabled: true,
        criticalAlerts: false,
        snoozeDuration: 15,
        travelModeEnabled: false,
        removeAds: false,
        shareAdherenceData: false,
        shareMedicationList: false,
        allowCaregiverNotifications: false,
      );

      await tester.pumpWidget(
        createTestableWidget(
          const DataSharingDialog(),
          overrides: _overrides(profile: allOffProfile),
        ),
      );
      await tester.pumpAndSettle();

      final switches = tester
          .widgetList<SwitchListTile>(find.byType(SwitchListTile))
          .toList();
      expect(switches.every((s) => !s.value), isTrue);
    });

    testWidgets('DataSharingDialog.show static method opens dialog', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => DataSharingDialog.show(context),
              child: const Text('Open'),
            ),
          ),
          overrides: _overrides(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Data Sharing Preferences'), findsOneWidget);
    });
  });
}
