import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_card.dart';

class AdherenceChart extends StatelessWidget {
  /// Weekly adherence data: weekday number ('1'-'7') -> percentage (0-100), null if no data for that day.
  final Map<String, double?> weeklyData;

  const AdherenceChart({super.key, required this.weeklyData});

  List<String> _dayLabels(AppLocalizations l10n) {
    return [
      l10n.mon,
      l10n.tue,
      l10n.wed,
      l10n.thu,
      l10n.fri,
      l10n.sat,
      l10n.sun,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localizedDayLabels = _dayLabels(l10n);

    // Convert Map<String, double?> to ordered lists based on weekday keys
    final entries = weeklyData.entries.toList();
    final dayLabels = entries.map((e) {
      final weekday = int.tryParse(e.key);
      if (weekday != null && weekday >= 1 && weekday <= 7) {
        return localizedDayLabels[weekday - 1];
      }
      return e.key;
    }).toList();
    final percentages = entries.map((e) => e.value).toList();

    return KdCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.thisWeek, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xxl),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      // Reserve enough height for large accessibility text
                      reservedSize: MediaQuery.textScalerOf(context).scale(32),
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < dayLabels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.sm),
                            child: SizedBox(
                              width: 32,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  dayLabels[value.toInt()],
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: context.appColors.textMuted,
                                      ),
                                ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(percentages.length, (index) {
                  final takenValue = percentages.elementAt(index);

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: 100,
                        width: 24,
                        rodStackItems: takenValue != null
                            ? [
                                BarChartRodStackItem(
                                  0,
                                  takenValue,
                                  AppColors.primary,
                                ),
                                BarChartRodStackItem(
                                  takenValue,
                                  100,
                                  AppColors.error,
                                ),
                              ]
                            : [
                                // Gray bar for no data
                                BarChartRodStackItem(0, 100, AppColors.info),
                              ],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppSpacing.radiusSm),
                          topRight: Radius.circular(AppSpacing.radiusSm),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.xl,
            runSpacing: AppSpacing.sm,
            children: [
              _LegendItem(color: AppColors.primary, label: l10n.taken),
              _LegendItem(color: AppColors.error, label: l10n.missed),
              _LegendItem(color: AppColors.info, label: l10n.noData),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: context.appColors.textMuted),
        ),
      ],
    );
  }
}
