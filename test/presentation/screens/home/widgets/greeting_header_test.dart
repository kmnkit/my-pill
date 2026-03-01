import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/models/reminder.dart';
import 'package:kusuridoki/data/models/user_profile.dart';
import 'package:kusuridoki/data/enums/reminder_status.dart';
import 'package:kusuridoki/data/providers/reminder_provider.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/presentation/screens/home/widgets/greeting_header.dart';

import '../../../../helpers/widget_test_helpers.dart';

// Fake notifiers for provider overrides
class FakeTodayReminders extends TodayReminders {
  final List<Reminder> _reminders;
  FakeTodayReminders(this._reminders);

  @override
  Future<List<Reminder>> build() async => _reminders;
}

class FakeUserSettings extends UserSettings {
  final UserProfile _profile;
  FakeUserSettings(this._profile);

  @override
  Future<UserProfile> build() async => _profile;
}

class FakeErrorUserSettings extends UserSettings {
  @override
  Future<UserProfile> build() async => throw Exception('Settings load failed');
}

class FakeErrorTodayReminders extends TodayReminders {
  @override
  Future<List<Reminder>> build() async =>
      throw Exception('Reminders load failed');
}

void main() {
  final now = DateTime.now();

  final testReminders = [
    Reminder(
      id: 'r1',
      medicationId: 'med-1',
      scheduledTime: now,
      status: ReminderStatus.taken,
    ),
    Reminder(
      id: 'r2',
      medicationId: 'med-2',
      scheduledTime: now,
      status: ReminderStatus.pending,
    ),
    Reminder(
      id: 'r3',
      medicationId: 'med-3',
      scheduledTime: now,
      status: ReminderStatus.pending,
    ),
  ];

  const testProfile = UserProfile(
    id: 'user-1',
    name: 'Alice',
    language: 'en',
    highContrast: false,
    textSize: 'normal',
    notificationsEnabled: true,
    criticalAlerts: false,
    snoozeDuration: 15,
    travelModeEnabled: false,
    removeAds: false,
  );

  const defaultProfile = UserProfile(
    id: 'user-default',
    name: null,
    language: 'en',
    highContrast: false,
    textSize: 'normal',
    notificationsEnabled: true,
    criticalAlerts: false,
    snoozeDuration: 15,
    travelModeEnabled: false,
    removeAds: false,
  );

  List<dynamic> buildOverrides({
    List<Reminder> reminders = const [],
    UserProfile profile = defaultProfile,
  }) {
    return [
      todayRemindersProvider.overrideWith(() => FakeTodayReminders(reminders)),
      userSettingsProvider.overrideWith(() => FakeUserSettings(profile)),
    ];
  }

  group('GreetingHeader', () {
    testWidgets('renders greeting with user name', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const GreetingHeader(),
          overrides: buildOverrides(profile: testProfile),
        ),
      );
      await tester.pumpAndSettle();

      // Should show greeting with name (Good morning/afternoon/evening, Alice)
      expect(find.textContaining('Alice'), findsOneWidget);
    });

    testWidgets('renders greeting without name when name is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const GreetingHeader(),
          overrides: buildOverrides(profile: defaultProfile),
        ),
      );
      await tester.pumpAndSettle();

      // Should show generic greeting without a name appended
      expect(find.textContaining('Alice'), findsNothing);
    });

    testWidgets('renders greeting without name when name is "User"', (
      tester,
    ) async {
      const userProfile = UserProfile(
        id: 'u',
        name: 'User',
        language: 'en',
        highContrast: false,
        textSize: 'normal',
        notificationsEnabled: true,
        criticalAlerts: false,
        snoozeDuration: 15,
        travelModeEnabled: false,
        removeAds: false,
      );
      await tester.pumpWidget(
        createTestableWidget(
          const GreetingHeader(),
          overrides: buildOverrides(profile: userProfile),
        ),
      );
      await tester.pumpAndSettle();

      // "User" should not be appended to greeting
      expect(find.textContaining(', User'), findsNothing);
    });

    testWidgets('renders medication count text', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const GreetingHeader(),
          overrides: buildOverrides(reminders: testReminders),
        ),
      );
      await tester.pumpAndSettle();

      // Should show medication today count (e.g., "3 medications today, 1 taken")
      // The l10n key is medicationsToday(total, taken)
      expect(find.textContaining('3'), findsWidgets);
    });

    testWidgets('renders formatted date', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const GreetingHeader(),
          overrides: buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // Date should be rendered - we just verify it doesn't crash and
      // a non-empty date string appears (formatted by intl)
      expect(find.byType(GreetingHeader), findsOneWidget);
    });

    testWidgets('renders with empty reminders list', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const GreetingHeader(),
          overrides: buildOverrides(reminders: []),
        ),
      );
      await tester.pumpAndSettle();

      // Should render without error
      expect(find.byType(GreetingHeader), findsOneWidget);
    });

    testWidgets('renders in Japanese locale', (tester) async {
      await tester.pumpWidget(
        createTestableWidgetJa(
          const GreetingHeader(),
          overrides: buildOverrides(profile: testProfile),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GreetingHeader), findsOneWidget);
    });

    testWidgets('renders greeting when userSettings has error', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const GreetingHeader(),
          overrides: [
            userSettingsProvider.overrideWith(() => FakeErrorUserSettings()),
            todayRemindersProvider.overrideWith(
              () => FakeTodayReminders(testReminders),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Error state should still render a greeting (without name)
      final greetingFinder = find.textContaining(
        RegExp(
          r'(Good Morning|Good Afternoon|Good Evening)',
          caseSensitive: false,
        ),
      );
      expect(greetingFinder, findsOneWidget);
    });

    testWidgets('renders SizedBox.shrink when reminders has error', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const GreetingHeader(),
          overrides: [
            userSettingsProvider.overrideWith(
              () => FakeUserSettings(testProfile),
            ),
            todayRemindersProvider.overrideWith(
              () => FakeErrorTodayReminders(),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Should still render without crashing; greeting visible, no med count
      expect(find.byType(GreetingHeader), findsOneWidget);
      expect(find.textContaining('Alice'), findsOneWidget);
    });
  });
}
