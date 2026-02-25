import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/theme/app_colors_extension.dart';
import 'package:my_pill/l10n/app_localizations.dart';

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

  List<String> _shortDays(AppLocalizations l10n) => [
        l10n.dayMondayShort,
        l10n.dayTuesdayShort,
        l10n.dayWednesdayShort,
        l10n.dayThursdayShort,
        l10n.dayFridayShort,
        l10n.daySaturdayShort,
        l10n.daySundayShort,
      ];

  List<String> _fullDays(AppLocalizations l10n) => [
        l10n.dayMonday,
        l10n.dayTuesday,
        l10n.dayWednesday,
        l10n.dayThursday,
        l10n.dayFriday,
        l10n.daySaturday,
        l10n.daySunday,
      ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final shortDays = _shortDays(l10n);
    final fullDays = _fullDays(l10n);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        final dayValue = index + 1; // 1=Mon, 7=Sun (matches DateTime.weekday)
        final isSelected = _selectedDays.contains(dayValue);
        return Semantics(
          button: true,
          selected: isSelected,
          label: fullDays[index],
          child: InkWell(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedDays.remove(dayValue);
                } else {
                  _selectedDays.add(dayValue);
                }
                _notifyParent();
              });
            },
            customBorder: const CircleBorder(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.cardLight,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: ExcludeSemantics(
                child: Text(
                  shortDays[index],
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isSelected ? AppColors.textOnPrimary : context.appColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
