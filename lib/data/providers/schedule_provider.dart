import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/models/schedule.dart';
import 'package:my_pill/data/providers/storage_service_provider.dart';

part 'schedule_provider.g.dart';

@riverpod
class ScheduleList extends _$ScheduleList {
  @override
  Future<List<Schedule>> build() async {
    final storage = ref.watch(storageServiceProvider);
    return storage.getAllSchedules();
  }

  Future<void> addSchedule(Schedule schedule) async {
    final storage = ref.read(storageServiceProvider);
    await storage.saveSchedule(schedule);
    ref.invalidateSelf();
  }

  Future<void> updateSchedule(Schedule schedule) async {
    final storage = ref.read(storageServiceProvider);
    await storage.saveSchedule(schedule);
    ref.invalidateSelf();
  }

  Future<void> deleteSchedule(String id) async {
    final storage = ref.read(storageServiceProvider);
    await storage.deleteSchedule(id);
    ref.invalidateSelf();
  }
}

@riverpod
Future<List<Schedule>> medicationSchedules(Ref ref, String medicationId) async {
  final storage = ref.watch(storageServiceProvider);
  return storage.getSchedulesForMedication(medicationId);
}
