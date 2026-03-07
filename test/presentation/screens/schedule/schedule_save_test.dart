import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kusuridoki/data/models/reminder.dart';
import 'package:kusuridoki/data/models/schedule.dart';
import 'package:kusuridoki/data/providers/reminder_provider.dart';
import 'package:kusuridoki/data/providers/schedule_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/screens/schedule/schedule_screen.dart';

/// Tracks whether generateAndScheduleToday was called.
class _SpyTodayReminders extends TodayReminders {
  bool generateCalled = false;

  @override
  Future<List<Reminder>> build() async => [];

  @override
  Future<List<Reminder>> generateAndScheduleToday() async {
    generateCalled = true;
    return [];
  }
}

class _FailingTodayReminders extends TodayReminders {
  @override
  Future<List<Reminder>> build() async => [];

  @override
  Future<List<Reminder>> generateAndScheduleToday() async {
    throw Exception('Notification permission denied');
  }
}

class _FakeScheduleList extends ScheduleList {
  bool addCalled = false;

  @override
  Future<List<Schedule>> build() async => [];

  @override
  Future<void> addSchedule(Schedule schedule) async {
    addCalled = true;
  }
}

class _FailingScheduleList extends ScheduleList {
  @override
  Future<List<Schedule>> build() async => [];

  @override
  Future<void> addSchedule(Schedule schedule) async {
    throw Exception('Hive write failed');
  }
}

void main() {
  group('ScheduleScreen._saveSchedule', () {
    testWidgets(
      'calls generateAndScheduleToday after addSchedule',
      (tester) async {
        final spyReminders = _SpyTodayReminders();
        final fakeSchedules = _FakeScheduleList();

        final router = GoRouter(
          initialLocation: '/schedule',
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => const Scaffold(),
              routes: [
                GoRoute(
                  path: 'schedule',
                  builder: (_, _) =>
                      const ScheduleScreen(medicationId: 'med-1'),
                ),
              ],
            ),
          ],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              todayRemindersProvider.overrideWith(() => spyReminders),
              scheduleListProvider.overrideWith(() => fakeSchedules),
              medicationSchedulesProvider('med-1').overrideWith((ref) async => []),
            ],
            child: MaterialApp.router(
              routerConfig: router,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Select a dosage timing (Morning) to enable the Save button
        expect(find.text('Morning'), findsOneWidget);
        await tester.tap(find.text('Morning'));
        await tester.pumpAndSettle();

        // Tap the Continue/Save button (may be off-screen, scroll into view)
        // l10n key: continueButton -> "Continue"
        await tester.ensureVisible(find.text('Continue'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();

        // Verify addSchedule was called
        expect(fakeSchedules.addCalled, isTrue);
        // Verify generateAndScheduleToday was called
        expect(spyReminders.generateCalled, isTrue);
      },
    );

    testWidgets(
      'reminder failure does not show error snackbar and still navigates',
      (tester) async {
        final failingReminders = _FailingTodayReminders();
        final fakeSchedules = _FakeScheduleList();

        bool didPop = false;
        final router = GoRouter(
          initialLocation: '/schedule',
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => const Scaffold(),
              routes: [
                GoRoute(
                  path: 'schedule',
                  builder: (_, _) =>
                      const ScheduleScreen(medicationId: 'med-1'),
                  onExit: (context, state) {
                    didPop = true;
                    return true;
                  },
                ),
              ],
            ),
          ],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              todayRemindersProvider.overrideWith(() => failingReminders),
              scheduleListProvider.overrideWith(() => fakeSchedules),
              medicationSchedulesProvider('med-1').overrideWith((ref) async => []),
            ],
            child: MaterialApp.router(
              routerConfig: router,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Select a dosage timing to enable Save
        await tester.tap(find.text('Morning'));
        await tester.pumpAndSettle();

        // Tap Continue
        await tester.ensureVisible(find.text('Continue'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();

        // Schedule was saved
        expect(fakeSchedules.addCalled, isTrue);
        // Navigation happened despite reminder failure
        expect(didPop, isTrue);
        // No error snackbar shown
        expect(
          find.text('Failed to save schedule. Please try again.'),
          findsNothing,
        );
      },
    );

    testWidgets(
      'addSchedule failure shows error snackbar and does not navigate',
      (tester) async {
        final spyReminders = _SpyTodayReminders();
        final failingSchedules = _FailingScheduleList();

        bool didPop = false;
        final router = GoRouter(
          initialLocation: '/schedule',
          routes: [
            GoRoute(
              path: '/',
              builder: (_, _) => const Scaffold(),
              routes: [
                GoRoute(
                  path: 'schedule',
                  builder: (_, _) =>
                      const ScheduleScreen(medicationId: 'med-1'),
                  onExit: (context, state) {
                    didPop = true;
                    return true;
                  },
                ),
              ],
            ),
          ],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              todayRemindersProvider.overrideWith(() => spyReminders),
              scheduleListProvider.overrideWith(() => failingSchedules),
              medicationSchedulesProvider('med-1').overrideWith((ref) async => []),
            ],
            child: MaterialApp.router(
              routerConfig: router,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Select a dosage timing to enable Save
        await tester.tap(find.text('Morning'));
        await tester.pumpAndSettle();

        // Tap Continue
        await tester.ensureVisible(find.text('Continue'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();

        // Did NOT navigate
        expect(didPop, isFalse);
        // Error snackbar shown
        expect(
          find.text('Failed to save schedule. Please try again.'),
          findsOneWidget,
        );
        // Reminder generation was never attempted
        expect(spyReminders.generateCalled, isFalse);
      },
    );
  });
}
