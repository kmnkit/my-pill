// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dosage_time_slot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DosageTimeSlot {

 DosageTiming get timing; String get time;
/// Create a copy of DosageTimeSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DosageTimeSlotCopyWith<DosageTimeSlot> get copyWith => _$DosageTimeSlotCopyWithImpl<DosageTimeSlot>(this as DosageTimeSlot, _$identity);

  /// Serializes this DosageTimeSlot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DosageTimeSlot&&(identical(other.timing, timing) || other.timing == timing)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timing,time);

@override
String toString() {
  return 'DosageTimeSlot(timing: $timing, time: $time)';
}


}

/// @nodoc
abstract mixin class $DosageTimeSlotCopyWith<$Res>  {
  factory $DosageTimeSlotCopyWith(DosageTimeSlot value, $Res Function(DosageTimeSlot) _then) = _$DosageTimeSlotCopyWithImpl;
@useResult
$Res call({
 DosageTiming timing, String time
});




}
/// @nodoc
class _$DosageTimeSlotCopyWithImpl<$Res>
    implements $DosageTimeSlotCopyWith<$Res> {
  _$DosageTimeSlotCopyWithImpl(this._self, this._then);

  final DosageTimeSlot _self;
  final $Res Function(DosageTimeSlot) _then;

/// Create a copy of DosageTimeSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timing = null,Object? time = null,}) {
  return _then(_self.copyWith(
timing: null == timing ? _self.timing : timing // ignore: cast_nullable_to_non_nullable
as DosageTiming,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DosageTimeSlot].
extension DosageTimeSlotPatterns on DosageTimeSlot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DosageTimeSlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DosageTimeSlot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DosageTimeSlot value)  $default,){
final _that = this;
switch (_that) {
case _DosageTimeSlot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DosageTimeSlot value)?  $default,){
final _that = this;
switch (_that) {
case _DosageTimeSlot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DosageTiming timing,  String time)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DosageTimeSlot() when $default != null:
return $default(_that.timing,_that.time);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DosageTiming timing,  String time)  $default,) {final _that = this;
switch (_that) {
case _DosageTimeSlot():
return $default(_that.timing,_that.time);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DosageTiming timing,  String time)?  $default,) {final _that = this;
switch (_that) {
case _DosageTimeSlot() when $default != null:
return $default(_that.timing,_that.time);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DosageTimeSlot extends DosageTimeSlot {
  const _DosageTimeSlot({required this.timing, required this.time}): super._();
  factory _DosageTimeSlot.fromJson(Map<String, dynamic> json) => _$DosageTimeSlotFromJson(json);

@override final  DosageTiming timing;
@override final  String time;

/// Create a copy of DosageTimeSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DosageTimeSlotCopyWith<_DosageTimeSlot> get copyWith => __$DosageTimeSlotCopyWithImpl<_DosageTimeSlot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DosageTimeSlotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DosageTimeSlot&&(identical(other.timing, timing) || other.timing == timing)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timing,time);

@override
String toString() {
  return 'DosageTimeSlot(timing: $timing, time: $time)';
}


}

/// @nodoc
abstract mixin class _$DosageTimeSlotCopyWith<$Res> implements $DosageTimeSlotCopyWith<$Res> {
  factory _$DosageTimeSlotCopyWith(_DosageTimeSlot value, $Res Function(_DosageTimeSlot) _then) = __$DosageTimeSlotCopyWithImpl;
@override @useResult
$Res call({
 DosageTiming timing, String time
});




}
/// @nodoc
class __$DosageTimeSlotCopyWithImpl<$Res>
    implements _$DosageTimeSlotCopyWith<$Res> {
  __$DosageTimeSlotCopyWithImpl(this._self, this._then);

  final _DosageTimeSlot _self;
  final $Res Function(_DosageTimeSlot) _then;

/// Create a copy of DosageTimeSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timing = null,Object? time = null,}) {
  return _then(_DosageTimeSlot(
timing: null == timing ? _self.timing : timing // ignore: cast_nullable_to_non_nullable
as DosageTiming,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
