import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory.freezed.dart';
part 'inventory.g.dart';

@freezed
abstract class Inventory with _$Inventory {
  const Inventory._();

  const factory Inventory({
    required String medicationId,
    required int total,
    required int remaining,
    @Default(5) int lowStockThreshold,
  }) = _Inventory;

  bool get isLowStock => remaining <= lowStockThreshold;
  double get percentage => total > 0 ? remaining / total : 0;

  factory Inventory.fromJson(Map<String, dynamic> json) =>
      _$InventoryFromJson(json);
}
