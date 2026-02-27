import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kusuridoki/data/enums/dosage_timing.dart';

part 'dosage_time_slot.freezed.dart';
part 'dosage_time_slot.g.dart';

@freezed
abstract class DosageTimeSlot with _$DosageTimeSlot {
  const DosageTimeSlot._();

  const factory DosageTimeSlot({
    required DosageTiming timing,
    required String time,
  }) = _DosageTimeSlot;

  factory DosageTimeSlot.fromJson(Map<String, dynamic> json) =>
      _$DosageTimeSlotFromJson(json);

  /// Creates a [DosageTimeSlot] with the default time for the given [timing].
  factory DosageTimeSlot.withDefault(DosageTiming timing) {
    final hour = timing.defaultHour.toString().padLeft(2, '0');
    final minute = timing.defaultMinute.toString().padLeft(2, '0');
    return DosageTimeSlot(timing: timing, time: '$hour:$minute');
  }

  /// Parses the [time] string ("HH:mm") into a [TimeOfDay].
  TimeOfDay get timeOfDay {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
