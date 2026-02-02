// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Schedule _$ScheduleFromJson(Map<String, dynamic> json) => _Schedule(
  id: json['id'] as String,
  medicationId: json['medicationId'] as String,
  type: $enumDecode(_$ScheduleTypeEnumMap, json['type']),
  timesPerDay: (json['timesPerDay'] as num?)?.toInt() ?? 1,
  times:
      (json['times'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  specificDays:
      (json['specificDays'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  intervalHours: (json['intervalHours'] as num?)?.toInt(),
  timezoneMode:
      $enumDecodeNullable(_$TimezoneModeEnumMap, json['timezoneMode']) ??
      TimezoneMode.fixedInterval,
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$ScheduleToJson(_Schedule instance) => <String, dynamic>{
  'id': instance.id,
  'medicationId': instance.medicationId,
  'type': _$ScheduleTypeEnumMap[instance.type]!,
  'timesPerDay': instance.timesPerDay,
  'times': instance.times,
  'specificDays': instance.specificDays,
  'intervalHours': instance.intervalHours,
  'timezoneMode': _$TimezoneModeEnumMap[instance.timezoneMode]!,
  'isActive': instance.isActive,
};

const _$ScheduleTypeEnumMap = {
  ScheduleType.daily: 'daily',
  ScheduleType.specificDays: 'specificDays',
  ScheduleType.interval: 'interval',
};

const _$TimezoneModeEnumMap = {
  TimezoneMode.fixedInterval: 'fixedInterval',
  TimezoneMode.localTime: 'localTime',
};
