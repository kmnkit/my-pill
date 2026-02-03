// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {

 String get id; String? get name; String? get email; String get language; bool get highContrast; String get textSize; bool get notificationsEnabled; bool get criticalAlerts; int get snoozeDuration; bool get travelModeEnabled; String? get homeTimezone; bool get removeAds; bool get usesPrivateEmail;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.language, language) || other.language == language)&&(identical(other.highContrast, highContrast) || other.highContrast == highContrast)&&(identical(other.textSize, textSize) || other.textSize == textSize)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.criticalAlerts, criticalAlerts) || other.criticalAlerts == criticalAlerts)&&(identical(other.snoozeDuration, snoozeDuration) || other.snoozeDuration == snoozeDuration)&&(identical(other.travelModeEnabled, travelModeEnabled) || other.travelModeEnabled == travelModeEnabled)&&(identical(other.homeTimezone, homeTimezone) || other.homeTimezone == homeTimezone)&&(identical(other.removeAds, removeAds) || other.removeAds == removeAds)&&(identical(other.usesPrivateEmail, usesPrivateEmail) || other.usesPrivateEmail == usesPrivateEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,language,highContrast,textSize,notificationsEnabled,criticalAlerts,snoozeDuration,travelModeEnabled,homeTimezone,removeAds,usesPrivateEmail);

@override
String toString() {
  return 'UserProfile(id: $id, name: $name, email: $email, language: $language, highContrast: $highContrast, textSize: $textSize, notificationsEnabled: $notificationsEnabled, criticalAlerts: $criticalAlerts, snoozeDuration: $snoozeDuration, travelModeEnabled: $travelModeEnabled, homeTimezone: $homeTimezone, removeAds: $removeAds, usesPrivateEmail: $usesPrivateEmail)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String id, String? name, String? email, String language, bool highContrast, String textSize, bool notificationsEnabled, bool criticalAlerts, int snoozeDuration, bool travelModeEnabled, String? homeTimezone, bool removeAds, bool usesPrivateEmail
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? email = freezed,Object? language = null,Object? highContrast = null,Object? textSize = null,Object? notificationsEnabled = null,Object? criticalAlerts = null,Object? snoozeDuration = null,Object? travelModeEnabled = null,Object? homeTimezone = freezed,Object? removeAds = null,Object? usesPrivateEmail = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,highContrast: null == highContrast ? _self.highContrast : highContrast // ignore: cast_nullable_to_non_nullable
as bool,textSize: null == textSize ? _self.textSize : textSize // ignore: cast_nullable_to_non_nullable
as String,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,criticalAlerts: null == criticalAlerts ? _self.criticalAlerts : criticalAlerts // ignore: cast_nullable_to_non_nullable
as bool,snoozeDuration: null == snoozeDuration ? _self.snoozeDuration : snoozeDuration // ignore: cast_nullable_to_non_nullable
as int,travelModeEnabled: null == travelModeEnabled ? _self.travelModeEnabled : travelModeEnabled // ignore: cast_nullable_to_non_nullable
as bool,homeTimezone: freezed == homeTimezone ? _self.homeTimezone : homeTimezone // ignore: cast_nullable_to_non_nullable
as String?,removeAds: null == removeAds ? _self.removeAds : removeAds // ignore: cast_nullable_to_non_nullable
as bool,usesPrivateEmail: null == usesPrivateEmail ? _self.usesPrivateEmail : usesPrivateEmail // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? name,  String? email,  String language,  bool highContrast,  String textSize,  bool notificationsEnabled,  bool criticalAlerts,  int snoozeDuration,  bool travelModeEnabled,  String? homeTimezone,  bool removeAds,  bool usesPrivateEmail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.language,_that.highContrast,_that.textSize,_that.notificationsEnabled,_that.criticalAlerts,_that.snoozeDuration,_that.travelModeEnabled,_that.homeTimezone,_that.removeAds,_that.usesPrivateEmail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? name,  String? email,  String language,  bool highContrast,  String textSize,  bool notificationsEnabled,  bool criticalAlerts,  int snoozeDuration,  bool travelModeEnabled,  String? homeTimezone,  bool removeAds,  bool usesPrivateEmail)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.id,_that.name,_that.email,_that.language,_that.highContrast,_that.textSize,_that.notificationsEnabled,_that.criticalAlerts,_that.snoozeDuration,_that.travelModeEnabled,_that.homeTimezone,_that.removeAds,_that.usesPrivateEmail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? name,  String? email,  String language,  bool highContrast,  String textSize,  bool notificationsEnabled,  bool criticalAlerts,  int snoozeDuration,  bool travelModeEnabled,  String? homeTimezone,  bool removeAds,  bool usesPrivateEmail)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.language,_that.highContrast,_that.textSize,_that.notificationsEnabled,_that.criticalAlerts,_that.snoozeDuration,_that.travelModeEnabled,_that.homeTimezone,_that.removeAds,_that.usesPrivateEmail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile implements UserProfile {
  const _UserProfile({required this.id, this.name, this.email, this.language = 'en', this.highContrast = false, this.textSize = 'normal', this.notificationsEnabled = true, this.criticalAlerts = false, this.snoozeDuration = 15, this.travelModeEnabled = false, this.homeTimezone, this.removeAds = false, this.usesPrivateEmail = false});
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override final  String id;
@override final  String? name;
@override final  String? email;
@override@JsonKey() final  String language;
@override@JsonKey() final  bool highContrast;
@override@JsonKey() final  String textSize;
@override@JsonKey() final  bool notificationsEnabled;
@override@JsonKey() final  bool criticalAlerts;
@override@JsonKey() final  int snoozeDuration;
@override@JsonKey() final  bool travelModeEnabled;
@override final  String? homeTimezone;
@override@JsonKey() final  bool removeAds;
@override@JsonKey() final  bool usesPrivateEmail;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.language, language) || other.language == language)&&(identical(other.highContrast, highContrast) || other.highContrast == highContrast)&&(identical(other.textSize, textSize) || other.textSize == textSize)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.criticalAlerts, criticalAlerts) || other.criticalAlerts == criticalAlerts)&&(identical(other.snoozeDuration, snoozeDuration) || other.snoozeDuration == snoozeDuration)&&(identical(other.travelModeEnabled, travelModeEnabled) || other.travelModeEnabled == travelModeEnabled)&&(identical(other.homeTimezone, homeTimezone) || other.homeTimezone == homeTimezone)&&(identical(other.removeAds, removeAds) || other.removeAds == removeAds)&&(identical(other.usesPrivateEmail, usesPrivateEmail) || other.usesPrivateEmail == usesPrivateEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,language,highContrast,textSize,notificationsEnabled,criticalAlerts,snoozeDuration,travelModeEnabled,homeTimezone,removeAds,usesPrivateEmail);

@override
String toString() {
  return 'UserProfile(id: $id, name: $name, email: $email, language: $language, highContrast: $highContrast, textSize: $textSize, notificationsEnabled: $notificationsEnabled, criticalAlerts: $criticalAlerts, snoozeDuration: $snoozeDuration, travelModeEnabled: $travelModeEnabled, homeTimezone: $homeTimezone, removeAds: $removeAds, usesPrivateEmail: $usesPrivateEmail)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String? name, String? email, String language, bool highContrast, String textSize, bool notificationsEnabled, bool criticalAlerts, int snoozeDuration, bool travelModeEnabled, String? homeTimezone, bool removeAds, bool usesPrivateEmail
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? email = freezed,Object? language = null,Object? highContrast = null,Object? textSize = null,Object? notificationsEnabled = null,Object? criticalAlerts = null,Object? snoozeDuration = null,Object? travelModeEnabled = null,Object? homeTimezone = freezed,Object? removeAds = null,Object? usesPrivateEmail = null,}) {
  return _then(_UserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,highContrast: null == highContrast ? _self.highContrast : highContrast // ignore: cast_nullable_to_non_nullable
as bool,textSize: null == textSize ? _self.textSize : textSize // ignore: cast_nullable_to_non_nullable
as String,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,criticalAlerts: null == criticalAlerts ? _self.criticalAlerts : criticalAlerts // ignore: cast_nullable_to_non_nullable
as bool,snoozeDuration: null == snoozeDuration ? _self.snoozeDuration : snoozeDuration // ignore: cast_nullable_to_non_nullable
as int,travelModeEnabled: null == travelModeEnabled ? _self.travelModeEnabled : travelModeEnabled // ignore: cast_nullable_to_non_nullable
as bool,homeTimezone: freezed == homeTimezone ? _self.homeTimezone : homeTimezone // ignore: cast_nullable_to_non_nullable
as String?,removeAds: null == removeAds ? _self.removeAds : removeAds // ignore: cast_nullable_to_non_nullable
as bool,usesPrivateEmail: null == usesPrivateEmail ? _self.usesPrivateEmail : usesPrivateEmail // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
