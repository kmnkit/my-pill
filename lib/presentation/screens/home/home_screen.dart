import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/data/providers/ad_provider.dart';
import 'package:kusuridoki/data/providers/subscription_provider.dart';
import 'package:kusuridoki/presentation/screens/home/widgets/greeting_header.dart';
import 'package:kusuridoki/presentation/screens/home/widgets/low_stock_banner.dart';
import 'package:kusuridoki/presentation/screens/home/widgets/medication_timeline.dart';
import 'package:kusuridoki/presentation/screens/home/widgets/weekly_adherence_summary_card.dart';
import 'package:kusuridoki/presentation/shared/widgets/gradient_scaffold.dart';

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
      _bannerAd = ref.read(adServiceProvider).getHomeBannerAd();
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
    ref.listen<bool>(isPremiumProvider, (previous, isPremium) {
      if (isPremium && _bannerAd != null) {
        setState(() => _bannerAd = null);
      }
    });

    return GradientScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.navBarClearance,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GreetingHeader(),
              const SizedBox(height: AppSpacing.lg),
              const WeeklyAdherenceSummaryCard(),
              const SizedBox(height: AppSpacing.lg),
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
                const SizedBox(height: AppSpacing.lg),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
