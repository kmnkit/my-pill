// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Inventory _$InventoryFromJson(Map<String, dynamic> json) => _Inventory(
  medicationId: json['medicationId'] as String,
  total: (json['total'] as num).toInt(),
  remaining: (json['remaining'] as num).toInt(),
  lowStockThreshold: (json['lowStockThreshold'] as num?)?.toInt() ?? 5,
);

Map<String, dynamic> _$InventoryToJson(_Inventory instance) =>
    <String, dynamic>{
      'medicationId': instance.medicationId,
      'total': instance.total,
      'remaining': instance.remaining,
      'lowStockThreshold': instance.lowStockThreshold,
    };
