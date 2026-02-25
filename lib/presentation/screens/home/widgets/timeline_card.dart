import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/core/theme/app_colors_extension.dart';
import 'package:my_pill/data/enums/pill_color.dart';
import 'package:my_pill/data/enums/pill_shape.dart';
import 'package:my_pill/data/enums/reminder_status.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/shared/widgets/mp_badge.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';
import 'package:my_pill/presentation/shared/widgets/mp_pill_icon.dart';

class TimelineCard extends StatelessWidget {
  const TimelineCard({
    super.key,
    required this.medicationName,
    required this.dosage,
    required this.time,
    required this.badgeVariant,
    required this.badgeLabel,
    required this.pillShape,
    required this.pillColor,
    required this.medicationId,
    required this.reminderStatus,
    this.onMarkTaken,
    this.dosageTimingLabel,
  });

  final String medicationName;
  final String dosage;
  final String time;
  final MpBadgeVariant badgeVariant;
  final String badgeLabel;
  final PillShape pillShape;
  final PillColor pillColor;
  final String medicationId;
  final ReminderStatus reminderStatus;
  final VoidCallback? onMarkTaken;
  final String? dosageTimingLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      label: '$medicationName, $time, $badgeLabel',
      child: MpCard(
        onTap: () => context.push('/medications/$medicationId'),
        child: Row(
          children: [
            // Pill icon
            MpPillIcon(
              shape: pillShape,
              color: pillColor,
              size: AppSpacing.iconLg,
            ),
            const SizedBox(width: AppSpacing.md),

            // Medication info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicationName,
                    style: textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    dosage,
                    style: textTheme.bodySmall?.copyWith(color: context.appColors.textMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Time and badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  dosageTimingLabel != null ? '$time $dosageTimingLabel' : time,
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                MpBadge(
                  label: badgeLabel,
                  variant: badgeVariant,
                ),
              ],
            ),

            // Inline mark-as-taken button for pending reminders
            if (reminderStatus == ReminderStatus.pending && onMarkTaken != null) ...[
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  onMarkTaken?.call();
                },
                icon: const Icon(Icons.check_circle_outline),
                color: AppColors.primary,
                tooltip: l10n.markAsTaken,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              ),
            ] else if (reminderStatus == ReminderStatus.taken) ...[
              const SizedBox(width: AppSpacing.sm),
              Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 24,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
