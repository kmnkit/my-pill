import 'package:flutter/material.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';

class KdTimePicker extends StatelessWidget {
  const KdTimePicker({
    super.key,
    required this.hour,
    required this.minute,
    required this.onHourChanged,
    required this.onMinuteChanged,
  });

  final int hour;
  final int minute;
  final ValueChanged<int> onHourChanged;
  final ValueChanged<int> onMinuteChanged;

  Widget _buildColumn(String value, VoidCallback onUp, VoidCallback onDown) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_up),
          onPressed: onUp,
          color: AppColors.primary,
          constraints: const BoxConstraints(
            minWidth: AppSpacing.minTapTarget,
            minHeight: AppSpacing.minTapTarget,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        ),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: onDown,
          color: AppColors.primary,
          constraints: const BoxConstraints(
            minWidth: AppSpacing.minTapTarget,
            minHeight: AppSpacing.minTapTarget,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final use24Hour = MediaQuery.of(context).alwaysUse24HourFormat;

    final displayHour = use24Hour
        ? hour.toString().padLeft(2, '0')
        : (hour % 12 == 0 ? 12 : hour % 12).toString().padLeft(2, '0');
    final displayMinute = minute.toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.cardDark
            : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildColumn(
            displayHour,
            () => onHourChanged((hour + 1) % 24),
            () => onHourChanged((hour - 1 + 24) % 24),
          ),
          const Text(
            ':',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          _buildColumn(
            displayMinute,
            () => onMinuteChanged((minute + 15) % 60),
            () => onMinuteChanged((minute - 15 + 60) % 60),
          ),
          if (!use24Hour) ...[
            const SizedBox(width: AppSpacing.md),
            Text(
              hour >= 12
                  ? MaterialLocalizations.of(context).postMeridiemAbbreviation
                  : MaterialLocalizations.of(context).anteMeridiemAbbreviation,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.primary),
            ),
          ],
        ],
      ),
    );
  }
}
