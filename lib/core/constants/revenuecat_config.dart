import 'dart:io' show Platform;

import 'package:kusuridoki/core/constants/env.dart';

abstract final class RevenueCatConfig {
  static String get apiKey =>
      Platform.isIOS ? Env.revenuecatIosApiKey : Env.revenuecatAndroidApiKey;
  static const String entitlementId = 'premium';
}
