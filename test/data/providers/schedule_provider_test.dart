import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_pill/data/enums/schedule_type.dart';
import 'package:my_pill/data/enums/timezone_mode.dart';
import 'package:my_pill/data/models/schedule.dart';
import 'package:my_pill/data/providers/schedule_provider.dart';
import 'package:my_pill/data/providers/storage_service_provider.dart';
import 'package:my_pill/data/services/storage_service.dart';

@GenerateMocks([StorageService])
import 'schedule_provider_test.mocks.dart';

Schedule _makeSchedule(String id, String medicationId) => Schedule(
      id: id,
      medicationId: medicationId,
      type: ScheduleType.daily,
      timesPerDay: 1,
      times: const ['08:00'],
      timezoneMode: TimezoneMode.fixedInterval,
    );

void main() {
  late MockStorageService mockStorage;

  setUp(() {
    mockStorage = MockStorageService();
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        storageServiceProvider.overrideWithValue(mockStorage),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('ScheduleList provider', () {
    test('build returns empty list when no schedules', () async {
      when(mockStorage.getAllSchedules()).thenAnswer((_) async => []);

      final container = makeContainer();
      final result = await container.read(scheduleListProvider.future);

      expect(result, isEmpty);
    });

    test('build returns all schedules from storage', () async {
      final schedules = [
        _makeSchedule('sched-1', 'med-1'),
        _makeSchedule('sched-2', 'med-2'),
      ];
      when(mockStorage.getAllSchedules()).thenAnswer((_) async => schedules);

      final container = makeContainer();
      final result = await container.read(scheduleListProvider.future);

      expect(result.length, equals(2));
      expect(result[0].id, equals('sched-1'));
      expect(result[1].id, equals('sched-2'));
    });

    test('addSchedule saves schedule and invalidates provider', () async {
      final schedule = _makeSchedule('sched-1', 'med-1');
      when(mockStorage.getAllSchedules()).thenAnswer((_) async => []);
      when(mockStorage.saveSchedule(any)).thenAnswer((_) async {});

      final container = makeContainer();
      await container.read(scheduleListProvider.future);

      await container
          .read(scheduleListProvider.notifier)
          .addSchedule(schedule);

      verify(mockStorage.saveSchedule(schedule)).called(1);
    });

    test('updateSchedule saves updated schedule and invalidates provider',
        () async {
      final schedule = _makeSchedule('sched-1', 'med-1');
      final updated = schedule.copyWith(timesPerDay: 2);

      when(mockStorage.getAllSchedules())
          .thenAnswer((_) async => [schedule]);
      when(mockStorage.saveSchedule(any)).thenAnswer((_) async {});

      final container = makeContainer();
      await container.read(scheduleListProvider.future);

      await container
          .read(scheduleListProvider.notifier)
          .updateSchedule(updated);

      verify(mockStorage.saveSchedule(updated)).called(1);
    });

    test('deleteSchedule deletes schedule by id and invalidates provider',
        () async {
      final schedule = _makeSchedule('sched-1', 'med-1');
      when(mockStorage.getAllSchedules())
          .thenAnswer((_) async => [schedule]);
      when(mockStorage.deleteSchedule(any)).thenAnswer((_) async {});

      final container = makeContainer();
      await container.read(scheduleListProvider.future);

      await container
          .read(scheduleListProvider.notifier)
          .deleteSchedule('sched-1');

      verify(mockStorage.deleteSchedule('sched-1')).called(1);
    });
  });

  group('medicationSchedules provider', () {
    test('returns schedules for given medication id', () async {
      final schedules = [
        _makeSchedule('sched-1', 'med-1'),
        _makeSchedule('sched-2', 'med-1'),
      ];
      when(mockStorage.getSchedulesForMedication('med-1'))
          .thenAnswer((_) async => schedules);

      final container = makeContainer();
      final result =
          await container.read(medicationSchedulesProvider('med-1').future);

      expect(result.length, equals(2));
      expect(result.every((s) => s.medicationId == 'med-1'), isTrue);
    });

    test('returns empty list when no schedules for medication', () async {
      when(mockStorage.getSchedulesForMedication('med-99'))
          .thenAnswer((_) async => []);

      final container = makeContainer();
      final result =
          await container.read(medicationSchedulesProvider('med-99').future);

      expect(result, isEmpty);
    });
  });
}
