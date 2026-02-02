// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Medication _$MedicationFromJson(Map<String, dynamic> json) => _Medication(
  id: json['id'] as String,
  name: json['name'] as String,
  dosage: (json['dosage'] as num).toDouble(),
  dosageUnit: $enumDecode(_$DosageUnitEnumMap, json['dosageUnit']),
  shape:
      $enumDecodeNullable(_$PillShapeEnumMap, json['shape']) ?? PillShape.round,
  color:
      $enumDecodeNullable(_$PillColorEnumMap, json['color']) ?? PillColor.white,
  photoPath: json['photoPath'] as String?,
  scheduleId: json['scheduleId'] as String?,
  inventoryTotal: (json['inventoryTotal'] as num?)?.toInt() ?? 30,
  inventoryRemaining: (json['inventoryRemaining'] as num?)?.toInt() ?? 30,
  lowStockThreshold: (json['lowStockThreshold'] as num?)?.toInt() ?? 5,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$MedicationToJson(_Medication instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'dosage': instance.dosage,
      'dosageUnit': _$DosageUnitEnumMap[instance.dosageUnit]!,
      'shape': _$PillShapeEnumMap[instance.shape]!,
      'color': _$PillColorEnumMap[instance.color]!,
      'photoPath': instance.photoPath,
      'scheduleId': instance.scheduleId,
      'inventoryTotal': instance.inventoryTotal,
      'inventoryRemaining': instance.inventoryRemaining,
      'lowStockThreshold': instance.lowStockThreshold,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$DosageUnitEnumMap = {
  DosageUnit.mg: 'mg',
  DosageUnit.ml: 'ml',
  DosageUnit.pills: 'pills',
  DosageUnit.units: 'units',
};

const _$PillShapeEnumMap = {
  PillShape.round: 'round',
  PillShape.capsule: 'capsule',
  PillShape.oval: 'oval',
  PillShape.square: 'square',
  PillShape.triangle: 'triangle',
  PillShape.hexagon: 'hexagon',
};

const _$PillColorEnumMap = {
  PillColor.white: 'white',
  PillColor.blue: 'blue',
  PillColor.yellow: 'yellow',
  PillColor.pink: 'pink',
  PillColor.red: 'red',
  PillColor.green: 'green',
  PillColor.orange: 'orange',
  PillColor.purple: 'purple',
};
