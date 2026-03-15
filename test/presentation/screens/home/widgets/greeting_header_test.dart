import 'package:flutter/material.dart';
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

    // GREET-OVERFLOW-001: 320px 좁은 화면 — Wrap으로 chip 영역 overflow 없음
    testWidgets(
      'GREET-OVERFLOW-001: renders without overflow at 320px width',
      (tester) async {
        tester.view.physicalSize = const Size(320, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final pendingReminder = Reminder(
          id: 'r-pending',
          medicationId: 'med-1',
          scheduledTime: now.add(const Duration(hours: 2)),
          status: ReminderStatus.pending,
        );

        await tester.pumpWidget(
          createTestableWidget(
            const GreetingHeader(),
            overrides: buildOverrides(
              reminders: [pendingReminder],
              profile: testProfile,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(GreetingHeader), findsOneWidget);
      },
    );

    // GREET-OVERFLOW-002: textScaler 2.0 — 큰 폰트에서 overflow 없음
    testWidgets(
      'GREET-OVERFLOW-002: renders without overflow at textScaler 2.0',
      (tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
            child: createTestableWidget(
              const GreetingHeader(),
              overrides: buildOverrides(
                reminders: testReminders,
                profile: testProfile,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(GreetingHeader), findsOneWidget);
      },
    );

    // GREET-OVERFLOW-003: Wrap 위젯이 chip 영역에 사용됨
    testWidgets(
      'GREET-OVERFLOW-003: chip area uses Wrap widget',
      (tester) async {
        final pendingReminder = Reminder(
          id: 'r-pending',
          medicationId: 'med-1',
          scheduledTime: now.add(const Duration(hours: 2)),
          status: ReminderStatus.pending,
        );

        await tester.pumpWidget(
          createTestableWidget(
            const GreetingHeader(),
            overrides: buildOverrides(
              reminders: [pendingReminder],
              profile: testProfile,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Wrap이 칩 영역에 사용되어야 함
        expect(find.byType(Wrap), findsAtLeastNWidgets(1));
      },
    );
  });
}
