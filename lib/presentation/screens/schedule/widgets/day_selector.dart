import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';

class DaySelector extends StatefulWidget {
  const DaySelector({
    super.key,
    this.onDaysChanged,
  });

  final ValueChanged<List<int>>? onDaysChanged;

  @override
  State<DaySelector> createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  final Set<int> _selectedDays = {};

  void _notifyParent() {
    widget.onDaysChanged?.call(_selectedDays.toList()..sort());
  }

  @override
  Widget build(BuildContext context) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        final isSelected = _selectedDays.contains(index);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedDays.remove(index);
              } else {
                _selectedDays.add(index);
              }
              _notifyParent();
            });
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.cardLight,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              days[index],
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isSelected ? AppColors.textOnPrimary : AppColors.textMuted,
              ),
            ),
          ),
        );
      }),
    );
  }
}
