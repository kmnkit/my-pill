import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/data/enums/reminder_status.dart';
import 'package:kusuridoki/presentation/screens/home/widgets/timeline_card.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_badge.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  group('TimelineCard', () {
    Widget buildCard({
      String medicationName = 'Aspirin',
      String dosage = '100mg',
      String time = '8:00 AM',
      MpBadgeVariant badgeVariant = MpBadgeVariant.upcoming,
      String badgeLabel = 'Upcoming',
      PillShape pillShape = PillShape.round,
      PillColor pillColor = PillColor.white,
      String medicationId = 'med-1',
      ReminderStatus reminderStatus = ReminderStatus.pending,
      VoidCallback? onMarkTaken,
    }) {
      return createTestableWidget(
        TimelineCard(
          medicationName: medicationName,
          dosage: dosage,
          time: time,
          badgeVariant: badgeVariant,
          badgeLabel: badgeLabel,
          pillShape: pillShape,
          pillColor: pillColor,
          medicationId: medicationId,
          reminderStatus: reminderStatus,
          onMarkTaken: onMarkTaken,
        ),
      );
    }

    testWidgets('renders medication name and dosage', (tester) async {
      await tester.pumpWidget(
        buildCard(medicationName: 'Aspirin', dosage: '100mg'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Aspirin'), findsOneWidget);
      expect(find.text('100mg'), findsOneWidget);
    });

    testWidgets('renders time', (tester) async {
      await tester.pumpWidget(buildCard(time: '9:30 AM'));
      await tester.pumpAndSettle();

      expect(find.text('9:30 AM'), findsOneWidget);
    });

    testWidgets('renders badge label', (tester) async {
      await tester.pumpWidget(
        buildCard(badgeLabel: 'Taken', badgeVariant: MpBadgeVariant.taken),
      );
      await tester.pumpAndSettle();

      expect(find.text('Taken'), findsOneWidget);
    });

    testWidgets(
      'shows check_circle_outline button when status is pending and onMarkTaken provided',
      (tester) async {
        bool tapped = false;
        await tester.pumpWidget(
          buildCard(
            reminderStatus: ReminderStatus.pending,
            onMarkTaken: () => tapped = true,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);

        await tester.tap(find.byIcon(Icons.check_circle_outline));
        expect(tapped, isTrue);
      },
    );

    testWidgets('does not show mark-taken button when onMarkTaken is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildCard(reminderStatus: ReminderStatus.pending, onMarkTaken: null),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle_outline), findsNothing);
    });

    testWidgets('shows check_circle icon when status is taken', (tester) async {
      await tester.pumpWidget(
        buildCard(
          reminderStatus: ReminderStatus.taken,
          badgeVariant: MpBadgeVariant.taken,
          badgeLabel: 'Taken',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('does not show action icon when status is skipped', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildCard(
          reminderStatus: ReminderStatus.skipped,
          badgeVariant: MpBadgeVariant.missed,
          badgeLabel: 'Skipped',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle_outline), findsNothing);
      expect(find.byIcon(Icons.check_circle), findsNothing);
    });

    testWidgets('does not show action icon when status is missed', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildCard(
          reminderStatus: ReminderStatus.missed,
          badgeVariant: MpBadgeVariant.missed,
          badgeLabel: 'Missed',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle_outline), findsNothing);
      expect(find.byIcon(Icons.check_circle), findsNothing);
    });

    testWidgets('renders with capsule pill shape', (tester) async {
      await tester.pumpWidget(buildCard(pillShape: PillShape.capsule));
      await tester.pumpAndSettle();

      expect(find.text('Aspirin'), findsOneWidget);
    });

    testWidgets('renders with different pill colors', (tester) async {
      for (final color in PillColor.values) {
        await tester.pumpWidget(buildCard(pillColor: color));
        await tester.pumpAndSettle();
        expect(find.text('Aspirin'), findsOneWidget);
      }
    });

    testWidgets('renders snoozed status without action icons', (tester) async {
      await tester.pumpWidget(
        buildCard(
          reminderStatus: ReminderStatus.snoozed,
          badgeVariant: MpBadgeVariant.upcoming,
          badgeLabel: 'Snoozed',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Snoozed'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsNothing);
      expect(find.byIcon(Icons.check_circle), findsNothing);
    });

    testWidgets('truncates long medication name', (tester) async {
      await tester.pumpWidget(
        buildCard(
          medicationName:
              'A Very Long Medication Name That Should Be Truncated',
        ),
      );
      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(
        find.text('A Very Long Medication Name That Should Be Truncated'),
      );
      expect(textWidget.maxLines, equals(1));
      expect(textWidget.overflow, equals(TextOverflow.ellipsis));
    });
  });
}
