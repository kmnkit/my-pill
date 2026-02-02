import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';

class MpAvatar extends StatelessWidget {
  const MpAvatar({
    super.key,
    required this.initials,
    this.size = 40,
    this.backgroundColor,
  });

  final String initials;
  final double size;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.textOnPrimary,
          fontSize: size * 0.38,
        ),
      ),
    );
  }
}
