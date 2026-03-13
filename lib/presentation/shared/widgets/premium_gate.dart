import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';

/// Inline premium upsell widget
///
/// Displays a compact upsell message within a list or form.
class PremiumInlineUpsell extends StatelessWidget {
  final String message;
  final VoidCallback? onTap;

  const PremiumInlineUpsell({super.key, required this.message, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.workspace_premium,
            color: AppColors.warning,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(message, style: theme.textTheme.bodyMedium)),
          const SizedBox(width: AppSpacing.sm),
          TextButton(
            onPressed: onTap ?? () => context.push('/premium'),
            child: Text(
              l10n.tryPremium,
              style: const TextStyle(
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
