import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_pill/data/enums/dosage_timing.dart';
import 'package:my_pill/data/enums/schedule_type.dart';
import 'package:my_pill/data/enums/timezone_mode.dart';
import 'package:my_pill/data/models/dosage_time_slot.dart';

part 'schedule.freezed.dart';
part 'schedule.g.dart';

@freezed
abstract class Schedule with _$Schedule {
  const Schedule._();

  const factory Schedule({
    required String id,
    required String medicationId,
    required ScheduleType type,
    @Default([]) List<DosageTimeSlot> dosageSlots,
    @Default([]) List<int> specificDays,
    int? intervalHours,
    @Default(TimezoneMode.fixedInterval) TimezoneMode timezoneMode,
    @Default(true) bool isActive,
  }) = _Schedule;

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  /// Backward-compatible getter: number of doses per day.
  int get timesPerDay => dosageSlots.length;

  /// Backward-compatible getter: list of time strings (e.g. ["08:00", "20:00"]).
  List<String> get times => dosageSlots.map((s) => s.time).toList();

  /// Backward-compatible getter: list of DosageTiming enum values.
  List<DosageTiming> get dosageTimings =>
      dosageSlots.map((s) => s.timing).toList();
}
