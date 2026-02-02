import 'package:uuid/uuid.dart';
import 'package:my_pill/data/models/schedule.dart';
import 'package:my_pill/data/services/storage_service.dart';
import 'package:my_pill/data/enums/schedule_type.dart';

class ScheduleRepository {
  final StorageService _storage;
  static const _uuid = Uuid();

  ScheduleRepository(this._storage);

  /// Create schedule (generates UUID)
  Future<Schedule> createSchedule(Schedule schedule) async {
    final newSchedule = schedule.copyWith(id: _uuid.v4());
    await _storage.saveSchedule(newSchedule);
    return newSchedule;
  }

  /// Get all schedules for a specific medication
  Future<List<Schedule>> getSchedulesForMedication(String medicationId) async {
    return await _storage.getSchedulesForMedication(medicationId);
  }

  /// Update schedule
  Future<void> updateSchedule(Schedule schedule) async {
    await _storage.saveSchedule(schedule);
  }

  /// Delete schedule
  Future<void> deleteSchedule(String id) async {
    await _storage.deleteSchedule(id);
  }

  /// Generate time slots for a schedule based on type
  List<DateTime> generateTimeSlotsForDate(Schedule schedule, DateTime date) {
    if (!isActiveOnDate(schedule, date)) {
      return [];
    }

    switch (schedule.type) {
      case ScheduleType.daily:
        return _generateDailyTimeSlots(schedule, date);

      case ScheduleType.specificDays:
        if (_isScheduledDay(schedule, date)) {
          return _generateDailyTimeSlots(schedule, date);
        }
        return [];

      case ScheduleType.interval:
        return _generateIntervalTimeSlots(schedule, date);
    }
  }

  /// Check if schedule is active on a given date
  bool isActiveOnDate(Schedule schedule, DateTime date) {
    if (!schedule.isActive) {
      return false;
    }

    switch (schedule.type) {
      case ScheduleType.daily:
        return true;

      case ScheduleType.specificDays:
        return _isScheduledDay(schedule, date);

      case ScheduleType.interval:
        return true;
    }
  }

  /// Generate daily time slots from schedule.times list
  List<DateTime> _generateDailyTimeSlots(Schedule schedule, DateTime date) {
    final slots = <DateTime>[];

    for (final timeStr in schedule.times) {
      final time = _parseTime(timeStr);
      if (time != null) {
        slots.add(DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        ));
      }
    }

    return slots;
  }

  /// Generate interval-based time slots
  List<DateTime> _generateIntervalTimeSlots(Schedule schedule, DateTime date) {
    final slots = <DateTime>[];
    final intervalHours = schedule.intervalHours;

    if (intervalHours == null || intervalHours <= 0) {
      return slots;
    }

    // Start from first time if available, otherwise midnight
    DateTime startTime;
    if (schedule.times.isNotEmpty) {
      final time = _parseTime(schedule.times.first);
      if (time != null) {
        startTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      } else {
        startTime = DateTime(date.year, date.month, date.day);
      }
    } else {
      startTime = DateTime(date.year, date.month, date.day);
    }

    // Generate slots throughout the day
    DateTime currentTime = startTime;
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    while (currentTime.isBefore(endOfDay) || currentTime.isAtSameMomentAs(endOfDay)) {
      slots.add(currentTime);
      currentTime = currentTime.add(Duration(hours: intervalHours));
    }

    return slots;
  }

  /// Check if the date's weekday is in the schedule's specificDays list
  bool _isScheduledDay(Schedule schedule, DateTime date) {
    // DateTime.weekday: 1 = Monday, 7 = Sunday
    return schedule.specificDays.contains(date.weekday);
  }

  /// Parse time string (HH:mm format) to TimeOfDay-like structure
  _TimeOfDay? _parseTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length != 2) return null;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        return null;
      }

      return _TimeOfDay(hour, minute);
    } catch (e) {
      return null;
    }
  }
}

/// Internal time representation
class _TimeOfDay {
  final int hour;
  final int minute;

  _TimeOfDay(this.hour, this.minute);
}
