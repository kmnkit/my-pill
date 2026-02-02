import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_pill/data/enums/reminder_status.dart';

part 'reminder.freezed.dart';
part 'reminder.g.dart';

@freezed
abstract class Reminder with _$Reminder {
  const factory Reminder({
    required String id,
    required String medicationId,
    required DateTime scheduledTime,
    @Default(ReminderStatus.pending) ReminderStatus status,
    DateTime? actionTime,
    DateTime? snoozedUntil,
  }) = _Reminder;

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);
}
