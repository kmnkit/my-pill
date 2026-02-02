// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Schedule {

 String get id; String get medicationId; ScheduleType get type; int get timesPerDay; List<String> get times; List<int> get specificDays; int? get intervalHours; TimezoneMode get timezoneMode; bool get isActive;
/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleCopyWith<Schedule> get copyWith => _$ScheduleCopyWithImpl<Schedule>(this as Schedule, _$identity);

  /// Serializes this Schedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Schedule&&(identical(other.id, id) || other.id == id)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.type, type) || other.type == type)&&(identical(other.timesPerDay, timesPerDay) || other.timesPerDay == timesPerDay)&&const DeepCollectionEquality().equals(other.times, times)&&const DeepCollectionEquality().equals(other.specificDays, specificDays)&&(identical(other.intervalHours, intervalHours) || other.intervalHours == intervalHours)&&(identical(other.timezoneMode, timezoneMode) || other.timezoneMode == timezoneMode)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicationId,type,timesPerDay,const DeepCollectionEquality().hash(times),const DeepCollectionEquality().hash(specificDays),intervalHours,timezoneMode,isActive);

@override
String toString() {
  return 'Schedule(id: $id, medicationId: $medicationId, type: $type, timesPerDay: $timesPerDay, times: $times, specificDays: $specificDays, intervalHours: $intervalHours, timezoneMode: $timezoneMode, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $ScheduleCopyWith<$Res>  {
  factory $ScheduleCopyWith(Schedule value, $Res Function(Schedule) _then) = _$ScheduleCopyWithImpl;
@useResult
$Res call({
 String id, String medicationId, ScheduleType type, int timesPerDay, List<String> times, List<int> specificDays, int? intervalHours, TimezoneMode timezoneMode, bool isActive
});




}
/// @nodoc
class _$ScheduleCopyWithImpl<$Res>
    implements $ScheduleCopyWith<$Res> {
  _$ScheduleCopyWithImpl(this._self, this._then);

  final Schedule _self;
  final $Res Function(Schedule) _then;

/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? medicationId = null,Object? type = null,Object? timesPerDay = null,Object? times = null,Object? specificDays = null,Object? intervalHours = freezed,Object? timezoneMode = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ScheduleType,timesPerDay: null == timesPerDay ? _self.timesPerDay : timesPerDay // ignore: cast_nullable_to_non_nullable
as int,times: null == times ? _self.times : times // ignore: cast_nullable_to_non_nullable
as List<String>,specificDays: null == specificDays ? _self.specificDays : specificDays // ignore: cast_nullable_to_non_nullable
as List<int>,intervalHours: freezed == intervalHours ? _self.intervalHours : intervalHours // ignore: cast_nullable_to_non_nullable
as int?,timezoneMode: null == timezoneMode ? _self.timezoneMode : timezoneMode // ignore: cast_nullable_to_non_nullable
as TimezoneMode,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Schedule].
extension SchedulePatterns on Schedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Schedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Schedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Schedule value)  $default,){
final _that = this;
switch (_that) {
case _Schedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Schedule value)?  $default,){
final _that = this;
switch (_that) {
case _Schedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String medicationId,  ScheduleType type,  int timesPerDay,  List<String> times,  List<int> specificDays,  int? intervalHours,  TimezoneMode timezoneMode,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Schedule() when $default != null:
return $default(_that.id,_that.medicationId,_that.type,_that.timesPerDay,_that.times,_that.specificDays,_that.intervalHours,_that.timezoneMode,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String medicationId,  ScheduleType type,  int timesPerDay,  List<String> times,  List<int> specificDays,  int? intervalHours,  TimezoneMode timezoneMode,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _Schedule():
return $default(_that.id,_that.medicationId,_that.type,_that.timesPerDay,_that.times,_that.specificDays,_that.intervalHours,_that.timezoneMode,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String medicationId,  ScheduleType type,  int timesPerDay,  List<String> times,  List<int> specificDays,  int? intervalHours,  TimezoneMode timezoneMode,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _Schedule() when $default != null:
return $default(_that.id,_that.medicationId,_that.type,_that.timesPerDay,_that.times,_that.specificDays,_that.intervalHours,_that.timezoneMode,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Schedule implements Schedule {
  const _Schedule({required this.id, required this.medicationId, required this.type, this.timesPerDay = 1, final  List<String> times = const [], final  List<int> specificDays = const [], this.intervalHours, this.timezoneMode = TimezoneMode.fixedInterval, this.isActive = true}): _times = times,_specificDays = specificDays;
  factory _Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);

@override final  String id;
@override final  String medicationId;
@override final  ScheduleType type;
@override@JsonKey() final  int timesPerDay;
 final  List<String> _times;
@override@JsonKey() List<String> get times {
  if (_times is EqualUnmodifiableListView) return _times;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_times);
}

 final  List<int> _specificDays;
@override@JsonKey() List<int> get specificDays {
  if (_specificDays is EqualUnmodifiableListView) return _specificDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_specificDays);
}

@override final  int? intervalHours;
@override@JsonKey() final  TimezoneMode timezoneMode;
@override@JsonKey() final  bool isActive;

/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleCopyWith<_Schedule> get copyWith => __$ScheduleCopyWithImpl<_Schedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Schedule&&(identical(other.id, id) || other.id == id)&&(identical(other.medicationId, medicationId) || other.medicationId == medicationId)&&(identical(other.type, type) || other.type == type)&&(identical(other.timesPerDay, timesPerDay) || other.timesPerDay == timesPerDay)&&const DeepCollectionEquality().equals(other._times, _times)&&const DeepCollectionEquality().equals(other._specificDays, _specificDays)&&(identical(other.intervalHours, intervalHours) || other.intervalHours == intervalHours)&&(identical(other.timezoneMode, timezoneMode) || other.timezoneMode == timezoneMode)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,medicationId,type,timesPerDay,const DeepCollectionEquality().hash(_times),const DeepCollectionEquality().hash(_specificDays),intervalHours,timezoneMode,isActive);

@override
String toString() {
  return 'Schedule(id: $id, medicationId: $medicationId, type: $type, timesPerDay: $timesPerDay, times: $times, specificDays: $specificDays, intervalHours: $intervalHours, timezoneMode: $timezoneMode, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ScheduleCopyWith<$Res> implements $ScheduleCopyWith<$Res> {
  factory _$ScheduleCopyWith(_Schedule value, $Res Function(_Schedule) _then) = __$ScheduleCopyWithImpl;
@override @useResult
$Res call({
 String id, String medicationId, ScheduleType type, int timesPerDay, List<String> times, List<int> specificDays, int? intervalHours, TimezoneMode timezoneMode, bool isActive
});




}
/// @nodoc
class __$ScheduleCopyWithImpl<$Res>
    implements _$ScheduleCopyWith<$Res> {
  __$ScheduleCopyWithImpl(this._self, this._then);

  final _Schedule _self;
  final $Res Function(_Schedule) _then;

/// Create a copy of Schedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? medicationId = null,Object? type = null,Object? timesPerDay = null,Object? times = null,Object? specificDays = null,Object? intervalHours = freezed,Object? timezoneMode = null,Object? isActive = null,}) {
  return _then(_Schedule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,medicationId: null == medicationId ? _self.medicationId : medicationId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ScheduleType,timesPerDay: null == timesPerDay ? _self.timesPerDay : timesPerDay // ignore: cast_nullable_to_non_nullable
as int,times: null == times ? _self._times : times // ignore: cast_nullable_to_non_nullable
as List<String>,specificDays: null == specificDays ? _self._specificDays : specificDays // ignore: cast_nullable_to_non_nullable
as List<int>,intervalHours: freezed == intervalHours ? _self.intervalHours : intervalHours // ignore: cast_nullable_to_non_nullable
as int?,timezoneMode: null == timezoneMode ? _self.timezoneMode : timezoneMode // ignore: cast_nullable_to_non_nullable
as TimezoneMode,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
