import 'package:flutter/material.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';

class MpColorDot extends StatelessWidget {
  const MpColorDot({
    super.key,
    required this.color,
    required this.isSelected,
    required this.onTap,
    this.size = 36,
    this.colorLabel,
  });

  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  final double size;
  final String? colorLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: colorLabel,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.borderLight,
              width: isSelected ? 2.5 : 1,
            ),
          ),
          child: isSelected
              ? Icon(
                  Icons.check,
                  size: size * 0.5,
                  color: color.computeLuminance() > 0.7
                      ? AppColors.primary
                      : Colors.white,
                )
              : null,
        ),
      ),
    );
  }
}
