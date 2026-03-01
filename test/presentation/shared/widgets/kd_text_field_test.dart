import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_text_field.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('KdTextField', () {
    testWidgets('renders hint text', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(const KdTextField(hint: 'Enter name')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Enter name'), findsOneWidget);
    });

    testWidgets('renders label text when provided', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const KdTextField(label: 'Name', hint: 'Enter name'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);
    });

    testWidgets('onChanged fires when text is entered', (tester) async {
      String? changed;
      await tester.pumpWidget(
        createTestableWidget(
          KdTextField(hint: 'Type here', onChanged: (v) => changed = v),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'hello');
      await tester.pumpAndSettle();

      expect(changed, 'hello');
    });

    testWidgets('prefixIcon shows when provided', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const KdTextField(hint: 'Search', prefixIcon: Icons.search),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('controller drives initial text', (tester) async {
      final controller = TextEditingController(text: 'initial');
      await tester.pumpWidget(
        createTestableWidget(
          KdTextField(controller: controller, hint: 'placeholder'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('initial'), findsOneWidget);
      controller.dispose();
    });

    testWidgets('no prefixIcon when not provided', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(const KdTextField(hint: 'No icon')),
      );
      await tester.pumpAndSettle();

      // Verify no prefix icon widget is rendered
      expect(find.byType(Icon), findsNothing);
    });
  });
}
