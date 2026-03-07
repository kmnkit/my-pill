import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/data/enums/reminder_status.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_badge.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_card.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_pill_icon.dart';

class TimelineCard extends StatefulWidget {
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
    this.isCritical = false,
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
  final bool isCritical;

  @override
  State<TimelineCard> createState() => _TimelineCardState();
}

class _TimelineCardState extends State<TimelineCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _checkController;
  late final Animation<double> _checkScale;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _checkScale = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );
    if (widget.reminderStatus == ReminderStatus.taken) {
      _checkController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(TimelineCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reminderStatus == ReminderStatus.taken &&
        oldWidget.reminderStatus != ReminderStatus.taken) {
      _checkController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Semantics(
      label: '${widget.medicationName}, ${widget.time}, ${widget.badgeLabel}',
      child: KdCard(
        onTap: () => context.push('/medications/${widget.medicationId}'),
        child: Row(
          children: [
            // Pill icon
            Hero(
              tag: 'medication-pill-${widget.medicationId}',
              child: KdPillIcon(
                shape: widget.pillShape,
                color: widget.pillColor,
                size: AppSpacing.iconLg,
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Medication info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.medicationName,
                          style: textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.isCritical) ...[
                        const SizedBox(width: AppSpacing.xs),
                        Icon(
                          Icons.priority_high,
                          size: 16,
                          color: AppColors.warning,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    widget.dosage,
                    style: textTheme.bodySmall?.copyWith(
                      color: context.appColors.textMuted,
                    ),
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
                  widget.dosageTimingLabel != null
                      ? '${widget.time} ${widget.dosageTimingLabel}'
                      : widget.time,
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                KdBadge(label: widget.badgeLabel, variant: widget.badgeVariant),
              ],
            ),

            // Inline mark-as-taken button for pending reminders
            if (widget.reminderStatus == ReminderStatus.pending &&
                widget.onMarkTaken != null) ...[
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  widget.onMarkTaken?.call();
                },
                icon: const Icon(Icons.check_circle_outline),
                color: AppColors.primary,
                tooltip: l10n.markAsTaken,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              ),
            ] else if (widget.reminderStatus == ReminderStatus.taken) ...[
              const SizedBox(width: AppSpacing.sm),
              ScaleTransition(
                scale: _checkScale,
                child: Icon(Icons.check_circle, color: AppColors.success, size: 24),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
