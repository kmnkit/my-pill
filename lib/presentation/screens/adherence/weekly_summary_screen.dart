import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/data/providers/adherence_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/screens/adherence/widgets/adherence_chart.dart';
import 'package:kusuridoki/presentation/screens/adherence/widgets/medication_breakdown.dart';
import 'package:kusuridoki/presentation/screens/adherence/widgets/overall_score.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_app_bar.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_shimmer.dart';
import 'package:kusuridoki/presentation/shared/widgets/gradient_scaffold.dart';

class WeeklySummaryScreen extends ConsumerStatefulWidget {
  const WeeklySummaryScreen({super.key});

  @override
  ConsumerState<WeeklySummaryScreen> createState() =>
      _WeeklySummaryScreenState();
}

class _WeeklySummaryScreenState extends ConsumerState<WeeklySummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final overallAdherenceAsync = ref.watch(overallAdherenceProvider);
    final weeklyAdherenceAsync = ref.watch(weeklyAdherenceProvider);
    final l10n = AppLocalizations.of(context)!;

    return GradientScaffold(
      appBar: KdAppBar(title: l10n.weeklySummary, showBack: true),
      body: Builder(
        builder: (context) {
          final bottomPadding = MediaQuery.of(context).padding.bottom;
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.navBarClearance + bottomPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                overallAdherenceAsync.when(
                  data: (adherence) => OverallScore(
                    percentage: adherence != null
                        ? (adherence * 100).round()
                        : null,
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: KdShimmerBox(height: 120),
                  ),
                  error: (error, _) => const OverallScore(percentage: null),
                ),
                const SizedBox(height: AppSpacing.lg),
                weeklyAdherenceAsync.when(
                  data: (weeklyData) =>
                      AdherenceChart(weeklyData: weeklyData),
                  loading: () => const Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: KdShimmerBox(height: 200),
                  ),
                  error: (error, _) =>
                      AdherenceChart(weeklyData: const {}),
                ),
                const SizedBox(height: AppSpacing.lg),
                ref
                    .watch(medicationBreakdownProvider)
                    .when(
                      data: (medications) =>
                          MedicationBreakdown(medications: medications),
                      loading: () => const Padding(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        child: KdListShimmer(itemCount: 3, itemHeight: 56),
                      ),
                      error: (error, _) =>
                          MedicationBreakdown(medications: const []),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}
