import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;

import 'package:kusuridoki/core/constants/env.dart';

abstract final class RevenueCatConfig {
  static String get apiKey =>
      defaultTargetPlatform == TargetPlatform.iOS
          ? Env.revenuecatIosApiKey
          : Env.revenuecatAndroidApiKey;
  static const String entitlementId = 'premium';
}
