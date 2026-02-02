import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/adherence_provider.dart';
import 'package:my_pill/data/providers/interstitial_provider.dart';
import 'package:my_pill/presentation/screens/adherence/widgets/adherence_chart.dart';
import 'package:my_pill/presentation/screens/adherence/widgets/medication_breakdown.dart';
import 'package:my_pill/presentation/screens/adherence/widgets/overall_score.dart';
import 'package:my_pill/presentation/shared/widgets/mp_app_bar.dart';

class WeeklySummaryScreen extends ConsumerStatefulWidget {
  const WeeklySummaryScreen({super.key});

  @override
  ConsumerState<WeeklySummaryScreen> createState() => _WeeklySummaryScreenState();
}

class _WeeklySummaryScreenState extends ConsumerState<WeeklySummaryScreen> {
  @override
  void initState() {
    super.initState();
    // Record screen entry as an action and maybe show interstitial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(interstitialControllerProvider).recordAction();
      ref.read(maybeShowInterstitialProvider.future);
    });
  }

  @override
  Widget build(BuildContext context) {
    final overallAdherenceAsync = ref.watch(overallAdherenceProvider);
    final weeklyAdherenceAsync = ref.watch(weeklyAdherenceProvider);

    return Scaffold(
      appBar: const MpAppBar(
        title: 'Weekly Summary',
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            overallAdherenceAsync.when(
              data: (adherence) => OverallScore(
                percentage: (adherence * 100).round(),
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
              error: (error, _) => const OverallScore(percentage: 0),
            ),
            const SizedBox(height: AppSpacing.lg),
            weeklyAdherenceAsync.when(
              data: (weeklyData) => AdherenceChart(weeklyData: weeklyData),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
              error: (error, _) => AdherenceChart(weeklyData: const {}),
            ),
            const SizedBox(height: AppSpacing.lg),
            ref.watch(medicationBreakdownProvider).when(
              data: (medications) => MedicationBreakdown(medications: medications),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
              error: (error, _) => MedicationBreakdown(medications: const []),
            ),
          ],
        ),
      ),
    );
  }
}
