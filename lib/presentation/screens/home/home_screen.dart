import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/services/ad_service.dart';
import 'package:my_pill/presentation/screens/home/widgets/greeting_header.dart';
import 'package:my_pill/presentation/screens/home/widgets/low_stock_banner.dart';
import 'package:my_pill/presentation/screens/home/widgets/medication_timeline.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    try {
      _bannerAd = AdService().getHomeBannerAd();
      if (_bannerAd != null) {
        setState(() {});
      }
    } catch (e) {
      // Graceful failure - app continues without ads
      debugPrint('Failed to load home banner ad: $e');
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GreetingHeader(),
              const SizedBox(height: AppSpacing.xxl),
              const MedicationTimeline(),
              const SizedBox(height: AppSpacing.lg),
              const LowStockBanner(),
              if (_bannerAd != null) ...[
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: SizedBox(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
