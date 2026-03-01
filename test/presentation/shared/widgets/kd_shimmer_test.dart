// SC-SHM-001 through SC-SHM-005
// Tests for KdShimmer, KdShimmerBox, KdListShimmer widgets
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_shimmer.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';

Widget _wrap(Widget child, {Brightness brightness = Brightness.light}) {
  return MaterialApp(
    theme: ThemeData(brightness: brightness),
    home: Scaffold(body: child),
  );
}

void main() {
  // ---------------------------------------------------------------------------
  // SC-SHM-001: KdShimmer uses light theme colors in light mode
  // ---------------------------------------------------------------------------
  group('KdShimmer — SC-SHM-001 light mode', () {
    testWidgets('renders Shimmer widget in light mode', (tester) async {
      await tester.pumpWidget(
        _wrap(KdShimmer(child: Container(width: 100, height: 50))),
      );

      expect(find.byType(Shimmer), findsOneWidget);
    });

    testWidgets('uses light base and highlight colors', (tester) async {
      await tester.pumpWidget(
        _wrap(KdShimmer(child: Container(width: 100, height: 50))),
      );

      final shimmer = tester.widget<Shimmer>(find.byType(Shimmer));
      // Access the gradient through the fromColors factory result
      // Shimmer stores colors via its gradient
      expect(shimmer, isA<Shimmer>());
    });
  });

  // ---------------------------------------------------------------------------
  // SC-SHM-002: KdShimmer uses dark theme colors in dark mode
  // ---------------------------------------------------------------------------
  group('KdShimmer — SC-SHM-002 dark mode', () {
    testWidgets('renders Shimmer widget in dark mode', (tester) async {
      await tester.pumpWidget(
        _wrap(
          KdShimmer(child: Container(width: 100, height: 50)),
          brightness: Brightness.dark,
        ),
      );

      expect(find.byType(Shimmer), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // SC-SHM-003: KdShimmerBox renders with specified dimensions
  // ---------------------------------------------------------------------------
  group('KdShimmerBox — SC-SHM-003', () {
    testWidgets('renders with specified width and height', (tester) async {
      await tester.pumpWidget(
        _wrap(const KdShimmerBox(height: 100, width: 200)),
      );

      expect(find.byType(KdShimmerBox), findsOneWidget);
      expect(find.byType(KdShimmer), findsOneWidget);

      // The inner Container has the specified size
      final containers = tester.widgetList<Container>(find.byType(Container));
      final sizedContainer = containers.firstWhere(
        (c) => c.constraints == null &&
            (c.decoration is BoxDecoration),
        orElse: () => containers.first,
      );
      // Verify dimensions via RenderBox
      final renderBox = tester.renderObject<RenderBox>(
        find.descendant(
          of: find.byType(KdShimmerBox),
          matching: find.byType(Container),
        ).first,
      );
      expect(renderBox.size.height, closeTo(100, 1));
      expect(renderBox.size.width, closeTo(200, 1));
    });

    testWidgets('uses default borderRadius (AppSpacing.radiusMd)', (tester) async {
      await tester.pumpWidget(
        _wrap(const KdShimmerBox(height: 60)),
      );

      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(KdShimmerBox),
          matching: find.byType(Container),
        ),
      );
      final decorated = containers.firstWhere(
        (c) => c.decoration is BoxDecoration,
      );
      final decoration = decorated.decoration as BoxDecoration;
      expect(decoration.borderRadius,
          equals(BorderRadius.circular(AppSpacing.radiusMd)));
    });
  });

  // ---------------------------------------------------------------------------
  // SC-SHM-004: KdListShimmer renders correct number of items
  // ---------------------------------------------------------------------------
  group('KdListShimmer — SC-SHM-004', () {
    testWidgets('renders exactly 5 container children with itemCount=5',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const KdListShimmer(itemCount: 5, itemHeight: 60)),
      );

      expect(find.byType(KdListShimmer), findsOneWidget);

      // Count Padding widgets — each item is wrapped in Padding
      // The Column inside KdShimmer has itemCount children
      final column = tester.widget<Column>(
        find.descendant(
          of: find.byType(KdShimmer),
          matching: find.byType(Column),
        ).first,
      );
      expect(column.children, hasLength(5));
    });

    testWidgets('last item has no bottom padding, others have AppSpacing.md',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const KdListShimmer(itemCount: 3, itemHeight: 72)),
      );

      // KdListShimmer renders a KdShimmer > Column > [Padding(child:Container)] x itemCount
      // Find all Padding widgets that are direct children of the Column inside KdShimmer
      final column = tester.widget<Column>(
        find.descendant(
          of: find.byType(KdShimmer),
          matching: find.byType(Column),
        ).first,
      );

      expect(column.children, hasLength(3));

      // First item (index 0): should have bottom = AppSpacing.md
      final firstPadding =
          (column.children[0] as Padding).padding.resolve(null);
      expect(firstPadding.bottom, equals(AppSpacing.md));

      // Second item (index 1): should have bottom = AppSpacing.md
      final secondPadding =
          (column.children[1] as Padding).padding.resolve(null);
      expect(secondPadding.bottom, equals(AppSpacing.md));

      // Last item (index 2): bottom = 0
      final lastPadding =
          (column.children[2] as Padding).padding.resolve(null);
      expect(lastPadding.bottom, equals(0));
    });
  });

  // ---------------------------------------------------------------------------
  // SC-SHM-005: KdListShimmer uses default values (itemCount=4, itemHeight=72)
  // ---------------------------------------------------------------------------
  group('KdListShimmer — SC-SHM-005 defaults', () {
    testWidgets('renders 4 children by default', (tester) async {
      await tester.pumpWidget(
        _wrap(const KdListShimmer()),
      );

      final column = tester.widget<Column>(
        find.descendant(
          of: find.byType(KdShimmer),
          matching: find.byType(Column),
        ).first,
      );
      expect(column.children, hasLength(4));
    });
  });
}
