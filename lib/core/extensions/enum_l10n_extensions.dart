import 'package:my_pill/data/enums/dosage_timing.dart';
import 'package:my_pill/data/enums/dosage_unit.dart';
import 'package:my_pill/data/enums/pill_color.dart';
import 'package:my_pill/data/enums/pill_shape.dart';
import 'package:my_pill/data/enums/schedule_type.dart';
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

extension PillColorL10n on PillColor {
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case PillColor.white:
        return l10n.colorWhite;
      case PillColor.blue:
        return l10n.colorBlue;
      case PillColor.yellow:
        return l10n.colorYellow;
      case PillColor.pink:
        return l10n.colorPink;
      case PillColor.red:
        return l10n.colorRed;
      case PillColor.green:
        return l10n.colorGreen;
      case PillColor.orange:
        return l10n.colorOrange;
      case PillColor.purple:
        return l10n.colorPurple;
    }
  }
}

extension ScheduleTypeL10n on ScheduleType {
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case ScheduleType.daily:
        return l10n.scheduleTypeDaily;
      case ScheduleType.specificDays:
        return l10n.scheduleTypeSpecificDays;
      case ScheduleType.interval:
        return l10n.scheduleTypeInterval;
    }
  }
}

extension DosageTimingL10n on DosageTiming {
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case DosageTiming.beforeMeal:
        return l10n.dosageTimingBeforeMeal;
      case DosageTiming.afterMeal:
        return l10n.dosageTimingAfterMeal;
      case DosageTiming.betweenMeals:
        return l10n.dosageTimingBetweenMeals;
      case DosageTiming.atBedtime:
        return l10n.dosageTimingAtBedtime;
      case DosageTiming.onWaking:
        return l10n.dosageTimingOnWaking;
      case DosageTiming.asNeeded:
        return l10n.dosageTimingAsNeeded;
    }
  }
}
