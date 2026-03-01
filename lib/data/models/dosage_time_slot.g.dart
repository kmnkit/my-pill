// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dosage_time_slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DosageTimeSlot _$DosageTimeSlotFromJson(Map<String, dynamic> json) =>
    _DosageTimeSlot(
      timing: $enumDecode(_$DosageTimingEnumMap, json['timing']),
      time: json['time'] as String,
    );

Map<String, dynamic> _$DosageTimeSlotToJson(_DosageTimeSlot instance) =>
    <String, dynamic>{
      'timing': _$DosageTimingEnumMap[instance.timing]!,
      'time': instance.time,
    };

const _$DosageTimingEnumMap = {
  DosageTiming.morning: 'morning',
  DosageTiming.noon: 'noon',
  DosageTiming.evening: 'evening',
  DosageTiming.bedtime: 'bedtime',
};
