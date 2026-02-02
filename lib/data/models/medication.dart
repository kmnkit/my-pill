import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_pill/data/enums/dosage_unit.dart';
import 'package:my_pill/data/enums/pill_color.dart';
import 'package:my_pill/data/enums/pill_shape.dart';

part 'medication.freezed.dart';
part 'medication.g.dart';

@freezed
abstract class Medication with _$Medication {
  const factory Medication({
    required String id,
    required String name,
    required double dosage,
    required DosageUnit dosageUnit,
    @Default(PillShape.round) PillShape shape,
    @Default(PillColor.white) PillColor color,
    String? photoPath,
    String? scheduleId,
    @Default(30) int inventoryTotal,
    @Default(30) int inventoryRemaining,
    @Default(5) int lowStockThreshold,
    @Default(false) bool isCritical,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Medication;

  factory Medication.fromJson(Map<String, dynamic> json) =>
      _$MedicationFromJson(json);
}
