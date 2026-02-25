import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/core/theme/app_colors_extension.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';

class OverallScore extends StatelessWidget {
  const OverallScore({
    super.key,
    required this.percentage,
  });

  /// Percentage as an integer (0-100), or null if no data available.
  final int? percentage;

  String _rating(AppLocalizations l10n) {
    if (percentage == null) return l10n.noData;
    if (percentage! >= 95) return l10n.excellent;
    if (percentage! >= 80) return l10n.good;
    if (percentage! >= 50) return l10n.fair;
    return l10n.needsImprovement;
  }

  String _message(AppLocalizations l10n) {
    if (percentage == null) return l10n.startTrackingMessage;
    if (percentage! >= 95) return l10n.excellentMessage;
    if (percentage! >= 80) return l10n.goodMessage;
    if (percentage! >= 50) return l10n.fairMessage;
    return l10n.needsImprovementMessage;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final displayText = percentage != null ? '$percentage%' : '--';

    return MpCard(
      child: Column(
        children: [
          Text(
            displayText,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: percentage != null ? AppColors.primary : context.appColors.textMuted,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _rating(l10n),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            _message(l10n),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.appColors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
