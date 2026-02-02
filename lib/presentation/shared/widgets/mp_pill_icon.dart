import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/enums/pill_color.dart';
import 'package:my_pill/data/enums/pill_shape.dart';

class MpPillIcon extends StatelessWidget {
  const MpPillIcon({
    super.key,
    required this.shape,
    required this.color,
    this.size = AppSpacing.iconLg,
  });

  final PillShape shape;
  final PillColor color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Medication icon: ${shape.name} ${color.name}',
      child: Container(
        width: size + 12,
        height: size + 12,
        decoration: BoxDecoration(
          color: color.color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: ExcludeSemantics(
          child: Icon(shape.icon, color: color.color, size: size),
        ),
      ),
    );
  }
}
