// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Reminder _$ReminderFromJson(Map<String, dynamic> json) => _Reminder(
  id: json['id'] as String,
  medicationId: json['medicationId'] as String,
  scheduledTime: DateTime.parse(json['scheduledTime'] as String),
  status:
      $enumDecodeNullable(_$ReminderStatusEnumMap, json['status']) ??
      ReminderStatus.pending,
  actionTime: json['actionTime'] == null
      ? null
      : DateTime.parse(json['actionTime'] as String),
  snoozedUntil: json['snoozedUntil'] == null
      ? null
      : DateTime.parse(json['snoozedUntil'] as String),
);

Map<String, dynamic> _$ReminderToJson(_Reminder instance) => <String, dynamic>{
  'id': instance.id,
  'medicationId': instance.medicationId,
  'scheduledTime': instance.scheduledTime.toIso8601String(),
  'status': _$ReminderStatusEnumMap[instance.status]!,
  'actionTime': instance.actionTime?.toIso8601String(),
  'snoozedUntil': instance.snoozedUntil?.toIso8601String(),
};

const _$ReminderStatusEnumMap = {
  ReminderStatus.pending: 'pending',
  ReminderStatus.taken: 'taken',
  ReminderStatus.missed: 'missed',
  ReminderStatus.skipped: 'skipped',
  ReminderStatus.snoozed: 'snoozed',
};
