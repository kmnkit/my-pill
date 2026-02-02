import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';

class IntervalPicker extends StatefulWidget {
  const IntervalPicker({super.key});

  @override
  State<IntervalPicker> createState() => _IntervalPickerState();
}

class _IntervalPickerState extends State<IntervalPicker> {
  int _interval = 8;
  String _unit = 'hours';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Every', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(width: AppSpacing.md),
          Container(
            width: 80,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              controller: TextEditingController(text: _interval.toString()),
              onChanged: (value) {
                final parsed = int.tryParse(value);
                if (parsed != null) {
                  setState(() {
                    _interval = parsed;
                  });
                }
              },
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          DropdownButton<String>(
            value: _unit,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'hours', child: Text('hours')),
              DropdownMenuItem(value: 'days', child: Text('days')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _unit = value;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
