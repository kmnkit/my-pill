import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/presentation/screens/schedule/widgets/day_selector.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  Widget buildSelector({
    List<int> initialDays = const [],
    ValueChanged<List<int>>? onDaysChanged,
  }) {
    return createTestableWidget(
      DaySelector(
        initialDays: initialDays,
        onDaysChanged: onDaysChanged,
      ),
    );
  }

  group('DaySelector', () {
    // DAYSEL-HAPPY-001: 7개 요일 버튼 렌더링
    testWidgets('DAYSEL-HAPPY-001: renders 7 day buttons', (tester) async {
      await tester.pumpWidget(buildSelector());
      await tester.pumpAndSettle();

      // 7개 InkWell (각 요일 버튼)
      expect(find.byType(InkWell), findsNWidgets(7));
    });

    // DAYSEL-HAPPY-002: initialDays로 선택 상태 초기화
    testWidgets('DAYSEL-HAPPY-002: initialDays are pre-selected', (tester) async {
      await tester.pumpWidget(buildSelector(initialDays: [1, 3, 5]));
      await tester.pumpAndSettle();

      // Semantics selected=true인 항목이 3개
      final semanticsWidgets =
          tester.widgetList<Semantics>(find.byType(Semantics));
      final selectedCount =
          semanticsWidgets.where((s) => s.properties.selected == true).length;
      expect(selectedCount, equals(3));
    });

    // DAYSEL-HAPPY-003: 탭 시 선택 상태 토글 및 콜백 호출
    testWidgets('DAYSEL-HAPPY-003: tapping a day toggles selection',
        (tester) async {
      List<int>? lastResult;
      await tester.pumpWidget(
        buildSelector(
          initialDays: const [],
          onDaysChanged: (days) => lastResult = days,
        ),
      );
      await tester.pumpAndSettle();

      // 첫 번째 버튼(월요일=1) 탭
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(lastResult, isNotNull);
      expect(lastResult, contains(1));
    });

    // DAYSEL-HAPPY-004: 이미 선택된 요일 탭 시 제거
    testWidgets('DAYSEL-HAPPY-004: tapping selected day removes it',
        (tester) async {
      List<int>? lastResult;
      await tester.pumpWidget(
        buildSelector(
          initialDays: [1],
          onDaysChanged: (days) => lastResult = days,
        ),
      );
      await tester.pumpAndSettle();

      // 월요일(인덱스 0) 탭 → 이미 선택됨 → 해제
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(lastResult, isNotNull);
      expect(lastResult, isNot(contains(1)));
    });

    // DAYSEL-EDGE-001: 320px 좁은 화면 — Row+FittedBox로 overflow 없음
    testWidgets('DAYSEL-EDGE-001: renders without overflow at 320px width',
        (tester) async {
      tester.view.physicalSize = const Size(320, 200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildSelector());
      await tester.pumpAndSettle();

      expect(find.byType(DaySelector), findsOneWidget);
      // Row가 존재해야 함
      expect(find.byType(Row), findsOneWidget);
    });

    // DAYSEL-EDGE-002: textScaler 2.0 — FittedBox가 텍스트 축소
    testWidgets('DAYSEL-EDGE-002: renders without overflow at textScaler 2.0',
        (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
          child: buildSelector(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DaySelector), findsOneWidget);
      // 각 요일 버튼에 FittedBox 사용 확인
      expect(find.byType(FittedBox), findsAtLeastNWidgets(7));
    });

    // DAYSEL-EDGE-003: FittedBox.scaleDown fit 확인
    testWidgets('DAYSEL-EDGE-003: FittedBox uses BoxFit.scaleDown',
        (tester) async {
      await tester.pumpWidget(buildSelector());
      await tester.pumpAndSettle();

      final fittedBoxes = tester.widgetList<FittedBox>(find.byType(FittedBox));
      for (final box in fittedBoxes) {
        expect(box.fit, equals(BoxFit.scaleDown));
      }
    });

    // DAYSEL-HAPPY-005: 일본어 로케일 — l10n 요일 단축형 렌더링
    testWidgets('DAYSEL-HAPPY-005: renders in Japanese locale', (tester) async {
      await tester.pumpWidget(
        createTestableWidgetJa(
          const DaySelector(initialDays: [1, 7]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DaySelector), findsOneWidget);
      expect(find.byType(InkWell), findsNWidgets(7));
    });

    // DAYSEL-EDGE-004: dayValue는 1(월)~7(일) — 1-indexed 확인
    testWidgets('DAYSEL-EDGE-004: day values are 1-indexed (1=Mon, 7=Sun)',
        (tester) async {
      final receivedValues = <List<int>>[];

      await tester.pumpWidget(
        buildSelector(
          initialDays: const [],
          onDaysChanged: (days) => receivedValues.add(List.from(days)),
        ),
      );
      await tester.pumpAndSettle();

      // 마지막 버튼(일요일=7) 탭
      await tester.tap(find.byType(InkWell).last);
      await tester.pumpAndSettle();

      expect(receivedValues.last, contains(7));
    });

    // DAYSEL-EDGE-005: 모든 요일 선택
    testWidgets('DAYSEL-EDGE-005: all days can be selected', (tester) async {
      List<int>? lastResult;
      await tester.pumpWidget(
        buildSelector(
          initialDays: const [],
          onDaysChanged: (days) => lastResult = days,
        ),
      );
      await tester.pumpAndSettle();

      final buttons = find.byType(InkWell);
      for (int i = 0; i < 7; i++) {
        await tester.tap(buttons.at(i));
        await tester.pumpAndSettle();
      }

      expect(lastResult, isNotNull);
      expect(lastResult!.length, equals(7));
    });

    // DAYSEL-EDGE-006: onDaysChanged가 null이면 탭해도 크래시 없음
    testWidgets('DAYSEL-EDGE-006: no crash when onDaysChanged is null',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(const DaySelector()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(find.byType(DaySelector), findsOneWidget);
    });
  });
}
