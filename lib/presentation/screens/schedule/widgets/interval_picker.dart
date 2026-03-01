import 'package:flutter/material.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';

class IntervalPicker extends StatefulWidget {
  const IntervalPicker({super.key, this.onIntervalChanged});

  final ValueChanged<int>? onIntervalChanged;

  @override
  State<IntervalPicker> createState() => _IntervalPickerState();
}

class _IntervalPickerState extends State<IntervalPicker> {
  int _interval = 8;
  String _unit = 'hours';
  late final TextEditingController _controller;

  void _notifyParent() {
    final hours = _unit == 'days' ? _interval * 24 : _interval;
    widget.onIntervalChanged?.call(hours);
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _interval.toString());
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifyParent());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
          Text(l10n.every, style: Theme.of(context).textTheme.titleMedium),
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
              controller: _controller,
              onChanged: (value) {
                final parsed = int.tryParse(value);
                if (parsed != null) {
                  setState(() {
                    _interval = parsed;
                    _notifyParent();
                  });
                }
              },
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          DropdownButton<String>(
            value: _unit,
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(value: 'hours', child: Text(l10n.hours)),
              DropdownMenuItem(value: 'days', child: Text(l10n.daysUnit)),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _unit = value;
                  _notifyParent();
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
