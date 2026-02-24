import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/core/extensions/enum_l10n_extensions.dart';
import 'package:my_pill/data/enums/pill_color.dart';
import 'package:my_pill/data/enums/pill_shape.dart';
import 'package:my_pill/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    Widget iconWidget = Icon(shape.icon, color: color.color, size: size);

    // Stretch oval horizontally to distinguish from round
    if (shape == PillShape.oval) {
      iconWidget = Transform.scale(
        scaleX: 1.4,
        scaleY: 0.75,
        child: iconWidget,
      );
    }

    final label = shape == PillShape.packet
        ? l10n.dosePackIcon
        : l10n.medicationIconLabel(
            shape.localizedName(l10n),
            color.localizedName(l10n),
          );

    return Semantics(
      label: label,
      child: Container(
        width: size + 12,
        height: size + 12,
        decoration: BoxDecoration(
          color: color.color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: ExcludeSemantics(
          child: iconWidget,
        ),
      ),
    );
  }
}
