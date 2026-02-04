import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';

class OverallScore extends StatelessWidget {
  const OverallScore({
    super.key,
    required this.percentage,
  });

  /// Percentage as an integer (0-100), or null if no data available.
  final int? percentage;

  String get _rating {
    if (percentage == null) return 'No Data';
    if (percentage! >= 90) return 'Excellent';
    if (percentage! >= 75) return 'Good';
    if (percentage! >= 60) return 'Fair';
    return 'Needs Improvement';
  }

  String get _message {
    if (percentage == null) return 'Start tracking your medications to see your adherence score.';
    if (percentage! >= 90) return 'Keep up the great work! Your consistency is impressive.';
    if (percentage! >= 75) return 'You\'re doing well! A few missed doses here and there.';
    if (percentage! >= 60) return 'Room for improvement. Try setting more reminders.';
    return 'Let\'s work on building a consistent routine together.';
  }

  @override
  Widget build(BuildContext context) {
    final displayText = percentage != null ? '$percentage%' : '--';

    return MpCard(
      child: Column(
        children: [
          Text(
            displayText,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: percentage != null ? AppColors.primary : AppColors.textMuted,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _rating,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            _message,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
