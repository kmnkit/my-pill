import 'package:flutter/material.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';

class AdherenceBadge extends StatelessWidget {
  const AdherenceBadge({super.key, required this.percentage});

  final int percentage;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: [
          Text(
            '$percentage%',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppLocalizations.of(context)!.adherenceRate,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: context.appColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
