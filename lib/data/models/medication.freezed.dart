// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'medication.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Medication {

 String get id; String get name; double get dosage; DosageUnit get dosageUnit; PillShape get shape; PillColor get color; String? get photoPath; String? get scheduleId; int get inventoryTotal; int get inventoryRemaining; int get lowStockThreshold; DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MedicationCopyWith<Medication> get copyWith => _$MedicationCopyWithImpl<Medication>(this as Medication, _$identity);

  /// Serializes this Medication to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Medication&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.dosageUnit, dosageUnit) || other.dosageUnit == dosageUnit)&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.color, color) || other.color == color)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.inventoryTotal, inventoryTotal) || other.inventoryTotal == inventoryTotal)&&(identical(other.inventoryRemaining, inventoryRemaining) || other.inventoryRemaining == inventoryRemaining)&&(identical(other.lowStockThreshold, lowStockThreshold) || other.lowStockThreshold == lowStockThreshold)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,dosage,dosageUnit,shape,color,photoPath,scheduleId,inventoryTotal,inventoryRemaining,lowStockThreshold,createdAt,updatedAt);

@override
String toString() {
  return 'Medication(id: $id, name: $name, dosage: $dosage, dosageUnit: $dosageUnit, shape: $shape, color: $color, photoPath: $photoPath, scheduleId: $scheduleId, inventoryTotal: $inventoryTotal, inventoryRemaining: $inventoryRemaining, lowStockThreshold: $lowStockThreshold, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MedicationCopyWith<$Res>  {
  factory $MedicationCopyWith(Medication value, $Res Function(Medication) _then) = _$MedicationCopyWithImpl;
@useResult
$Res call({
 String id, String name, double dosage, DosageUnit dosageUnit, PillShape shape, PillColor color, String? photoPath, String? scheduleId, int inventoryTotal, int inventoryRemaining, int lowStockThreshold, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$MedicationCopyWithImpl<$Res>
    implements $MedicationCopyWith<$Res> {
  _$MedicationCopyWithImpl(this._self, this._then);

  final Medication _self;
  final $Res Function(Medication) _then;

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? dosage = null,Object? dosageUnit = null,Object? shape = null,Object? color = null,Object? photoPath = freezed,Object? scheduleId = freezed,Object? inventoryTotal = null,Object? inventoryRemaining = null,Object? lowStockThreshold = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dosage: null == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as double,dosageUnit: null == dosageUnit ? _self.dosageUnit : dosageUnit // ignore: cast_nullable_to_non_nullable
as DosageUnit,shape: null == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as PillShape,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as PillColor,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,scheduleId: freezed == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String?,inventoryTotal: null == inventoryTotal ? _self.inventoryTotal : inventoryTotal // ignore: cast_nullable_to_non_nullable
as int,inventoryRemaining: null == inventoryRemaining ? _self.inventoryRemaining : inventoryRemaining // ignore: cast_nullable_to_non_nullable
as int,lowStockThreshold: null == lowStockThreshold ? _self.lowStockThreshold : lowStockThreshold // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Medication].
extension MedicationPatterns on Medication {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Medication value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Medication() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Medication value)  $default,){
final _that = this;
switch (_that) {
case _Medication():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Medication value)?  $default,){
final _that = this;
switch (_that) {
case _Medication() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double dosage,  DosageUnit dosageUnit,  PillShape shape,  PillColor color,  String? photoPath,  String? scheduleId,  int inventoryTotal,  int inventoryRemaining,  int lowStockThreshold,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Medication() when $default != null:
return $default(_that.id,_that.name,_that.dosage,_that.dosageUnit,_that.shape,_that.color,_that.photoPath,_that.scheduleId,_that.inventoryTotal,_that.inventoryRemaining,_that.lowStockThreshold,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double dosage,  DosageUnit dosageUnit,  PillShape shape,  PillColor color,  String? photoPath,  String? scheduleId,  int inventoryTotal,  int inventoryRemaining,  int lowStockThreshold,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Medication():
return $default(_that.id,_that.name,_that.dosage,_that.dosageUnit,_that.shape,_that.color,_that.photoPath,_that.scheduleId,_that.inventoryTotal,_that.inventoryRemaining,_that.lowStockThreshold,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double dosage,  DosageUnit dosageUnit,  PillShape shape,  PillColor color,  String? photoPath,  String? scheduleId,  int inventoryTotal,  int inventoryRemaining,  int lowStockThreshold,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Medication() when $default != null:
return $default(_that.id,_that.name,_that.dosage,_that.dosageUnit,_that.shape,_that.color,_that.photoPath,_that.scheduleId,_that.inventoryTotal,_that.inventoryRemaining,_that.lowStockThreshold,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Medication implements Medication {
  const _Medication({required this.id, required this.name, required this.dosage, required this.dosageUnit, this.shape = PillShape.round, this.color = PillColor.white, this.photoPath, this.scheduleId, this.inventoryTotal = 30, this.inventoryRemaining = 30, this.lowStockThreshold = 5, required this.createdAt, this.updatedAt});
  factory _Medication.fromJson(Map<String, dynamic> json) => _$MedicationFromJson(json);

@override final  String id;
@override final  String name;
@override final  double dosage;
@override final  DosageUnit dosageUnit;
@override@JsonKey() final  PillShape shape;
@override@JsonKey() final  PillColor color;
@override final  String? photoPath;
@override final  String? scheduleId;
@override@JsonKey() final  int inventoryTotal;
@override@JsonKey() final  int inventoryRemaining;
@override@JsonKey() final  int lowStockThreshold;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MedicationCopyWith<_Medication> get copyWith => __$MedicationCopyWithImpl<_Medication>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MedicationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Medication&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dosage, dosage) || other.dosage == dosage)&&(identical(other.dosageUnit, dosageUnit) || other.dosageUnit == dosageUnit)&&(identical(other.shape, shape) || other.shape == shape)&&(identical(other.color, color) || other.color == color)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.scheduleId, scheduleId) || other.scheduleId == scheduleId)&&(identical(other.inventoryTotal, inventoryTotal) || other.inventoryTotal == inventoryTotal)&&(identical(other.inventoryRemaining, inventoryRemaining) || other.inventoryRemaining == inventoryRemaining)&&(identical(other.lowStockThreshold, lowStockThreshold) || other.lowStockThreshold == lowStockThreshold)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,dosage,dosageUnit,shape,color,photoPath,scheduleId,inventoryTotal,inventoryRemaining,lowStockThreshold,createdAt,updatedAt);

@override
String toString() {
  return 'Medication(id: $id, name: $name, dosage: $dosage, dosageUnit: $dosageUnit, shape: $shape, color: $color, photoPath: $photoPath, scheduleId: $scheduleId, inventoryTotal: $inventoryTotal, inventoryRemaining: $inventoryRemaining, lowStockThreshold: $lowStockThreshold, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MedicationCopyWith<$Res> implements $MedicationCopyWith<$Res> {
  factory _$MedicationCopyWith(_Medication value, $Res Function(_Medication) _then) = __$MedicationCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double dosage, DosageUnit dosageUnit, PillShape shape, PillColor color, String? photoPath, String? scheduleId, int inventoryTotal, int inventoryRemaining, int lowStockThreshold, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$MedicationCopyWithImpl<$Res>
    implements _$MedicationCopyWith<$Res> {
  __$MedicationCopyWithImpl(this._self, this._then);

  final _Medication _self;
  final $Res Function(_Medication) _then;

/// Create a copy of Medication
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? dosage = null,Object? dosageUnit = null,Object? shape = null,Object? color = null,Object? photoPath = freezed,Object? scheduleId = freezed,Object? inventoryTotal = null,Object? inventoryRemaining = null,Object? lowStockThreshold = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_Medication(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dosage: null == dosage ? _self.dosage : dosage // ignore: cast_nullable_to_non_nullable
as double,dosageUnit: null == dosageUnit ? _self.dosageUnit : dosageUnit // ignore: cast_nullable_to_non_nullable
as DosageUnit,shape: null == shape ? _self.shape : shape // ignore: cast_nullable_to_non_nullable
as PillShape,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as PillColor,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,scheduleId: freezed == scheduleId ? _self.scheduleId : scheduleId // ignore: cast_nullable_to_non_nullable
as String?,inventoryTotal: null == inventoryTotal ? _self.inventoryTotal : inventoryTotal // ignore: cast_nullable_to_non_nullable
as int,inventoryRemaining: null == inventoryRemaining ? _self.inventoryRemaining : inventoryRemaining // ignore: cast_nullable_to_non_nullable
as int,lowStockThreshold: null == lowStockThreshold ? _self.lowStockThreshold : lowStockThreshold // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
