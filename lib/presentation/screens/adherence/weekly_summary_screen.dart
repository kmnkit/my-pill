import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
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

class _TrendBadge extends StatelessWidget {
  const _TrendBadge({required this.delta, required this.l10n});

  final int delta;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final (color, icon, label) = switch (delta) {
      > 0 => (
          AppColors.success,
          Icons.arrow_upward,
          l10n.weeklyTrendImproved(delta),
        ),
      < 0 => (
          AppColors.error,
          Icons.arrow_downward,
          l10n.weeklyTrendDeclined(-delta),
        ),
      _ => (AppColors.info, Icons.arrow_forward, l10n.weeklyTrendSame),
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
        ),
      ],
    );
  }
}

class _WeeklySummaryScreenState extends ConsumerState<WeeklySummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final overallAdherenceAsync = ref.watch(overallAdherenceProvider);
    final weeklyAdherenceAsync = ref.watch(weeklyAdherenceProvider);
    final l10n = AppLocalizations.of(context)!;

    return GradientScaffold(
      appBar: KdAppBar(title: l10n.weeklySummary, showBack: false),
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
                ref.watch(weeklyTrendProvider).when(
                  data: (delta) => delta != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: _TrendBadge(delta: delta, l10n: l10n),
                        )
                      : const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
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
