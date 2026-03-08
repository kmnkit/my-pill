import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Handles UMP (User Messaging Platform) consent collection.
///
/// Call [initialize] then [showFormIfRequired] before [MobileAds.instance.initialize].
class AdConsentService {
  static final AdConsentService _instance = AdConsentService._();
  factory AdConsentService() => _instance;
  AdConsentService._();

  /// Requests updated consent information from UMP.
  ///
  /// Must be called before [showFormIfRequired].
  Future<void> initialize() async {
    final completer = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      completer.complete,
      (error) => completer.completeError(error.message),
    );
    await completer.future;
  }

  /// Shows the UMP consent form if consent is required.
  ///
  /// Safe to call even when no form is required — returns immediately.
  Future<void> showFormIfRequired() async {
    final completer = Completer<void>();
    ConsentForm.loadAndShowConsentFormIfRequired((formError) {
      if (formError != null) {
        debugPrint('UMP consent form error: ${formError.message}');
      }
      completer.complete();
    });
    await completer.future;
  }

  /// Returns true if the app can request ads (consent obtained or not required).
  Future<bool> get isConsentObtained =>
      ConsentInformation.instance.canRequestAds();
}
