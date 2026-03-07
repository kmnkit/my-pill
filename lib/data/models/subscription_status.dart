import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_status.freezed.dart';
part 'subscription_status.g.dart';

enum SubscriptionPlatform { none, appStore, playStore }

@freezed
abstract class SubscriptionStatus with _$SubscriptionStatus {
  const factory SubscriptionStatus({
    @Default(false) bool isPremium,
    @Default(false) bool isOnTrial,
    String? productId,
    DateTime? expiresAt,
    DateTime? trialEndsAt,
    @Default(SubscriptionPlatform.none) SubscriptionPlatform platform,
  }) = _SubscriptionStatus;

  factory SubscriptionStatus.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionStatusFromJson(json);
}
