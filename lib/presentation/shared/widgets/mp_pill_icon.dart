import 'package:flutter/material.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/extensions/enum_l10n_extensions.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';

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
    final iconWidget = Icon(shape.icon, color: color.color, size: size);

    final label = shape == PillShape.packet
        ? l10n.dosePackIcon
        : l10n.medicationIconLabel(
            shape.localizedName(l10n),
            color.localizedName(l10n),
          );

    final isLightColor = color.color.computeLuminance() > 0.7;

    return Semantics(
      label: label,
      child: Container(
        width: size + 12,
        height: size + 12,
        decoration: BoxDecoration(
          color: color.color.withValues(alpha: isLightColor ? 0.25 : 0.15),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: isLightColor
              ? Border.all(color: AppColors.borderLight)
              : null,
        ),
        child: ExcludeSemantics(child: iconWidget),
      ),
    );
  }
}
