import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';

class MpTimePicker extends StatelessWidget {
  const MpTimePicker({
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

  String get _displayHour {
    final h = hour % 12;
    return (h == 0 ? 12 : h).toString().padLeft(2, '0');
  }

  String get _displayMinute => minute.toString().padLeft(2, '0');
  String get _period => hour >= 12 ? 'PM' : 'AM';

  Widget _buildColumn(String value, VoidCallback onUp, VoidCallback onDown) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_up),
          onPressed: onUp,
          color: AppColors.primary,
          constraints: const BoxConstraints(minWidth: AppSpacing.minTapTarget, minHeight: AppSpacing.minTapTarget),
        ),
        Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: onDown,
          color: AppColors.primary,
          constraints: const BoxConstraints(minWidth: AppSpacing.minTapTarget, minHeight: AppSpacing.minTapTarget),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildColumn(_displayHour, () => onHourChanged((hour + 1) % 24), () => onHourChanged((hour - 1 + 24) % 24)),
          const Text(':', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
          _buildColumn(_displayMinute, () => onMinuteChanged((minute + 15) % 60), () => onMinuteChanged((minute - 15 + 60) % 60)),
          const SizedBox(width: AppSpacing.md),
          Text(_period, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }
}
