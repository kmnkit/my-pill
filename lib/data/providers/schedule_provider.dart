import 'dart:async' show unawaited;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kusuridoki/core/utils/analytics_service.dart';
import 'package:kusuridoki/data/models/schedule.dart';
import 'package:kusuridoki/data/providers/storage_service_provider.dart';

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
    unawaited(AnalyticsService.logReminderSet());
    if (!ref.mounted) return;
    ref.invalidateSelf();
  }

  Future<void> updateSchedule(Schedule schedule) async {
    final storage = ref.read(storageServiceProvider);
    await storage.saveSchedule(schedule);
    if (!ref.mounted) return;
    ref.invalidateSelf();
  }

  Future<void> deleteSchedule(String id) async {
    final storage = ref.read(storageServiceProvider);
    await storage.deleteSchedule(id);
    if (!ref.mounted) return;
    ref.invalidateSelf();
  }
}

@riverpod
Future<List<Schedule>> medicationSchedules(Ref ref, String medicationId) async {
  final storage = ref.watch(storageServiceProvider);
  return storage.getSchedulesForMedication(medicationId);
}
