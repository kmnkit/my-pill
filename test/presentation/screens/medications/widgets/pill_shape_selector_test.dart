import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/screens/medications/widgets/pill_shape_selector.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  Widget buildSelector({
    PillShape selected = PillShape.round,
    ValueChanged<PillShape>? onShapeSelected,
  }) {
    return createTestableWidget(
      PillShapeSelector(
        selectedShape: selected,
        onShapeSelected: onShapeSelected ?? (_) {},
      ),
    );
  }

  group('PillShapeSelector', () {
    // PILLSEL-HAPPY-001: 모든 PillShape 값이 렌더링됨
    testWidgets('PILLSEL-HAPPY-001: renders all PillShape options',
        (tester) async {
      await tester.pumpWidget(buildSelector());
      await tester.pumpAndSettle();

      // PillShape.values = 7개 (round, capsule, oval, square, triangle, hexagon, packet)
      expect(find.byType(InkWell), findsAtLeastNWidgets(7));
    });

    // PILLSEL-HAPPY-002: 선택된 shape에 Semantics selected=true
    testWidgets('PILLSEL-HAPPY-002: selected shape has Semantics selected',
        (tester) async {
      await tester.pumpWidget(buildSelector(selected: PillShape.capsule));
      await tester.pumpAndSettle();

      final semanticsWidgets =
          tester.widgetList<Semantics>(find.byType(Semantics));
      final selectedSemantics = semanticsWidgets
          .where((s) => s.properties.selected == true)
          .toList();
      expect(selectedSemantics, isNotEmpty);
    });

    // PILLSEL-HAPPY-003: 탭 시 콜백 호출
    testWidgets('PILLSEL-HAPPY-003: tapping a shape calls onShapeSelected',
        (tester) async {
      PillShape? tappedShape;
      await tester.pumpWidget(
        buildSelector(
          selected: PillShape.round,
          onShapeSelected: (shape) => tappedShape = shape,
        ),
      );
      await tester.pumpAndSettle();

      // Semantics label로 capsule InkWell 찾기
      await tester.tap(find.byType(InkWell).at(1));
      await tester.pumpAndSettle();

      expect(tappedShape, isNotNull);
    });

    // PILLSEL-EDGE-001: 320px 좁은 화면 — GridView + FittedBox로 overflow 없음
    testWidgets('PILLSEL-EDGE-001: renders without overflow at 320px width',
        (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildSelector());
      await tester.pumpAndSettle();

      expect(find.byType(PillShapeSelector), findsOneWidget);
      // GridView는 shrinkWrap으로 렌더링
      expect(find.byType(GridView), findsOneWidget);
    });

    // PILLSEL-EDGE-002: textScaler 2.0 — FittedBox가 텍스트 축소
    testWidgets(
        'PILLSEL-EDGE-002: renders without overflow at textScaler 2.0',
        (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
          child: buildSelector(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PillShapeSelector), findsOneWidget);
      // FittedBox가 각 셀 텍스트에 적용돼야 함
      expect(find.byType(FittedBox), findsAtLeastNWidgets(7));
    });

    // PILLSEL-EDGE-003: FittedBox.scaleDown fit 확인
    testWidgets('PILLSEL-EDGE-003: FittedBox uses BoxFit.scaleDown',
        (tester) async {
      await tester.pumpWidget(buildSelector());
      await tester.pumpAndSettle();

      final fittedBoxes = tester.widgetList<FittedBox>(find.byType(FittedBox));
      for (final box in fittedBoxes) {
        expect(box.fit, equals(BoxFit.scaleDown));
      }
    });

    // PILLSEL-HAPPY-004: 일본어 로케일 렌더링
    testWidgets('PILLSEL-HAPPY-004: renders in Japanese locale', (tester) async {
      await tester.pumpWidget(
        createTestableWidgetJa(
          PillShapeSelector(
            selectedShape: PillShape.round,
            onShapeSelected: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PillShapeSelector), findsOneWidget);
      // 일본어에서도 GridView가 정상 렌더링
      expect(find.byType(GridView), findsOneWidget);
    });

    // PILLSEL-HAPPY-005: 다크 테마 렌더링
    testWidgets('PILLSEL-HAPPY-005: renders in dark theme', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData.dark(),
            locale: const Locale('en'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: PillShapeSelector(
                selectedShape: PillShape.round,
                onShapeSelected: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PillShapeSelector), findsOneWidget);
    });

    // PILLSEL-EDGE-004: 각 shape 선택 가능 확인
    testWidgets('PILLSEL-EDGE-004: all PillShape values can be set as selected',
        (tester) async {
      for (final shape in PillShape.values) {
        await tester.pumpWidget(buildSelector(selected: shape));
        await tester.pumpAndSettle();
        expect(find.byType(PillShapeSelector), findsOneWidget);
      }
    });
  });
}
