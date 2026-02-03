import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    String? name,
    String? email,
    @Default('en') String language,
    @Default(false) bool highContrast,
    @Default('normal') String textSize,
    @Default(true) bool notificationsEnabled,
    @Default(false) bool criticalAlerts,
    @Default(15) int snoozeDuration,
    @Default(false) bool travelModeEnabled,
    String? homeTimezone,
    @Default(false) bool removeAds,
    @Default(false) bool usesPrivateEmail,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
