import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_pill_icon.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('KdPillIcon', () {
    testWidgets('renders with round shape', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const KdPillIcon(shape: PillShape.round, color: PillColor.white),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('renders oval shape with Transform.scale', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const KdPillIcon(shape: PillShape.oval, color: PillColor.blue),
        ),
      );
      await tester.pumpAndSettle();

      // Oval shape wraps icon in Transform.scale
      expect(find.byType(Transform), findsWidgets);
    });

    testWidgets('renders packet shape', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const KdPillIcon(shape: PillShape.packet, color: PillColor.orange),
        ),
      );
      await tester.pumpAndSettle();

      // Packet renders without error and contains an Icon
      expect(find.byType(KdPillIcon), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('renders all PillShape values without errors', (tester) async {
      for (final shape in PillShape.values) {
        await tester.pumpWidget(
          createTestableWidget(
            KdPillIcon(shape: shape, color: PillColor.white),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(KdPillIcon), findsOneWidget);
      }
    });

    testWidgets('renders all PillColor values without errors', (tester) async {
      for (final color in PillColor.values) {
        await tester.pumpWidget(
          createTestableWidget(
            KdPillIcon(shape: PillShape.round, color: color),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(KdPillIcon), findsOneWidget);
      }
    });

    testWidgets('uses custom size', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const KdPillIcon(
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
          const KdPillIcon(shape: PillShape.capsule, color: PillColor.red),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets('uses textMuted color for white pill', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const KdPillIcon(shape: PillShape.packet, color: PillColor.white),
        ),
      );
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, AppColors.textMuted);
    });

    testWidgets('uses textMuted color for yellow pill', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const KdPillIcon(shape: PillShape.round, color: PillColor.yellow),
        ),
      );
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, AppColors.textMuted);
    });

    testWidgets('uses original color for dark pill', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const KdPillIcon(shape: PillShape.round, color: PillColor.blue),
        ),
      );
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, PillColor.blue.color);
    });
  });
}
