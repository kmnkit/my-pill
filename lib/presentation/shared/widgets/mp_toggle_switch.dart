import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';

class MpToggleSwitch extends StatelessWidget {
  const MpToggleSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final toggle = Semantics(
      toggled: value,
      label: label ?? 'Toggle switch',
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 50,
          height: 28,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: value ? AppColors.primary : AppColors.info,
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            alignment: value ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    if (label != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ExcludeSemantics(
            child: Text(label!, style: Theme.of(context).textTheme.bodyMedium),
          ),
          toggle,
        ],
      );
    }

    return toggle;
  }
}
