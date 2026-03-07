import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kusuridoki/data/enums/schedule_type.dart';
import 'package:kusuridoki/data/enums/timezone_mode.dart';
import 'package:kusuridoki/data/models/reminder.dart';
import 'package:kusuridoki/data/models/schedule.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/data/providers/reminder_provider.dart';
import 'package:kusuridoki/data/providers/schedule_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/presentation/screens/schedule/schedule_screen.dart';

// ─── Fakes ───────────────────────────────────────────────────────────────────

class _FakeScheduleList extends ScheduleList {
  bool addCalled = false;

  @override
  Future<List<Schedule>> build() async => [];

  @override
  Future<void> addSchedule(Schedule schedule) async {
    addCalled = true;
  }
}

class _FakeTodayReminders extends TodayReminders {
  @override
  Future<List<Reminder>> build() async => [];

  @override
  Future<List<Reminder>> generateAndScheduleToday() async => [];
}

class _SpyMedicationList extends MedicationList {
  bool deleteCalled = false;
  String? deletedId;

  @override
  Future<List<Medication>> build() async => [];

  @override
  Future<void> deleteMedication(String id) async {
    deleteCalled = true;
    deletedId = id;
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

/// Wraps ScheduleScreen in a GoRouter so context.pop() and navigation work.
Widget _buildScheduleWidget(
  ScheduleScreen screen, {
  required List<dynamic> overrides,
}) {
  final router = GoRouter(
    initialLocation: '/schedule',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(body: Text('home')),
        routes: [
          GoRoute(
            path: 'schedule',
            builder: (_, _) => screen,
          ),
        ],
      ),
    ],
  );

  return ProviderScope(
    overrides: overrides.cast(),
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
  );
}

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  group('ScheduleScreen — validation', () {
    // SCHED-ERROR-001: no timing selected → validation SnackBar, no save.
    testWidgets('shows SnackBar when no timing selected on save', (
      tester,
    ) async {
      final fakeSchedules = _FakeScheduleList();

      await tester.pumpWidget(
        _buildScheduleWidget(
          const ScheduleScreen(medicationId: 'med-1'),
          overrides: [
            scheduleListProvider.overrideWith(() => fakeSchedules),
            todayRemindersProvider.overrideWith(() => _FakeTodayReminders()),
            medicationSchedulesProvider(
              'med-1',
            ).overrideWith((ref) async => []),
            medicationListProvider.overrideWith(() => _SpyMedicationList()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // No timing chip selected — tap Continue directly.
      await tester.ensureVisible(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Validation SnackBar appears.
      // l10n: pleaseSelectAtLeastOneTiming -> "Please select at least one timing"
      expect(
        find.text('Please select at least one timing'),
        findsOneWidget,
      );

      // addSchedule was NOT called.
      expect(fakeSchedules.addCalled, isFalse);
    });

    // SCHED-ERROR-002: specificDays frequency, no days selected → validation SnackBar.
    testWidgets('shows SnackBar when specificDays selected but no days chosen',
        (tester) async {
      final fakeSchedules = _FakeScheduleList();

      // Provide a schedule pre-set to specificDays so the UI starts there.
      await tester.pumpWidget(
        _buildScheduleWidget(
          const ScheduleScreen(medicationId: 'med-2'),
          overrides: [
            scheduleListProvider.overrideWith(() => fakeSchedules),
            todayRemindersProvider.overrideWith(() => _FakeTodayReminders()),
            medicationSchedulesProvider('med-2').overrideWith(
              (ref) async => [
                Schedule(
                  id: 'sched-1',
                  medicationId: 'med-2',
                  type: ScheduleType.specificDays,
                  dosageSlots: [],
                  specificDays: [], // no days
                  timezoneMode: TimezoneMode.fixedInterval,
                  isActive: true,
                ),
              ],
            ),
            medicationListProvider.overrideWith(() => _SpyMedicationList()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Select Morning to pass the "no timing" validation.
      await tester.tap(find.text('Morning'));
      await tester.pumpAndSettle();

      // Tap Continue — should fail on "no days" validation.
      await tester.ensureVisible(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // l10n: pleaseSelectAtLeastOneDay -> "Please select at least one day"
      expect(find.text('Please select at least one day'), findsOneWidget);
      expect(fakeSchedules.addCalled, isFalse);
    });
  });

  group('ScheduleScreen — isInitialSetup back navigation', () {
    // REG-UX-002: isInitialSetup=true → back triggers confirm dialog.
    testWidgets('back press shows confirm dialog when isInitialSetup is true',
        (tester) async {
      final spyMedicationList = _SpyMedicationList();

      await tester.pumpWidget(
        _buildScheduleWidget(
          const ScheduleScreen(medicationId: 'med-3', isInitialSetup: true),
          overrides: [
            scheduleListProvider.overrideWith(() => _FakeScheduleList()),
            todayRemindersProvider.overrideWith(() => _FakeTodayReminders()),
            medicationSchedulesProvider(
              'med-3',
            ).overrideWith((ref) async => []),
            medicationListProvider.overrideWith(() => spyMedicationList),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Trigger PopScope by simulating system back.
      final NavigatorState navigator = tester.state(find.byType(Navigator).first);
      navigator.maybePop();
      await tester.pumpAndSettle();

      // Confirm dialog must appear.
      // l10n: cancelScheduleSetupTitle -> "Cancel Schedule Setup"
      expect(find.text('Cancel Schedule Setup'), findsOneWidget);
      // deleteMedication not yet called (user has not confirmed).
      expect(spyMedicationList.deleteCalled, isFalse);
    });

    // REG-UX-002: confirm in dialog → deleteMedication called.
    testWidgets('confirming cancel dialog calls deleteMedication', (
      tester,
    ) async {
      final spyMedicationList = _SpyMedicationList();

      final router = GoRouter(
        initialLocation: '/schedule',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const Scaffold(body: Text('home')),
            routes: [
              GoRoute(
                path: 'schedule',
                builder: (_, _) => const ScheduleScreen(
                  medicationId: 'med-3',
                  isInitialSetup: true,
                ),
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: (<dynamic>[
            scheduleListProvider.overrideWith(() => _FakeScheduleList()),
            todayRemindersProvider.overrideWith(() => _FakeTodayReminders()),
            medicationSchedulesProvider(
              'med-3',
            ).overrideWith((ref) async => []),
            medicationListProvider.overrideWith(() => spyMedicationList),
          ]).cast(),
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

      // Trigger back gesture to open dialog.
      final NavigatorState navigator =
          tester.state(find.byType(Navigator).first);
      navigator.maybePop();
      await tester.pumpAndSettle();

      // Tap the Confirm button.
      // l10n: confirm -> "Confirm"
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      expect(spyMedicationList.deleteCalled, isTrue);
      expect(spyMedicationList.deletedId, equals('med-3'));
    });
  });
}
