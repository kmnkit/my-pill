import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/dosage_timing.dart';
import 'package:kusuridoki/data/models/dosage_time_slot.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/screens/schedule/widgets/dosage_time_adjuster.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_time_picker.dart';

Widget buildTestWidget({
  required List<DosageTimeSlot> slots,
  required ValueChanged<List<DosageTimeSlot>> onSlotsChanged,
}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: Scaffold(
      body: SingleChildScrollView(
        child: DosageTimeAdjuster(slots: slots, onSlotsChanged: onSlotsChanged),
      ),
    ),
  );
}

void main() {
  group('DosageTimeAdjuster', () {
    testWidgets('renders nothing when slots is empty', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(slots: [], onSlotsChanged: (_) {}),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MpTimePicker), findsNothing);
    });

    testWidgets('renders one row per DosageTimeSlot', (tester) async {
      final slots = [
        DosageTimeSlot.withDefault(DosageTiming.morning),
        DosageTimeSlot.withDefault(DosageTiming.evening),
      ];

      await tester.pumpWidget(
        buildTestWidget(slots: slots, onSlotsChanged: (_) {}),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MpTimePicker), findsNWidgets(2));
    });

    testWidgets('shows timing label for each slot', (tester) async {
      final slots = [DosageTimeSlot.withDefault(DosageTiming.morning)];

      await tester.pumpWidget(
        buildTestWidget(slots: slots, onSlotsChanged: (_) {}),
      );
      await tester.pumpAndSettle();

      expect(find.text('Morning'), findsOneWidget);
    });

    testWidgets('onSlotsChanged fires when hour changes', (tester) async {
      List<DosageTimeSlot>? result;
      final slots = [DosageTimeSlot.withDefault(DosageTiming.morning)];

      await tester.pumpWidget(
        buildTestWidget(
          slots: slots,
          onSlotsChanged: (updated) => result = updated,
        ),
      );
      await tester.pumpAndSettle();

      // Tap hour up arrow
      final upArrows = find.byIcon(Icons.keyboard_arrow_up);
      await tester.tap(upArrows.first);
      await tester.pump();

      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result!.first.time, '09:00');
    });

    testWidgets('displays range hint text', (tester) async {
      final slots = [DosageTimeSlot.withDefault(DosageTiming.morning)];

      await tester.pumpWidget(
        buildTestWidget(slots: slots, onSlotsChanged: (_) {}),
      );
      await tester.pumpAndSettle();

      // Should show range hint with min/max hours
      // Format: "Morning: 05:00 ~ 10:59"
      expect(find.textContaining('05:00'), findsOneWidget);
      expect(find.textContaining('10:59'), findsOneWidget);
    });

    testWidgets('slots are sorted by timing index', (tester) async {
      final slots = [
        DosageTimeSlot.withDefault(DosageTiming.evening),
        DosageTimeSlot.withDefault(DosageTiming.morning),
      ];

      await tester.pumpWidget(
        buildTestWidget(slots: slots, onSlotsChanged: (_) {}),
      );
      await tester.pumpAndSettle();

      // Morning should appear before Evening due to sorting
      final morningFinder = find.text('Morning');
      final eveningFinder = find.text('Evening');

      expect(morningFinder, findsOneWidget);
      expect(eveningFinder, findsOneWidget);

      // Verify order by checking positions
      final morningPos = tester.getTopLeft(morningFinder);
      final eveningPos = tester.getTopLeft(eveningFinder);
      expect(morningPos.dy, lessThan(eveningPos.dy));
    });
  });
}
