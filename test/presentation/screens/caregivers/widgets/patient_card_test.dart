import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/presentation/screens/caregivers/widgets/patient_card.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_badge.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  group('PatientCard', () {
    final sampleMedications = [
      {
        'name': 'Aspirin',
        'shape': PillShape.round,
        'color': PillColor.white,
        'status': 'Taken',
        'variant': MpBadgeVariant.taken,
      },
    ];

    // PATCARD-HAPPY-001: 기본 렌더링
    testWidgets('PATCARD-HAPPY-001: renders patient name, initials, adherence',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          PatientCard(
            name: 'Alice',
            initials: 'AL',
            adherence: '90%',
            medications: sampleMedications,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('AL'), findsOneWidget);
      expect(find.textContaining('90%'), findsOneWidget);
    });

    // PATCARD-HAPPY-001b: 약 이름 렌더링
    testWidgets('PATCARD-HAPPY-001b: renders medication name', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          PatientCard(
            name: 'Alice',
            initials: 'AL',
            adherence: '90%',
            medications: sampleMedications,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Aspirin'), findsOneWidget);
    });

    // PATCARD-EDGE-001: 긴 약 이름 — maxLines:1 + ellipsis
    testWidgets('PATCARD-EDGE-001: long medication name is truncated with ellipsis',
        (tester) async {
      final longNameMed = [
        {
          'name': 'Very Long Medication Name That Exceeds Available Width Amlodipine',
          'shape': PillShape.capsule,
          'color': PillColor.red,
          'status': 'Taken',
          'variant': MpBadgeVariant.taken,
        },
      ];

      await tester.pumpWidget(
        createTestableWidget(
          PatientCard(
            name: 'Bob',
            initials: 'BO',
            adherence: '75%',
            medications: longNameMed,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Text 위젯에 maxLines:1 / overflow:ellipsis 설정 확인
      final medNameText = tester.widget<Text>(
        find.text('Very Long Medication Name That Exceeds Available Width Amlodipine'),
      );
      expect(medNameText.maxLines, equals(1));
      expect(medNameText.overflow, equals(TextOverflow.ellipsis));
    });

    // PATCARD-EDGE-002: 320px 좁은 화면 — overflow 없음
    testWidgets('PATCARD-EDGE-002: renders without overflow at 320px', (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createTestableWidget(
          PatientCard(
            name: 'Alice',
            initials: 'AL',
            adherence: '90%',
            medications: sampleMedications,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PatientCard), findsOneWidget);
    });

    // PATCARD-EDGE-003: medications 빈 배열
    testWidgets('PATCARD-EDGE-003: renders with empty medications list',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const PatientCard(
            name: 'Alice',
            initials: 'AL',
            adherence: '100%',
            medications: [],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Alice'), findsOneWidget);
      // 약 이름 없음
      expect(find.text('Aspirin'), findsNothing);
    });

    // 여러 약 렌더링
    testWidgets('renders multiple medications', (tester) async {
      final meds = [
        {
          'name': 'Aspirin',
          'shape': PillShape.round,
          'color': PillColor.white,
          'status': 'Taken',
          'variant': MpBadgeVariant.taken,
        },
        {
          'name': 'Metformin',
          'shape': PillShape.oval,
          'color': PillColor.blue,
          'status': 'Missed',
          'variant': MpBadgeVariant.missed,
        },
      ];

      await tester.pumpWidget(
        createTestableWidget(
          PatientCard(
            name: 'Charlie',
            initials: 'CH',
            adherence: '60%',
            medications: meds,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Aspirin'), findsOneWidget);
      expect(find.text('Metformin'), findsOneWidget);
    });

    // Expanded wrapper — 약 이름이 Expanded 안에 있음
    testWidgets('medication name is inside Expanded widget', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          PatientCard(
            name: 'Alice',
            initials: 'AL',
            adherence: '90%',
            medications: sampleMedications,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Expanded), findsAtLeastNWidgets(1));
    });
  });
}
