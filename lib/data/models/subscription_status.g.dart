// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubscriptionStatus _$SubscriptionStatusFromJson(Map<String, dynamic> json) =>
    _SubscriptionStatus(
      isPremium: json['isPremium'] as bool? ?? false,
      productId: json['productId'] as String?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      platform:
          $enumDecodeNullable(
            _$SubscriptionPlatformEnumMap,
            json['platform'],
          ) ??
          SubscriptionPlatform.none,
    );

Map<String, dynamic> _$SubscriptionStatusToJson(_SubscriptionStatus instance) =>
    <String, dynamic>{
      'isPremium': instance.isPremium,
      'productId': instance.productId,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'platform': _$SubscriptionPlatformEnumMap[instance.platform]!,
    };

const _$SubscriptionPlatformEnumMap = {
  SubscriptionPlatform.none: 'none',
  SubscriptionPlatform.appStore: 'appStore',
  SubscriptionPlatform.playStore: 'playStore',
};
