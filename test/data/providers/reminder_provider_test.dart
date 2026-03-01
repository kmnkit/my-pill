import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_local_notifications_platform_interface/flutter_local_notifications_platform_interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kusuridoki/data/enums/dosage_unit.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/data/enums/reminder_status.dart';
import 'package:kusuridoki/data/enums/dosage_timing.dart';
import 'package:kusuridoki/data/enums/schedule_type.dart';
import 'package:kusuridoki/data/models/dosage_time_slot.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/data/models/reminder.dart';
import 'package:kusuridoki/data/models/schedule.dart';
import 'package:kusuridoki/data/providers/reminder_provider.dart';
import 'package:kusuridoki/data/providers/storage_service_provider.dart';
import 'package:kusuridoki/data/services/storage_service.dart';

import '../../mock_firebase.dart';

@GenerateMocks([StorageService])
import 'reminder_provider_test.mocks.dart';

/// No-op stub for [FlutterLocalNotificationsPlatform] so unit tests
/// don't require a real notification platform.
class _StubLocalNotificationsPlatform
    extends FlutterLocalNotificationsPlatform {
  @override
  Future<void> cancel({required int id}) async {}
  @override
  Future<void> cancelAll() async {}
  @override
  Future<void> cancelAllPendingNotifications() async {}
  @override
  Future<List<PendingNotificationRequest>>
  pendingNotificationRequests() async => [];
  @override
  Future<List<ActiveNotification>> getActiveNotifications() async => [];
}

/// Intercept all platform channels used by [NotificationService] and
/// [FirebaseMessaging] so that unit tests do not require a real device or
/// Firebase initialisation.  Every method call returns a minimal success
/// response.
void _stubNotificationChannels() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseAuthMocks();
  tz.initializeTimeZones();
  // Use macOS target so zonedSchedule's Android branch (with !) is not taken.
  // The macOS branch uses ?. so a non-MacOS stub results in a safe no-op.
  debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
  addTearDown(() => debugDefaultTargetPlatformOverride = null);
  FlutterLocalNotificationsPlatform.instance =
      _StubLocalNotificationsPlatform();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  // flutter_local_notifications channel
  messenger.setMockMethodCallHandler(
    const MethodChannel('dexterous.com/flutter/local_notifications'),
    (call) async => null,
  );

  // firebase_messaging channel
  messenger.setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/firebase_messaging'),
    (call) async {
      if (call.method == 'Messaging#getToken') {
        return {'token': 'test-token'};
      }
      if (call.method == 'Messaging#getNotificationSettings') {
        return {
          'authorizationStatus': 1, // authorized
          'alert': 1,
          'badge': 1,
          'sound': 1,
          'carPlay': 1,
          'lockScreen': 1,
          'notificationCenter': 1,
          'showPreviews': 1,
          'timeSensitive': 1,
          'criticalAlert': 1,
          'announcement': 1,
        };
      }
      return null;
    },
  );

  // firebase_core channel
  messenger.setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/firebase_core'),
    (call) async {
      if (call.method == 'Firebase#initializeCore') {
        return [
          {
            'name': '[DEFAULT]',
            'options': {
              'apiKey': 'test',
              'appId': 'test',
              'messagingSenderId': 'test',
              'projectId': 'test',
            },
            'pluginConstants': <String, dynamic>{},
          },
        ];
      }
      if (call.method == 'Firebase#initializeApp') {
        return {
          'name': '[DEFAULT]',
          'options': {
            'apiKey': 'test',
            'appId': 'test',
            'messagingSenderId': 'test',
            'projectId': 'test',
          },
          'pluginConstants': <String, dynamic>{},
        };
      }
      return null;
    },
  );
}

Reminder _makeReminder({
  required String id,
  required String medicationId,
  ReminderStatus status = ReminderStatus.pending,
  DateTime? scheduledTime,
  DateTime? snoozedUntil,
}) => Reminder(
  id: id,
  medicationId: medicationId,
  scheduledTime: scheduledTime ?? DateTime.now(),
  status: status,
  snoozedUntil: snoozedUntil,
);

Medication _makeMedication(String id, String name) => Medication(
  id: id,
  name: name,
  dosage: 100,
  dosageUnit: DosageUnit.mg,
  shape: PillShape.round,
  color: PillColor.white,
  createdAt: DateTime(2024, 1, 1),
);

Schedule _makeSchedule({
  required String id,
  required String medicationId,
  ScheduleType type = ScheduleType.daily,
  List<String> times = const ['08:00'],
  bool isActive = true,
  List<int> specificDays = const [],
  int? intervalHours,
}) => Schedule(
  id: id,
  medicationId: medicationId,
  type: type,
  dosageSlots: times
      .map((t) => DosageTimeSlot(timing: DosageTiming.morning, time: t))
      .toList(),
  isActive: isActive,
  specificDays: specificDays,
  intervalHours: intervalHours,
);

void main() {
  late MockStorageService mockStorage;

  setUp(() {
    mockStorage = MockStorageService();
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [storageServiceProvider.overrideWithValue(mockStorage)],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('TodayReminders provider — build', () {
    test('returns empty list when no reminders for today', () async {
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);

      final container = makeContainer();
      final result = await container.read(todayRemindersProvider.future);

      expect(result, isEmpty);
    });

    test('returns list of reminders from storage for today', () async {
      final reminders = [
        _makeReminder(id: 'r1', medicationId: 'med-1'),
        _makeReminder(id: 'r2', medicationId: 'med-2'),
      ];
      when(
        mockStorage.getRemindersForDate(any),
      ).thenAnswer((_) async => reminders);

      final container = makeContainer();
      final result = await container.read(todayRemindersProvider.future);

      expect(result.length, equals(2));
      expect(result[0].id, equals('r1'));
      expect(result[1].id, equals('r2'));
    });

    test('returns reminders with correct statuses', () async {
      final reminders = [
        _makeReminder(
          id: 'r1',
          medicationId: 'med-1',
          status: ReminderStatus.pending,
        ),
        _makeReminder(
          id: 'r2',
          medicationId: 'med-1',
          status: ReminderStatus.taken,
        ),
        _makeReminder(
          id: 'r3',
          medicationId: 'med-1',
          status: ReminderStatus.missed,
        ),
      ];
      when(
        mockStorage.getRemindersForDate(any),
      ).thenAnswer((_) async => reminders);

      final container = makeContainer();
      final result = await container.read(todayRemindersProvider.future);

      expect(result.length, equals(3));
      expect(
        result.where((r) => r.status == ReminderStatus.pending).length,
        equals(1),
      );
      expect(
        result.where((r) => r.status == ReminderStatus.taken).length,
        equals(1),
      );
      expect(
        result.where((r) => r.status == ReminderStatus.missed).length,
        equals(1),
      );
    });

    test('provider state is AsyncData after build', () async {
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);

      final container = makeContainer();
      await container.read(todayRemindersProvider.future);

      final state = container.read(todayRemindersProvider);
      expect(state, isA<AsyncData<List<Reminder>>>());
    });

    test('provider state is AsyncLoading before build completes', () async {
      // Use a completer so we can observe the loading state before resolution
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);

      final container = makeContainer();
      // Read synchronously — provider hasn't resolved yet
      final state = container.read(todayRemindersProvider);
      expect(state, isA<AsyncLoading<List<Reminder>>>());
    });

    test('propagates storage error as AsyncError', () async {
      when(
        mockStorage.getRemindersForDate(any),
      ).thenAnswer((_) async => throw Exception('storage failure'));

      final container = makeContainer();

      // Use .future which completes with an error (may be the original
      // Exception or a StateError from Riverpod disposal).
      Object? caughtError;
      try {
        await container.read(todayRemindersProvider.future);
      } catch (e) {
        caughtError = e;
      }

      expect(caughtError, isNotNull);
    });

    test('passes a DateTime argument to getRemindersForDate', () async {
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);

      final container = makeContainer();
      await container.read(todayRemindersProvider.future);

      final captured = verify(
        mockStorage.getRemindersForDate(captureAny),
      ).captured;
      expect(captured.length, equals(1));
      expect(captured.first, isA<DateTime>());
    });

    test('returns single reminder preserving all fields', () async {
      final scheduled = DateTime(2024, 6, 15, 8, 0);
      final snoozed = DateTime(2024, 6, 15, 8, 15);
      final reminder = _makeReminder(
        id: 'r-full',
        medicationId: 'med-full',
        status: ReminderStatus.snoozed,
        scheduledTime: scheduled,
        snoozedUntil: snoozed,
      );
      when(
        mockStorage.getRemindersForDate(any),
      ).thenAnswer((_) async => [reminder]);

      final container = makeContainer();
      final result = await container.read(todayRemindersProvider.future);

      expect(result.length, equals(1));
      final r = result.first;
      expect(r.id, equals('r-full'));
      expect(r.medicationId, equals('med-full'));
      expect(r.status, equals(ReminderStatus.snoozed));
      expect(r.scheduledTime, equals(scheduled));
      expect(r.snoozedUntil, equals(snoozed));
    });

    test('returns skipped reminder correctly', () async {
      final reminder = _makeReminder(
        id: 'r-skip',
        medicationId: 'med-1',
        status: ReminderStatus.skipped,
      );
      when(
        mockStorage.getRemindersForDate(any),
      ).thenAnswer((_) async => [reminder]);

      final container = makeContainer();
      final result = await container.read(todayRemindersProvider.future);

      expect(result.length, equals(1));
      expect(result.first.status, equals(ReminderStatus.skipped));
    });
  });

  group('TodayReminders provider — markAsTaken', () {
    test('calls storage methods and rethrows on storage error', () async {
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      // getReminder returns null → ReminderService throws 'Reminder not found'
      when(mockStorage.getReminder(any)).thenAnswer((_) async => null);

      final container = makeContainer();
      await container.read(todayRemindersProvider.future);

      expect(
        () => container.read(todayRemindersProvider.notifier).markAsTaken('r1'),
        throwsA(isA<Exception>()),
      );
    });

    test('calls getReminder with the exact reminder id', () async {
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(
        mockStorage.getReminder('specific-id'),
      ).thenAnswer((_) async => null);

      final container = makeContainer();
      await container.read(todayRemindersProvider.future);

      // Fire and ignore the exception — we only care that the right id was used
      container
          .read(todayRemindersProvider.notifier)
          .markAsTaken('specific-id')
          .ignore();

      await Future<void>.delayed(Duration.zero);
      verify(mockStorage.getReminder('specific-id')).called(1);
    });

    test('error message contains reminder not found when id missing', () async {
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.getReminder(any)).thenAnswer((_) async => null);

      final container = makeContainer();
      await container.read(todayRemindersProvider.future);

      await expectLater(
        container.read(todayRemindersProvider.notifier).markAsTaken('missing'),
        throwsA(
          predicate<Exception>(
            (e) => e.toString().contains('Reminder not found'),
          ),
        ),
      );
    });

    // Note: markAsTaken success path requires NotificationService (Firebase)
    // and is covered in integration tests.
  });

  group('TodayReminders provider — markAsSkipped', () {
    // Note: markAsSkipped success path requires NotificationService (Firebase)
    // and is covered in integration tests.

    test('rethrows when reminder not found in storage', () async {
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(
        mockStorage.getReminder('non-existent'),
      ).thenAnswer((_) async => null);

      final container = makeContainer();
      await container.read(todayRemindersProvider.future);

      expect(
        () => container
            .read(todayRemindersProvider.notifier)
            .markAsSkipped('non-existent'),
        throwsA(isA<Exception>()),
      );
    });

    test('calls getReminder with the exact reminder id', () async {
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.getReminder('skip-id')).thenAnswer((_) async => null);

      final container = makeContainer();
      await container.read(todayRemindersProvider.future);

      container
          .read(todayRemindersProvider.notifier)
          .markAsSkipped('skip-id')
          .ignore();

      await Future<void>.delayed(Duration.zero);
      verify(mockStorage.getReminder('skip-id')).called(1);
    });

    test('error message contains reminder not found when id missing', () async {
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.getReminder(any)).thenAnswer((_) async => null);

      final container = makeContainer();
      await container.read(todayRemindersProvider.future);

      await expectLater(
        container
            .read(todayRemindersProvider.notifier)
            .markAsSkipped('missing'),
        throwsA(
          predicate<Exception>(
            (e) => e.toString().contains('Reminder not found'),
          ),
        ),
      );
    });
  });

  group('TodayReminders provider — snooze', () {
    test('rethrows when reminder not found during snooze', () async {
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(
        mockStorage.getReminder('non-existent'),
      ).thenAnswer((_) async => null);

      final container = makeContainer();
      await container.read(todayRemindersProvider.future);

      expect(
        () => container
            .read(todayRemindersProvider.notifier)
            .snooze('non-existent', const Duration(minutes: 15)),
        throwsA(isA<Exception>()),
      );
    });

    test(
      'calls getReminder with the exact reminder id when snoozing',
      () async {
        when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
        when(
          mockStorage.getReminder('snooze-id'),
        ).thenAnswer((_) async => null);

        final container = makeContainer();
        await container.read(todayRemindersProvider.future);

        container
            .read(todayRemindersProvider.notifier)
            .snooze('snooze-id', const Duration(minutes: 10))
            .ignore();

        await Future<void>.delayed(Duration.zero);
        verify(mockStorage.getReminder('snooze-id')).called(1);
      },
    );

    test(
      'error message contains reminder not found when snoozing missing id',
      () async {
        when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
        when(mockStorage.getReminder(any)).thenAnswer((_) async => null);

        final container = makeContainer();
        await container.read(todayRemindersProvider.future);

        await expectLater(
          container
              .read(todayRemindersProvider.notifier)
              .snooze('missing', const Duration(minutes: 5)),
          throwsA(
            predicate<Exception>(
              (e) => e.toString().contains('Reminder not found'),
            ),
          ),
        );
      },
    );

    test('rethrows with different durations when reminder missing', () async {
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.getReminder(any)).thenAnswer((_) async => null);

      final container = makeContainer();
      await container.read(todayRemindersProvider.future);
      final notifier = container.read(todayRemindersProvider.notifier);

      for (final duration in [
        const Duration(minutes: 5),
        const Duration(minutes: 30),
        const Duration(hours: 1),
      ]) {
        await expectLater(
          notifier.snooze('r-missing', duration),
          throwsA(isA<Exception>()),
        );
      }
    });

    // Note: snooze success path tests require NotificationService (Firebase)
    // and are covered in integration tests.
  });

  group('TodayReminders provider — generateAndScheduleToday', () {
    // NOTE: generateAndScheduleToday always calls
    // NotificationService().scheduleTodayReminders() after fetching schedules
    // and medications, regardless of whether there are pending reminders.
    // NotificationService requires Firebase.initializeApp() which is not
    // available in unit tests.
    //
    // The only Firebase-free path is when the method throws BEFORE reaching
    // NotificationService — i.e., when scheduleListProvider itself throws.
    // All other paths (empty schedules, inactive schedules, existing reminders)
    // still reach NotificationService and must be covered in integration tests.

    test('rethrows when scheduleListProvider throws during build', () async {
      // build() for todayRemindersProvider
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      // scheduleListProvider (used via ref.read inside generateAndScheduleToday)
      // reads getAllSchedules() — make it throw so we bail before NotificationService
      when(
        mockStorage.getAllSchedules(),
      ).thenThrow(Exception('schedules storage error'));

      final container = makeContainer();

      // Keep todayRemindersProvider alive with a listener so it isn't disposed
      // mid-flight when we call generateAndScheduleToday.
      container.listen<AsyncValue<List<Reminder>>>(
        todayRemindersProvider,
        (_, _) {},
        fireImmediately: true,
      );
      await container.read(todayRemindersProvider.future);

      // Riverpod may throw StateError when scheduleListProvider is disposed
      // during loading state, or the original Exception — both are valid errors.
      await expectLater(
        container
            .read(todayRemindersProvider.notifier)
            .generateAndScheduleToday(),
        throwsA(anything),
      );
    });

    test('error from scheduleListProvider propagates an error', () async {
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(
        mockStorage.getAllSchedules(),
      ).thenThrow(Exception('db read failed'));

      final container = makeContainer();
      container.listen<AsyncValue<List<Reminder>>>(
        todayRemindersProvider,
        (_, _) {},
        fireImmediately: true,
      );
      await container.read(todayRemindersProvider.future);

      // Riverpod may throw StateError (provider disposed during loading)
      // or the original Exception — either way, an error is thrown.
      await expectLater(
        container
            .read(todayRemindersProvider.notifier)
            .generateAndScheduleToday(),
        throwsA(anything),
      );
    });

    // Success paths (empty schedules, inactive schedules, existing reminders)
    // all reach NotificationService().scheduleTodayReminders() which requires
    // Firebase. They are covered in integration_test/.
  });

  group('TodayReminders provider — refresh', () {
    test('build can be re-read after data changes', () async {
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);

      final container = makeContainer();
      final result1 = await container.read(todayRemindersProvider.future);
      expect(result1, isEmpty);

      // Simulate data change
      final reminders = [_makeReminder(id: 'r1', medicationId: 'med-1')];
      when(
        mockStorage.getRemindersForDate(any),
      ).thenAnswer((_) async => reminders);

      container.invalidate(todayRemindersProvider);
      final result2 = await container.read(todayRemindersProvider.future);
      expect(result2, hasLength(1));
    });

    test('build fetches reminders for current date', () async {
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);

      final container = makeContainer();
      await container.read(todayRemindersProvider.future);

      // Verify storage was called with a DateTime (today)
      verify(mockStorage.getRemindersForDate(any)).called(1);
    });

    test('second invalidate triggers a second storage call', () async {
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);

      final container = makeContainer();
      await container.read(todayRemindersProvider.future);

      container.invalidate(todayRemindersProvider);
      await container.read(todayRemindersProvider.future);

      verify(mockStorage.getRemindersForDate(any)).called(2);
    });

    test('state returns to AsyncData after invalidation and re-read', () async {
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);

      final container = makeContainer();
      await container.read(todayRemindersProvider.future);

      container.invalidate(todayRemindersProvider);
      await container.read(todayRemindersProvider.future);

      expect(
        container.read(todayRemindersProvider),
        isA<AsyncData<List<Reminder>>>(),
      );
    });
  });

  group('TodayReminders provider — provider type', () {
    test('provider is accessible and non-null', () {
      // Verify the provider exists (code-gen type is not directly AsyncNotifierProvider)
      expect(todayRemindersProvider, isNotNull);
    });

    test('notifier is TodayReminders type', () async {
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);

      final container = makeContainer();
      await container.read(todayRemindersProvider.future);

      final notifier = container.read(todayRemindersProvider.notifier);
      expect(notifier, isA<TodayReminders>());
    });

    test('two containers with same override are independent', () async {
      final reminders1 = [_makeReminder(id: 'r1', medicationId: 'med-1')];
      final reminders2 = [
        _makeReminder(id: 'r2', medicationId: 'med-2'),
        _makeReminder(id: 'r3', medicationId: 'med-2'),
      ];

      final mock1 = MockStorageService();
      when(mock1.getRemindersForDate(any)).thenAnswer((_) async => reminders1);

      final mock2 = MockStorageService();
      when(mock2.getRemindersForDate(any)).thenAnswer((_) async => reminders2);

      final c1 = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(mock1)],
      );
      final c2 = ProviderContainer(
        overrides: [storageServiceProvider.overrideWithValue(mock2)],
      );
      addTearDown(c1.dispose);
      addTearDown(c2.dispose);

      final res1 = await c1.read(todayRemindersProvider.future);
      final res2 = await c2.read(todayRemindersProvider.future);

      expect(res1, hasLength(1));
      expect(res2, hasLength(2));
    });
  });

  // ---------------------------------------------------------------------------
  // Success-path tests that exercise lines covered by NotificationService calls.
  // These tests intercept all platform channels so no Firebase / device needed.
  // ---------------------------------------------------------------------------

  group('TodayReminders provider — markAsTaken success path', () {
    setUp(_stubNotificationChannels);

    test('completes without throwing when reminder exists', () async {
      final reminder = _makeReminder(id: 'r-take', medicationId: 'med-1');

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.getReminder('r-take')).thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});
      when(mockStorage.saveAdherenceRecord(any)).thenAnswer((_) async {});

      final container = makeContainer();
      // Keep provider alive so invalidateSelf() (line 33) runs cleanly.
      container.listen<AsyncValue<List<Reminder>>>(
        todayRemindersProvider,
        (_, _) {},
        fireImmediately: true,
      );
      await container.read(todayRemindersProvider.future);

      // Should complete without error — covers lines 30 and 33.
      await expectLater(
        container.read(todayRemindersProvider.notifier).markAsTaken('r-take'),
        completes,
      );
    });

    test('saves reminder with taken status', () async {
      final reminder = _makeReminder(id: 'r-take2', medicationId: 'med-2');

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(
        mockStorage.getReminder('r-take2'),
      ).thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});
      when(mockStorage.saveAdherenceRecord(any)).thenAnswer((_) async {});

      final container = makeContainer();
      container.listen<AsyncValue<List<Reminder>>>(
        todayRemindersProvider,
        (_, _) {},
        fireImmediately: true,
      );
      await container.read(todayRemindersProvider.future);

      await container
          .read(todayRemindersProvider.notifier)
          .markAsTaken('r-take2');

      // Verify saveReminder was called (ReminderService updates status to taken).
      verify(mockStorage.saveReminder(any)).called(greaterThanOrEqualTo(1));
    });

    test('creates adherence record on success', () async {
      final reminder = _makeReminder(id: 'r-take3', medicationId: 'med-3');

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(
        mockStorage.getReminder('r-take3'),
      ).thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});
      when(mockStorage.saveAdherenceRecord(any)).thenAnswer((_) async {});

      final container = makeContainer();
      container.listen<AsyncValue<List<Reminder>>>(
        todayRemindersProvider,
        (_, _) {},
        fireImmediately: true,
      );
      await container.read(todayRemindersProvider.future);

      await container
          .read(todayRemindersProvider.notifier)
          .markAsTaken('r-take3');

      verify(mockStorage.saveAdherenceRecord(any)).called(1);
    });
  });

  group('TodayReminders provider — markAsSkipped success path', () {
    setUp(_stubNotificationChannels);

    test('completes without throwing when reminder exists', () async {
      final reminder = _makeReminder(id: 'r-skip2', medicationId: 'med-1');

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(
        mockStorage.getReminder('r-skip2'),
      ).thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});
      when(mockStorage.saveAdherenceRecord(any)).thenAnswer((_) async {});

      final container = makeContainer();
      container.listen<AsyncValue<List<Reminder>>>(
        todayRemindersProvider,
        (_, _) {},
        fireImmediately: true,
      );
      await container.read(todayRemindersProvider.future);

      // Covers lines 49 (cancelReminder) and 52 (ref.invalidateSelf).
      await expectLater(
        container
            .read(todayRemindersProvider.notifier)
            .markAsSkipped('r-skip2'),
        completes,
      );
    });

    test('saves reminder with skipped status', () async {
      final reminder = _makeReminder(id: 'r-skip3', medicationId: 'med-2');

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(
        mockStorage.getReminder('r-skip3'),
      ).thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});
      when(mockStorage.saveAdherenceRecord(any)).thenAnswer((_) async {});

      final container = makeContainer();
      container.listen<AsyncValue<List<Reminder>>>(
        todayRemindersProvider,
        (_, _) {},
        fireImmediately: true,
      );
      await container.read(todayRemindersProvider.future);

      await container
          .read(todayRemindersProvider.notifier)
          .markAsSkipped('r-skip3');

      verify(mockStorage.saveReminder(any)).called(greaterThanOrEqualTo(1));
    });

    test('creates adherence record on success', () async {
      final reminder = _makeReminder(id: 'r-skip4', medicationId: 'med-3');

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(
        mockStorage.getReminder('r-skip4'),
      ).thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});
      when(mockStorage.saveAdherenceRecord(any)).thenAnswer((_) async {});

      final container = makeContainer();
      container.listen<AsyncValue<List<Reminder>>>(
        todayRemindersProvider,
        (_, _) {},
        fireImmediately: true,
      );
      await container.read(todayRemindersProvider.future);

      await container
          .read(todayRemindersProvider.notifier)
          .markAsSkipped('r-skip4');

      verify(mockStorage.saveAdherenceRecord(any)).called(1);
    });
  });

  group('TodayReminders provider — snooze success path', () {
    setUp(_stubNotificationChannels);

    test('completes when reminder found and medication is null', () async {
      // medication == null → skips scheduleReminder, hits line 86 (invalidateSelf)
      final reminder = _makeReminder(
        id: 'r-snooze1',
        medicationId: 'med-no-med',
        scheduledTime: DateTime.now().add(const Duration(hours: 1)),
      );

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(
        mockStorage.getReminder('r-snooze1'),
      ).thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});
      when(
        mockStorage.getMedication('med-no-med'),
      ).thenAnswer((_) async => null);

      final container = makeContainer();
      container.listen<AsyncValue<List<Reminder>>>(
        todayRemindersProvider,
        (_, _) {},
        fireImmediately: true,
      );
      await container.read(todayRemindersProvider.future);

      // Covers lines 68 (cancelReminder), 71 (getMedication → null),
      // and 86 (ref.invalidateSelf) via the medication == null branch.
      await expectLater(
        container
            .read(todayRemindersProvider.notifier)
            .snooze('r-snooze1', const Duration(minutes: 15)),
        completes,
      );
    });

    test('completes when reminder found and medication exists', () async {
      // medication != null → hits lines 74, 75, 78, 80, 81, 86
      final snoozedUntil = DateTime.now().add(const Duration(minutes: 15));
      final reminder = _makeReminder(
        id: 'r-snooze2',
        medicationId: 'med-exists',
        // scheduledTime in the past — scheduleReminder short-circuits early
        // (isBefore(now) check in NotificationService.scheduleReminder)
        scheduledTime: DateTime.now().subtract(const Duration(hours: 1)),
        snoozedUntil: snoozedUntil,
      );
      final medication = _makeMedication('med-exists', 'Aspirin');

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(
        mockStorage.getReminder('r-snooze2'),
      ).thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});
      when(
        mockStorage.getMedication('med-exists'),
      ).thenAnswer((_) async => medication);

      final container = makeContainer();
      container.listen<AsyncValue<List<Reminder>>>(
        todayRemindersProvider,
        (_, _) {},
        fireImmediately: true,
      );
      await container.read(todayRemindersProvider.future);

      // Covers lines 71 (getMedication), 74 (snoozedReminder copyWith),
      // 75 (snoozedUntil ?? fallback), 78–81 (scheduleReminder call), 86.
      await expectLater(
        container
            .read(todayRemindersProvider.notifier)
            .snooze('r-snooze2', const Duration(minutes: 15)),
        completes,
      );
    });

    test('saves reminder with snoozed status', () async {
      final reminder = _makeReminder(
        id: 'r-snooze3',
        medicationId: 'med-snooze',
      );

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(
        mockStorage.getReminder('r-snooze3'),
      ).thenAnswer((_) async => reminder);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});
      when(
        mockStorage.getMedication('med-snooze'),
      ).thenAnswer((_) async => null);

      final container = makeContainer();
      container.listen<AsyncValue<List<Reminder>>>(
        todayRemindersProvider,
        (_, _) {},
        fireImmediately: true,
      );
      await container.read(todayRemindersProvider.future);

      await container
          .read(todayRemindersProvider.notifier)
          .snooze('r-snooze3', const Duration(minutes: 10));

      verify(mockStorage.saveReminder(any)).called(greaterThanOrEqualTo(1));
    });
  });

  group('TodayReminders provider — generateAndScheduleToday success path', () {
    setUp(_stubNotificationChannels);

    test('completes with empty list when no active schedules', () async {
      // Covers interior lines: 100 (schedules), 102 (activeSchedules),
      // 105 (generateRemindersForDate), 109 (ref.mounted check),
      // 112 (medications), 113 (ref.mounted check),
      // 114 (medicationInfo map), 125–127 (pendingReminders),
      // 129 (scheduleTodayReminders), 133 (ref.mounted), 136 (invalidateSelf).
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.getAllSchedules()).thenAnswer((_) async => []);
      when(mockStorage.getAllMedications()).thenAnswer((_) async => []);

      final container = makeContainer();
      container.listen<AsyncValue<List<Reminder>>>(
        todayRemindersProvider,
        (_, _) {},
        fireImmediately: true,
      );
      await container.read(todayRemindersProvider.future);

      final result = await container
          .read(todayRemindersProvider.notifier)
          .generateAndScheduleToday();

      expect(result, isEmpty);
    });

    test('filters out inactive schedules and returns empty', () async {
      final inactiveSchedule = _makeSchedule(
        id: 's-inactive',
        medicationId: 'med-1',
        isActive: false,
      );

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(
        mockStorage.getAllSchedules(),
      ).thenAnswer((_) async => [inactiveSchedule]);
      when(mockStorage.getAllMedications()).thenAnswer((_) async => []);

      final container = makeContainer();
      container.listen<AsyncValue<List<Reminder>>>(
        todayRemindersProvider,
        (_, _) {},
        fireImmediately: true,
      );
      await container.read(todayRemindersProvider.future);

      final result = await container
          .read(todayRemindersProvider.notifier)
          .generateAndScheduleToday();

      expect(result, isEmpty);
    });

    test('builds medicationInfo map and returns generated reminders', () async {
      // Active daily schedule → generates a reminder for today.
      // Medication exists → medicationInfo entry is built (lines 116–122).
      final med = _makeMedication('med-gen', 'Vitamin C');
      final schedule = _makeSchedule(
        id: 's-active',
        medicationId: 'med-gen',
        isActive: true,
        times: ['23:59'], // late time — reminder is pending, not past midnight
      );

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.getAllSchedules()).thenAnswer((_) async => [schedule]);
      when(mockStorage.getAllMedications()).thenAnswer((_) async => [med]);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final container = makeContainer();
      container.listen<AsyncValue<List<Reminder>>>(
        todayRemindersProvider,
        (_, _) {},
        fireImmediately: true,
      );
      await container.read(todayRemindersProvider.future);

      final result = await container
          .read(todayRemindersProvider.notifier)
          .generateAndScheduleToday();

      // One pending reminder was generated and returned.
      expect(result, hasLength(1));
      expect(result.first.medicationId, equals('med-gen'));
    });

    test('schedules pending reminders via NotificationService', () async {
      // Two active schedules, two medications → pendingReminders list populated
      // → scheduleTodayReminders called (line 129).
      final med1 = _makeMedication('med-a', 'Med A');
      final med2 = _makeMedication('med-b', 'Med B');
      final s1 = _makeSchedule(
        id: 's1',
        medicationId: 'med-a',
        times: ['23:58'],
      );
      final s2 = _makeSchedule(
        id: 's2',
        medicationId: 'med-b',
        times: ['23:59'],
      );

      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.getAllSchedules()).thenAnswer((_) async => [s1, s2]);
      when(
        mockStorage.getAllMedications(),
      ).thenAnswer((_) async => [med1, med2]);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final container = makeContainer();
      container.listen<AsyncValue<List<Reminder>>>(
        todayRemindersProvider,
        (_, _) {},
        fireImmediately: true,
      );
      await container.read(todayRemindersProvider.future);

      final result = await container
          .read(todayRemindersProvider.notifier)
          .generateAndScheduleToday();

      expect(result, hasLength(2));
    });

    test('existing reminders are included in result', () async {
      // Pre-existing reminder in storage + active schedule for different med.
      final existing = _makeReminder(
        id: 'r-existing',
        medicationId: 'med-existing',
        status: ReminderStatus.taken,
      );
      final med = _makeMedication('med-new', 'New Med');
      final schedule = _makeSchedule(
        id: 's-new',
        medicationId: 'med-new',
        times: ['23:57'],
      );

      when(
        mockStorage.getRemindersForDate(any),
      ).thenAnswer((_) async => [existing]);
      when(mockStorage.getAllSchedules()).thenAnswer((_) async => [schedule]);
      when(mockStorage.getAllMedications()).thenAnswer((_) async => [med]);
      when(mockStorage.saveReminder(any)).thenAnswer((_) async {});

      final container = makeContainer();
      container.listen<AsyncValue<List<Reminder>>>(
        todayRemindersProvider,
        (_, _) {},
        fireImmediately: true,
      );
      await container.read(todayRemindersProvider.future);

      final result = await container
          .read(todayRemindersProvider.notifier)
          .generateAndScheduleToday();

      // existing + newly generated
      expect(result.length, greaterThanOrEqualTo(1));
      expect(result.any((r) => r.id == 'r-existing'), isTrue);
    });

    test('returns reminders list after invalidateSelf', () async {
      // After generateAndScheduleToday, provider is invalidated (line 136)
      // and a subsequent read reflects refreshed state.
      when(mockStorage.getRemindersForDate(any)).thenAnswer((_) async => []);
      when(mockStorage.getAllSchedules()).thenAnswer((_) async => []);
      when(mockStorage.getAllMedications()).thenAnswer((_) async => []);

      final container = makeContainer();
      container.listen<AsyncValue<List<Reminder>>>(
        todayRemindersProvider,
        (_, _) {},
        fireImmediately: true,
      );
      await container.read(todayRemindersProvider.future);

      final returned = await container
          .read(todayRemindersProvider.notifier)
          .generateAndScheduleToday();

      // Method returns the list of reminders (line 138).
      expect(returned, isA<List<Reminder>>());
    });
  });
}
