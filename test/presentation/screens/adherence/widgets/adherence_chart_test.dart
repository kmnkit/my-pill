import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/presentation/screens/adherence/widgets/adherence_chart.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  group('AdherenceChart', () {
    const weeklyData = {
      '1': 80.0,
      '2': 60.0,
      '3': null,
      '4': 100.0,
      '5': 50.0,
      '6': 0.0,
      '7': 90.0,
    };

    // ADHCHART-HAPPY-001: 범례 3개 모두 렌더링
    testWidgets('ADHCHART-HAPPY-001: renders taken/missed/noData legend items',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AdherenceChart(weeklyData: weeklyData),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Taken'), findsOneWidget);
      expect(find.text('Missed'), findsOneWidget);
      expect(find.text('No Data'), findsOneWidget);
    });

    // ADHCHART-HAPPY-001b: thisWeek 타이틀 렌더링
    testWidgets('ADHCHART-HAPPY-001b: renders thisWeek title', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AdherenceChart(weeklyData: weeklyData),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('This Week'), findsOneWidget);
    });

    // ADHCHART-EDGE-001: 320px 좁은 화면 — Wrap이 범례를 감싸므로 overflow 없음
    testWidgets('ADHCHART-EDGE-001: renders without overflow at 320px width',
        (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createTestableWidget(
          const AdherenceChart(weeklyData: weeklyData),
        ),
      );
      await tester.pumpAndSettle();

      // Wrap이 사용되므로 overflow 없이 legend가 렌더링돼야 함
      expect(find.byType(AdherenceChart), findsOneWidget);
      expect(find.byType(Wrap), findsOneWidget);
    });

    // ADHCHART-EDGE-002: textScaler 2.0 — FittedBox로 day labels가 컨테이너에 맞춤
    testWidgets(
        'ADHCHART-EDGE-002: renders without overflow at textScaler 2.0',
        (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
          child: createTestableWidget(
            const AdherenceChart(weeklyData: weeklyData),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AdherenceChart), findsOneWidget);
      // Wrap은 여전히 존재해야 함
      expect(find.byType(Wrap), findsOneWidget);
    });

    // ADHCHART-EDGE-003: 빈 데이터 — 위젯이 크래시 없이 렌더링
    testWidgets('ADHCHART-EDGE-003: renders with empty weeklyData', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AdherenceChart(weeklyData: {}),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AdherenceChart), findsOneWidget);
      // 범례는 데이터 없어도 항상 표시
      expect(find.text('Taken'), findsOneWidget);
    });

    // ADHCHART-HAPPY-002: 일본어 로케일 — 범례 텍스트가 l10n으로 렌더링
    testWidgets('ADHCHART-HAPPY-002: renders in Japanese locale', (tester) async {
      await tester.pumpWidget(
        createTestableWidgetJa(
          const AdherenceChart(weeklyData: weeklyData),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AdherenceChart), findsOneWidget);
      // 일본어로도 3개 범례 아이템이 존재해야 함 (_LegendItem × 3)
      expect(find.byType(Row), findsAtLeastNWidgets(3));
    });

    // Wrap alignment center 확인
    testWidgets('legend uses Wrap with center alignment', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AdherenceChart(weeklyData: weeklyData),
        ),
      );
      await tester.pumpAndSettle();

      final wrap = tester.widget<Wrap>(find.byType(Wrap));
      expect(wrap.alignment, equals(WrapAlignment.center));
    });
  });
}
