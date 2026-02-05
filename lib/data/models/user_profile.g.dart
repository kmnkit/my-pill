// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  id: json['id'] as String,
  name: json['name'] as String?,
  email: json['email'] as String?,
  language: json['language'] as String? ?? 'en',
  highContrast: json['highContrast'] as bool? ?? false,
  textSize: json['textSize'] as String? ?? 'normal',
  notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
  criticalAlerts: json['criticalAlerts'] as bool? ?? false,
  snoozeDuration: (json['snoozeDuration'] as num?)?.toInt() ?? 15,
  travelModeEnabled: json['travelModeEnabled'] as bool? ?? false,
  homeTimezone: json['homeTimezone'] as String?,
  removeAds: json['removeAds'] as bool? ?? false,
  usesPrivateEmail: json['usesPrivateEmail'] as bool? ?? false,
  onboardingComplete: json['onboardingComplete'] as bool? ?? false,
  userRole: json['userRole'] as String? ?? 'patient',
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'language': instance.language,
      'highContrast': instance.highContrast,
      'textSize': instance.textSize,
      'notificationsEnabled': instance.notificationsEnabled,
      'criticalAlerts': instance.criticalAlerts,
      'snoozeDuration': instance.snoozeDuration,
      'travelModeEnabled': instance.travelModeEnabled,
      'homeTimezone': instance.homeTimezone,
      'removeAds': instance.removeAds,
      'usesPrivateEmail': instance.usesPrivateEmail,
      'onboardingComplete': instance.onboardingComplete,
      'userRole': instance.userRole,
    };
