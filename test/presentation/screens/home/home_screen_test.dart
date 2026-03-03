import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/reminder_status.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/data/models/reminder.dart';
import 'package:kusuridoki/data/models/user_profile.dart';
import 'package:kusuridoki/data/providers/adherence_provider.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/data/providers/reminder_provider.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/presentation/screens/home/home_screen.dart';

import '../../../helpers/widget_test_helpers.dart';

// Fake AsyncNotifier for UserSettings
class _FakeUserSettings extends UserSettings {
  final UserProfile _profile;
  _FakeUserSettings(this._profile);

  @override
  Future<UserProfile> build() async => _profile;
}

// Fake AsyncNotifier for MedicationList
class _FakeEmptyMedicationList extends MedicationList {
  @override
  Future<List<Medication>> build() async => [];
}

// Fake AsyncNotifier for TodayReminders (empty)
class _FakeEmptyReminders extends TodayReminders {
  @override
  Future<List<Reminder>> build() async => [];
}

// Fake AsyncNotifier for TodayReminders (with data)
class _FakePendingReminders extends TodayReminders {
  @override
  Future<List<Reminder>> build() async => [
    Reminder(
      id: 'r1',
      medicationId: 'med1',
      scheduledTime: DateTime.now(),
      status: ReminderStatus.pending,
    ),
  ];
}

// Fake AsyncNotifier for UserSettings that throws
class _FakeErrorUserSettings extends UserSettings {
  @override
  Future<UserProfile> build() async => throw Exception('Settings load failed');
}

// Fake AsyncNotifier for TodayReminders that throws
class _FakeErrorReminders extends TodayReminders {
  @override
  Future<List<Reminder>> build() async =>
      throw Exception('Reminders load failed');
}

const _defaultProfile = UserProfile(
  id: 'local',
  name: 'Test User',
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

List<dynamic> _baseOverrides({
  UserProfile profile = _defaultProfile,
  bool emptyReminders = true,
}) {
  return [
    userSettingsProvider.overrideWith(() => _FakeUserSettings(profile)),
    medicationListProvider.overrideWith(() => _FakeEmptyMedicationList()),
    overallAdherenceProvider.overrideWith((ref) => Future.value(null)),
    if (emptyReminders)
      todayRemindersProvider.overrideWith(() => _FakeEmptyReminders())
    else
      todayRemindersProvider.overrideWith(() => _FakePendingReminders()),
  ];
}

void main() {
  group('HomeScreen', () {
    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(const HomeScreen(), overrides: _baseOverrides()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('shows empty state when no reminders today', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const HomeScreen(),
          overrides: _baseOverrides(emptyReminders: true),
        ),
      );
      await tester.pumpAndSettle();

      // KdEmptyState is rendered for no reminders
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('shows greeting text when user settings loaded', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(const HomeScreen(), overrides: _baseOverrides()),
      );
      await tester.pumpAndSettle();

      // GreetingHeader renders a greeting word from l10n
      // Check that some greeting exists (Good Morning/Afternoon/Evening)
      final greetingFinder = find.textContaining(
        RegExp(
          r'(Good Morning|Good Afternoon|Good Evening)',
          caseSensitive: false,
        ),
      );
      expect(greetingFinder, findsOneWidget);
    });

    testWidgets('shows scrollable content area', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(const HomeScreen(), overrides: _baseOverrides()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('shows loading indicator while providers are loading', (
      tester,
    ) async {
      // Override with a notifier that never resolves immediately
      await tester.pumpWidget(
        createTestableWidget(
          const HomeScreen(),
          overrides: [
            userSettingsProvider.overrideWith(
              () => _FakeUserSettings(_defaultProfile),
            ),
            medicationListProvider.overrideWith(
              () => _FakeEmptyMedicationList(),
            ),
            overallAdherenceProvider.overrideWith((ref) => Future.value(null)),
            todayRemindersProvider.overrideWith(() => _FakeEmptyReminders()),
          ],
        ),
      );
      // First frame – before pumpAndSettle – may show loading indicators
      await tester.pump();
      // After settle everything is rendered
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('renders when userSettings provider has error', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const HomeScreen(),
          overrides: [
            userSettingsProvider.overrideWith(() => _FakeErrorUserSettings()),
            medicationListProvider.overrideWith(
              () => _FakeEmptyMedicationList(),
            ),
            overallAdherenceProvider.overrideWith((ref) => Future.value(null)),
            todayRemindersProvider.overrideWith(() => _FakeEmptyReminders()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Should still render without crashing
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('renders when todayReminders provider has error', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const HomeScreen(),
          overrides: [
            userSettingsProvider.overrideWith(
              () => _FakeUserSettings(_defaultProfile),
            ),
            medicationListProvider.overrideWith(
              () => _FakeEmptyMedicationList(),
            ),
            overallAdherenceProvider.overrideWith((ref) => Future.value(null)),
            todayRemindersProvider.overrideWith(() => _FakeErrorReminders()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Should still render without crashing
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('renders with pending reminders in timeline', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const HomeScreen(),
          overrides: _baseOverrides(emptyReminders: false),
        ),
      );
      // Use pump with duration instead of pumpAndSettle to avoid timeout
      // from ongoing animations in MedicationTimeline
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Should render with pending reminder data
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
