import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_badge.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('KdBadge', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const KdBadge(label: 'Taken', variant: MpBadgeVariant.taken),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Taken'), findsOneWidget);
    });

    testWidgets('taken variant renders without error', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const KdBadge(label: 'Taken', variant: MpBadgeVariant.taken),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(KdBadge), findsOneWidget);
    });

    testWidgets('missed variant renders without error', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const KdBadge(label: 'Missed', variant: MpBadgeVariant.missed),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Missed'), findsOneWidget);
    });

    testWidgets('lowStock variant renders without error', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const KdBadge(label: 'Low Stock', variant: MpBadgeVariant.lowStock),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Low Stock'), findsOneWidget);
    });

    testWidgets('connected variant renders without error', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const KdBadge(label: 'Connected', variant: MpBadgeVariant.connected),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Connected'), findsOneWidget);
    });

    testWidgets('snoozed variant renders without error', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const KdBadge(label: 'Snoozed', variant: MpBadgeVariant.snoozed),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Snoozed'), findsOneWidget);
    });
  });
}
