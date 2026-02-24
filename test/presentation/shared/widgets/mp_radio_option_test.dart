import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/presentation/shared/widgets/mp_radio_option.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('MpRadioOption', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          MpRadioOption<int>(
            value: 1,
            groupValue: 2,
            onChanged: (_) {},
            label: 'Option A',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Option A'), findsOneWidget);
    });

    testWidgets('renders description when provided', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          MpRadioOption<int>(
            value: 1,
            groupValue: 2,
            onChanged: (_) {},
            label: 'Option A',
            description: 'Some detail',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Some detail'), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          MpRadioOption<int>(
            value: 1,
            groupValue: 2,
            onChanged: (_) {},
            label: 'Option A',
            icon: Icons.star,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('tap fires onChanged with correct value', (tester) async {
      int? selected;
      await tester.pumpWidget(
        createTestableWidget(
          MpRadioOption<int>(
            value: 42,
            groupValue: 0,
            onChanged: (v) => selected = v,
            label: 'Choose me',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      expect(selected, 42);
    });

    testWidgets('selected state renders when value equals groupValue',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          MpRadioOption<String>(
            value: 'a',
            groupValue: 'a',
            onChanged: (_) {},
            label: 'Selected Option',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Widget renders without error and label is visible
      expect(find.text('Selected Option'), findsOneWidget);
    });
  });
}
