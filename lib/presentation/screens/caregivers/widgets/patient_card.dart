import 'package:flutter/material.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_avatar.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_badge.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_card.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_pill_icon.dart';

class PatientCard extends StatelessWidget {
  const PatientCard({
    super.key,
    required this.name,
    required this.initials,
    required this.adherence,
    required this.medications,
  });

  final String name;
  final String initials;
  final String adherence;
  final List<Map<String, dynamic>> medications;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return KdCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              KdAvatar(initials: initials, size: 48.0),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${l10n.dailyAdherence}: $adherence',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.appColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.lg),
          ...medications.map((med) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Row(
                children: [
                  KdPillIcon(
                    shape: med['shape'] as PillShape,
                    color: med['color'] as PillColor,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      med['name'] as String,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  KdBadge(
                    label: med['status'] as String,
                    variant: med['variant'] as MpBadgeVariant,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
