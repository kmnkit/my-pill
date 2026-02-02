import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_pill/data/enums/schedule_type.dart';
import 'package:my_pill/data/enums/timezone_mode.dart';

part 'schedule.freezed.dart';
part 'schedule.g.dart';

@freezed
abstract class Schedule with _$Schedule {
  const factory Schedule({
    required String id,
    required String medicationId,
    required ScheduleType type,
    @Default(1) int timesPerDay,
    @Default([]) List<String> times,
    @Default([]) List<int> specificDays,
    int? intervalHours,
    @Default(TimezoneMode.fixedInterval) TimezoneMode timezoneMode,
    @Default(true) bool isActive,
  }) = _Schedule;

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
}
