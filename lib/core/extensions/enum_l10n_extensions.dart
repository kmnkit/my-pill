import 'package:my_pill/data/enums/dosage_unit.dart';
import 'package:my_pill/data/enums/pill_shape.dart';
import 'package:my_pill/l10n/app_localizations.dart';

extension PillShapeL10n on PillShape {
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case PillShape.round:
        return l10n.round;
      case PillShape.capsule:
        return l10n.capsule;
      case PillShape.oval:
        return l10n.oval;
      case PillShape.square:
        return l10n.square;
      case PillShape.triangle:
        return l10n.triangle;
      case PillShape.hexagon:
        return l10n.hexagon;
      case PillShape.packet:
        return l10n.packet;
    }
  }
}

extension DosageUnitL10n on DosageUnit {
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case DosageUnit.mg:
        return l10n.mg;
      case DosageUnit.ml:
        return l10n.ml;
      case DosageUnit.pills:
        return l10n.pills;
      case DosageUnit.units:
        return l10n.units;
      case DosageUnit.packs:
        return l10n.packs;
    }
  }
}
