// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'caregiver_link.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CaregiverLink {

 String get id; String get patientId; String get caregiverId; String get caregiverName; String get status; DateTime get linkedAt;
/// Create a copy of CaregiverLink
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CaregiverLinkCopyWith<CaregiverLink> get copyWith => _$CaregiverLinkCopyWithImpl<CaregiverLink>(this as CaregiverLink, _$identity);

  /// Serializes this CaregiverLink to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CaregiverLink&&(identical(other.id, id) || other.id == id)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.caregiverId, caregiverId) || other.caregiverId == caregiverId)&&(identical(other.caregiverName, caregiverName) || other.caregiverName == caregiverName)&&(identical(other.status, status) || other.status == status)&&(identical(other.linkedAt, linkedAt) || other.linkedAt == linkedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patientId,caregiverId,caregiverName,status,linkedAt);

@override
String toString() {
  return 'CaregiverLink(id: $id, patientId: $patientId, caregiverId: $caregiverId, caregiverName: $caregiverName, status: $status, linkedAt: $linkedAt)';
}


}

/// @nodoc
abstract mixin class $CaregiverLinkCopyWith<$Res>  {
  factory $CaregiverLinkCopyWith(CaregiverLink value, $Res Function(CaregiverLink) _then) = _$CaregiverLinkCopyWithImpl;
@useResult
$Res call({
 String id, String patientId, String caregiverId, String caregiverName, String status, DateTime linkedAt
});




}
/// @nodoc
class _$CaregiverLinkCopyWithImpl<$Res>
    implements $CaregiverLinkCopyWith<$Res> {
  _$CaregiverLinkCopyWithImpl(this._self, this._then);

  final CaregiverLink _self;
  final $Res Function(CaregiverLink) _then;

/// Create a copy of CaregiverLink
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? patientId = null,Object? caregiverId = null,Object? caregiverName = null,Object? status = null,Object? linkedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,caregiverId: null == caregiverId ? _self.caregiverId : caregiverId // ignore: cast_nullable_to_non_nullable
as String,caregiverName: null == caregiverName ? _self.caregiverName : caregiverName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,linkedAt: null == linkedAt ? _self.linkedAt : linkedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CaregiverLink].
extension CaregiverLinkPatterns on CaregiverLink {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CaregiverLink value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CaregiverLink() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CaregiverLink value)  $default,){
final _that = this;
switch (_that) {
case _CaregiverLink():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CaregiverLink value)?  $default,){
final _that = this;
switch (_that) {
case _CaregiverLink() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String patientId,  String caregiverId,  String caregiverName,  String status,  DateTime linkedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CaregiverLink() when $default != null:
return $default(_that.id,_that.patientId,_that.caregiverId,_that.caregiverName,_that.status,_that.linkedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String patientId,  String caregiverId,  String caregiverName,  String status,  DateTime linkedAt)  $default,) {final _that = this;
switch (_that) {
case _CaregiverLink():
return $default(_that.id,_that.patientId,_that.caregiverId,_that.caregiverName,_that.status,_that.linkedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String patientId,  String caregiverId,  String caregiverName,  String status,  DateTime linkedAt)?  $default,) {final _that = this;
switch (_that) {
case _CaregiverLink() when $default != null:
return $default(_that.id,_that.patientId,_that.caregiverId,_that.caregiverName,_that.status,_that.linkedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CaregiverLink implements CaregiverLink {
  const _CaregiverLink({required this.id, required this.patientId, required this.caregiverId, required this.caregiverName, this.status = 'connected', required this.linkedAt});
  factory _CaregiverLink.fromJson(Map<String, dynamic> json) => _$CaregiverLinkFromJson(json);

@override final  String id;
@override final  String patientId;
@override final  String caregiverId;
@override final  String caregiverName;
@override@JsonKey() final  String status;
@override final  DateTime linkedAt;

/// Create a copy of CaregiverLink
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CaregiverLinkCopyWith<_CaregiverLink> get copyWith => __$CaregiverLinkCopyWithImpl<_CaregiverLink>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CaregiverLinkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CaregiverLink&&(identical(other.id, id) || other.id == id)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.caregiverId, caregiverId) || other.caregiverId == caregiverId)&&(identical(other.caregiverName, caregiverName) || other.caregiverName == caregiverName)&&(identical(other.status, status) || other.status == status)&&(identical(other.linkedAt, linkedAt) || other.linkedAt == linkedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patientId,caregiverId,caregiverName,status,linkedAt);

@override
String toString() {
  return 'CaregiverLink(id: $id, patientId: $patientId, caregiverId: $caregiverId, caregiverName: $caregiverName, status: $status, linkedAt: $linkedAt)';
}


}

/// @nodoc
abstract mixin class _$CaregiverLinkCopyWith<$Res> implements $CaregiverLinkCopyWith<$Res> {
  factory _$CaregiverLinkCopyWith(_CaregiverLink value, $Res Function(_CaregiverLink) _then) = __$CaregiverLinkCopyWithImpl;
@override @useResult
$Res call({
 String id, String patientId, String caregiverId, String caregiverName, String status, DateTime linkedAt
});




}
/// @nodoc
class __$CaregiverLinkCopyWithImpl<$Res>
    implements _$CaregiverLinkCopyWith<$Res> {
  __$CaregiverLinkCopyWithImpl(this._self, this._then);

  final _CaregiverLink _self;
  final $Res Function(_CaregiverLink) _then;

/// Create a copy of CaregiverLink
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? patientId = null,Object? caregiverId = null,Object? caregiverName = null,Object? status = null,Object? linkedAt = null,}) {
  return _then(_CaregiverLink(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as String,caregiverId: null == caregiverId ? _self.caregiverId : caregiverId // ignore: cast_nullable_to_non_nullable
as String,caregiverName: null == caregiverName ? _self.caregiverName : caregiverName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,linkedAt: null == linkedAt ? _self.linkedAt : linkedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
