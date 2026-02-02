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

  // Test ad unit IDs (replace with real ones in production)
  static const String _testBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';

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
      adUnitId: _testBannerAdUnitId,
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
      adUnitId: _testBannerAdUnitId,
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
      adUnitId: _testInterstitialAdUnitId,
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
