// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adherence_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdherenceRecord _$AdherenceRecordFromJson(Map<String, dynamic> json) =>
    _AdherenceRecord(
      id: json['id'] as String,
      medicationId: json['medicationId'] as String,
      date: DateTime.parse(json['date'] as String),
      status: $enumDecode(_$ReminderStatusEnumMap, json['status']),
      scheduledTime: DateTime.parse(json['scheduledTime'] as String),
      actionTime: json['actionTime'] == null
          ? null
          : DateTime.parse(json['actionTime'] as String),
    );

Map<String, dynamic> _$AdherenceRecordToJson(_AdherenceRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'medicationId': instance.medicationId,
      'date': instance.date.toIso8601String(),
      'status': _$ReminderStatusEnumMap[instance.status]!,
      'scheduledTime': instance.scheduledTime.toIso8601String(),
      'actionTime': instance.actionTime?.toIso8601String(),
    };

const _$ReminderStatusEnumMap = {
  ReminderStatus.pending: 'pending',
  ReminderStatus.taken: 'taken',
  ReminderStatus.missed: 'missed',
  ReminderStatus.skipped: 'skipped',
  ReminderStatus.snoozed: 'snoozed',
};
