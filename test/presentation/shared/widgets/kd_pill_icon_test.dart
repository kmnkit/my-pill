import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_pill_icon.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('MpPillIcon', () {
    testWidgets('renders with round shape', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpPillIcon(shape: PillShape.round, color: PillColor.white),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('renders oval shape with Transform.scale', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpPillIcon(shape: PillShape.oval, color: PillColor.blue),
        ),
      );
      await tester.pumpAndSettle();

      // Oval shape wraps icon in Transform.scale
      expect(find.byType(Transform), findsWidgets);
    });

    testWidgets('renders packet shape', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpPillIcon(shape: PillShape.packet, color: PillColor.orange),
        ),
      );
      await tester.pumpAndSettle();

      // Packet renders without error and contains an Icon
      expect(find.byType(MpPillIcon), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('renders all PillShape values without errors', (tester) async {
      for (final shape in PillShape.values) {
        await tester.pumpWidget(
          createTestableWidget(
            MpPillIcon(shape: shape, color: PillColor.white),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(MpPillIcon), findsOneWidget);
      }
    });

    testWidgets('renders all PillColor values without errors', (tester) async {
      for (final color in PillColor.values) {
        await tester.pumpWidget(
          createTestableWidget(
            MpPillIcon(shape: PillShape.round, color: color),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(MpPillIcon), findsOneWidget);
      }
    });

    testWidgets('uses custom size', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpPillIcon(
            shape: PillShape.round,
            color: PillColor.blue,
            size: 48.0,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, 48.0);
    });

    testWidgets('has Semantics widget', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpPillIcon(shape: PillShape.capsule, color: PillColor.red),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Semantics), findsWidgets);
    });
  });
}
