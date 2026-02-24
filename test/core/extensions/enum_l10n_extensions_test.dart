import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/core/extensions/enum_l10n_extensions.dart';
import 'package:my_pill/data/enums/dosage_unit.dart';
import 'package:my_pill/data/enums/pill_color.dart';
import 'package:my_pill/data/enums/pill_shape.dart';
import 'package:my_pill/data/enums/schedule_type.dart';
import 'package:my_pill/l10n/app_localizations.dart';

/// Pumps a minimal widget tree that provides [AppLocalizations] and captures
/// the resolved instance via [onL10n].
Future<void> _pumpWithL10n(
  WidgetTester tester, {
  required void Function(AppLocalizations) onL10n,
  Locale locale = const Locale('en'),
}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          onL10n(AppLocalizations.of(context)!);
          return const SizedBox();
        },
      ),
    ),
  );
}

void main() {
  group('PillShapeL10n', () {
    testWidgets('round returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(PillShape.round.localizedName(l10n), 'Round');
    });

    testWidgets('capsule returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(PillShape.capsule.localizedName(l10n), 'Capsule');
    });

    testWidgets('oval returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(PillShape.oval.localizedName(l10n), 'Oval');
    });

    testWidgets('square returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(PillShape.square.localizedName(l10n), 'Square');
    });

    testWidgets('triangle returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(PillShape.triangle.localizedName(l10n), 'Triangle');
    });

    testWidgets('hexagon returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(PillShape.hexagon.localizedName(l10n), 'Hexagon');
    });

    testWidgets('packet returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(PillShape.packet.localizedName(l10n), 'Packet');
    });

    testWidgets('all PillShape values return non-empty localised names',
        (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      for (final shape in PillShape.values) {
        expect(
          shape.localizedName(l10n),
          isNotEmpty,
          reason: '${shape.name} localizedName should not be empty',
        );
      }
    });
  });

  group('DosageUnitL10n', () {
    testWidgets('mg returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(DosageUnit.mg.localizedName(l10n), 'mg');
    });

    testWidgets('ml returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(DosageUnit.ml.localizedName(l10n), 'ml');
    });

    testWidgets('pills returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(DosageUnit.pills.localizedName(l10n), 'pills');
    });

    testWidgets('units returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(DosageUnit.units.localizedName(l10n), 'units');
    });

    testWidgets('packs returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      // ARB defines "packs" as "pack(s)"
      expect(DosageUnit.packs.localizedName(l10n), 'pack(s)');
    });

    testWidgets('all DosageUnit values return non-empty localised names',
        (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      for (final unit in DosageUnit.values) {
        expect(
          unit.localizedName(l10n),
          isNotEmpty,
          reason: '${unit.name} localizedName should not be empty',
        );
      }
    });
  });

  group('PillColorL10n', () {
    testWidgets('white returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(PillColor.white.localizedName(l10n), 'White');
    });

    testWidgets('blue returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(PillColor.blue.localizedName(l10n), 'Blue');
    });

    testWidgets('yellow returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(PillColor.yellow.localizedName(l10n), 'Yellow');
    });

    testWidgets('pink returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(PillColor.pink.localizedName(l10n), 'Pink');
    });

    testWidgets('red returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(PillColor.red.localizedName(l10n), 'Red');
    });

    testWidgets('green returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(PillColor.green.localizedName(l10n), 'Green');
    });

    testWidgets('orange returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(PillColor.orange.localizedName(l10n), 'Orange');
    });

    testWidgets('purple returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(PillColor.purple.localizedName(l10n), 'Purple');
    });

    testWidgets('all PillColor values return non-empty localised names',
        (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      for (final color in PillColor.values) {
        expect(
          color.localizedName(l10n),
          isNotEmpty,
          reason: '${color.name} localizedName should not be empty',
        );
      }
    });
  });

  group('ScheduleTypeL10n', () {
    testWidgets('daily returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(ScheduleType.daily.localizedName(l10n), 'Daily');
    });

    testWidgets('specificDays returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(ScheduleType.specificDays.localizedName(l10n), 'Specific Days');
    });

    testWidgets('interval returns localised name', (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      expect(ScheduleType.interval.localizedName(l10n), 'Interval');
    });

    testWidgets('all ScheduleType values return non-empty localised names',
        (tester) async {
      late AppLocalizations l10n;
      await _pumpWithL10n(tester, onL10n: (v) => l10n = v);
      for (final type in ScheduleType.values) {
        expect(
          type.localizedName(l10n),
          isNotEmpty,
          reason: '${type.name} localizedName should not be empty',
        );
      }
    });
  });
}
