import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_pill/data/enums/reminder_status.dart';

part 'adherence_record.freezed.dart';
part 'adherence_record.g.dart';

@freezed
abstract class AdherenceRecord with _$AdherenceRecord {
  const factory AdherenceRecord({
    required String id,
    required String medicationId,
    required DateTime date,
    required ReminderStatus status,
    required DateTime scheduledTime,
    DateTime? actionTime,
  }) = _AdherenceRecord;

  factory AdherenceRecord.fromJson(Map<String, dynamic> json) =>
      _$AdherenceRecordFromJson(json);
}
