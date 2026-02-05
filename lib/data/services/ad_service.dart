import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._();
  factory AdService() => _instance;
  AdService._();

  bool _initialized = false;
  bool _adsRemoved = false;

  BannerAd? _homeBannerAd;
  BannerAd? _medicationsBannerAd;
  InterstitialAd? _interstitialAd;

  // Test ad unit IDs (Google's official test IDs)
  static const String _testBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';

  // Production ad unit IDs (replace with your actual AdMob ad unit IDs)
  // iOS Banner: ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY
  // iOS Interstitial: ca-app-pub-XXXXXXXXXXXXXXXX/ZZZZZZZZZZ
  // Android Banner: ca-app-pub-XXXXXXXXXXXXXXXX/AAAAAAAAAA
  // Android Interstitial: ca-app-pub-XXXXXXXXXXXXXXXX/BBBBBBBBBB
  static const String _prodBannerAdUnitIdIOS = 'ca-app-pub-8394008055710959/6625781071';
  static const String _prodInterstitialAdUnitIdIOS = 'ca-app-pub-8394008055710959/1832619397';
  static const String _prodBannerAdUnitIdAndroid = 'ca-app-pub-8394008055710959/8841172453';
  static const String _prodInterstitialAdUnitIdAndroid = 'ca-app-pub-8394008055710959/8206456054';

  /// Returns the appropriate banner ad unit ID based on platform and build mode
  static String get _bannerAdUnitId {
    if (kDebugMode) {
      return _testBannerAdUnitId;
    }
    return Platform.isIOS ? _prodBannerAdUnitIdIOS : _prodBannerAdUnitIdAndroid;
  }

  /// Returns the appropriate interstitial ad unit ID based on platform and build mode
  static String get _interstitialAdUnitId {
    if (kDebugMode) {
      return _testInterstitialAdUnitId;
    }
    return Platform.isIOS ? _prodInterstitialAdUnitIdIOS : _prodInterstitialAdUnitIdAndroid;
  }

  bool get adsRemoved => _adsRemoved;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      await MobileAds.instance.initialize();
      _initialized = true;
    } catch (e) {
      debugPrint('AdMob not configured: $e');
    }
  }

  void setAdsRemoved(bool removed) {
    _adsRemoved = removed;
    if (removed) {
      disposeAll();
    }
  }

  // Banner ad for Home screen
  BannerAd? getHomeBannerAd() {
    if (_adsRemoved || !_initialized) return null;
    _homeBannerAd ??= BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          debugPrint('Home banner failed: $error');
          ad.dispose();
          _homeBannerAd = null;
        },
      ),
    )..load();
    return _homeBannerAd;
  }

  // Banner ad for Medications screen
  BannerAd? getMedicationsBannerAd() {
    if (_adsRemoved || !_initialized) return null;
    _medicationsBannerAd ??= BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          debugPrint('Medications banner failed: $error');
          ad.dispose();
          _medicationsBannerAd = null;
        },
      ),
    )..load();
    return _medicationsBannerAd;
  }

  // Load interstitial ad
  Future<void> loadInterstitial() async {
    if (_adsRemoved || !_initialized) return;
    await InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitial(); // Pre-load next one
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial failed: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  // Show interstitial (only after non-critical flows)
  Future<void> showInterstitial() async {
    if (_adsRemoved || _interstitialAd == null) return;
    await _interstitialAd!.show();
  }

  void disposeAll() {
    _homeBannerAd?.dispose();
    _medicationsBannerAd?.dispose();
    _interstitialAd?.dispose();
    _homeBannerAd = null;
    _medicationsBannerAd = null;
    _interstitialAd = null;
  }
}
