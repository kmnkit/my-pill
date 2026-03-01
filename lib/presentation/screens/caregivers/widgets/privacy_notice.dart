import 'package:flutter/material.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_card.dart';

class PrivacyNotice extends StatelessWidget {
  const PrivacyNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return KdCard(
      color: AppColors.info.withValues(alpha: 0.1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock, size: AppSpacing.iconMd, color: AppColors.info),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.privacyNotice1,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.appColors.textMuted,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.privacyNotice2,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.appColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
