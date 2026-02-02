// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adherence_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdherenceRecord {

 String get id; String get medicationId; DateTime get date; ReminderStatus get status; DateTime get scheduledTime; DateTime? get actionTime;
/// Create a copy of AdherenceRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdherenceRecordCopyWith<AdherenceRecord> get copyWith => _$AdherenceRecordCopyWithImpl<AdherenceRecord>(this as AdherenceRecord, _$identity);

  /// Serializes this AdherenceRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdherenceRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.actionTime, actionTime) || other.actionTime == actionTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicationId,date,status,scheduledTime,actionTime);

@override
String toString() {
  return 'AdherenceRecord(id: $id, medicationId: $medicationId, date: $date, status: $status, scheduledTime: $scheduledTime, actionTime: $actionTime)';
}


}

/// @nodoc
abstract mixin class $AdherenceRecordCopyWith<$Res>  {
  factory $AdherenceRecordCopyWith(AdherenceRecord value, $Res Function(AdherenceRecord) _then) = _$AdherenceRecordCopyWithImpl;
@useResult
$Res call({
 String id, String medicationId, DateTime date, ReminderStatus status, DateTime scheduledTime, DateTime? actionTime
});




}
/// @nodoc
class _$AdherenceRecordCopyWithImpl<$Res>
    implements $AdherenceRecordCopyWith<$Res> {
  _$AdherenceRecordCopyWithImpl(this._self, this._then);

  final AdherenceRecord _self;
  final $Res Function(AdherenceRecord) _then;

/// Create a copy of AdherenceRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? medicationId = null,Object? date = null,Object? status = null,Object? scheduledTime = null,Object? actionTime = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReminderStatus,scheduledTime: null == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as DateTime,actionTime: freezed == actionTime ? _self.actionTime : actionTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdherenceRecord].
extension AdherenceRecordPatterns on AdherenceRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdherenceRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdherenceRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdherenceRecord value)  $default,){
final _that = this;
switch (_that) {
case _AdherenceRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdherenceRecord value)?  $default,){
final _that = this;
switch (_that) {
case _AdherenceRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String medicationId,  DateTime date,  ReminderStatus status,  DateTime scheduledTime,  DateTime? actionTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdherenceRecord() when $default != null:
return $default(_that.id,_that.medicationId,_that.date,_that.status,_that.scheduledTime,_that.actionTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String medicationId,  DateTime date,  ReminderStatus status,  DateTime scheduledTime,  DateTime? actionTime)  $default,) {final _that = this;
switch (_that) {
case _AdherenceRecord():
return $default(_that.id,_that.medicationId,_that.date,_that.status,_that.scheduledTime,_that.actionTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String medicationId,  DateTime date,  ReminderStatus status,  DateTime scheduledTime,  DateTime? actionTime)?  $default,) {final _that = this;
switch (_that) {
case _AdherenceRecord() when $default != null:
return $default(_that.id,_that.medicationId,_that.date,_that.status,_that.scheduledTime,_that.actionTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdherenceRecord implements AdherenceRecord {
  const _AdherenceRecord({required this.id, required this.medicationId, required this.date, required this.status, required this.scheduledTime, this.actionTime});
  factory _AdherenceRecord.fromJson(Map<String, dynamic> json) => _$AdherenceRecordFromJson(json);

@override final  String id;
@override final  String medicationId;
@override final  DateTime date;
@override final  ReminderStatus status;
@override final  DateTime scheduledTime;
@override final  DateTime? actionTime;

/// Create a copy of AdherenceRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdherenceRecordCopyWith<_AdherenceRecord> get copyWith => __$AdherenceRecordCopyWithImpl<_AdherenceRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdherenceRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdherenceRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.actionTime, actionTime) || other.actionTime == actionTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicationId,date,status,scheduledTime,actionTime);

@override
String toString() {
  return 'AdherenceRecord(id: $id, medicationId: $medicationId, date: $date, status: $status, scheduledTime: $scheduledTime, actionTime: $actionTime)';
}


}

/// @nodoc
abstract mixin class _$AdherenceRecordCopyWith<$Res> implements $AdherenceRecordCopyWith<$Res> {
  factory _$AdherenceRecordCopyWith(_AdherenceRecord value, $Res Function(_AdherenceRecord) _then) = __$AdherenceRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String medicationId, DateTime date, ReminderStatus status, DateTime scheduledTime, DateTime? actionTime
});




}
/// @nodoc
class __$AdherenceRecordCopyWithImpl<$Res>
    implements _$AdherenceRecordCopyWith<$Res> {
  __$AdherenceRecordCopyWithImpl(this._self, this._then);

  final _AdherenceRecord _self;
  final $Res Function(_AdherenceRecord) _then;

/// Create a copy of AdherenceRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? medicationId = null,Object? date = null,Object? status = null,Object? scheduledTime = null,Object? actionTime = freezed,}) {
  return _then(_AdherenceRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReminderStatus,scheduledTime: null == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as DateTime,actionTime: freezed == actionTime ? _self.actionTime : actionTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
