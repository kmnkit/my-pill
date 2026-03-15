import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/data/enums/reminder_status.dart';
import 'package:kusuridoki/presentation/screens/home/widgets/timeline_card.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_badge.dart';

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
      String? dosageTimingLabel,
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
          dosageTimingLabel: dosageTimingLabel,
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

    // TIMELINE-OVERFLOW-001: 320px 좁은 화면 — Flexible로 overflow 없음
    testWidgets('TIMELINE-OVERFLOW-001: renders without overflow at 320px',
        (tester) async {
      tester.view.physicalSize = const Size(320, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildCard(
          medicationName: 'Acetaminophen Extended Release Tablet',
          time: '11:30 PM',
          dosageTimingLabel: 'After Meal',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TimelineCard), findsOneWidget);
    });

    // TIMELINE-OVERFLOW-002: textScaler 2.0 — overflow 없이 렌더링
    testWidgets('TIMELINE-OVERFLOW-002: renders without overflow at textScaler 2.0',
        (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
          child: buildCard(
            medicationName: 'Metformin',
            time: '8:00 AM',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TimelineCard), findsOneWidget);
    });

    // TIMELINE-OVERFLOW-003: 시간 텍스트에 maxLines/ellipsis 설정 확인
    testWidgets('TIMELINE-OVERFLOW-003: time text has maxLines:1 and ellipsis',
        (tester) async {
      await tester.pumpWidget(buildCard(time: '11:59 PM'));
      await tester.pumpAndSettle();

      final timeText = tester.widget<Text>(find.text('11:59 PM'));
      expect(timeText.maxLines, equals(1));
      expect(timeText.overflow, equals(TextOverflow.ellipsis));
    });

    // TIMELINE-OVERFLOW-004: dosageTimingLabel과 time 합쳐서 렌더링 — Flexible 감싸짐
    testWidgets('TIMELINE-OVERFLOW-004: time+timingLabel renders inside Flexible',
        (tester) async {
      await tester.pumpWidget(
        buildCard(
          time: '8:00 AM',
          dosageTimingLabel: 'After Meal',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('8:00 AM'), findsOneWidget);
      // Flexible이 time 영역을 감쌈
      expect(find.byType(Flexible), findsAtLeastNWidgets(1));
    });
  });
}
