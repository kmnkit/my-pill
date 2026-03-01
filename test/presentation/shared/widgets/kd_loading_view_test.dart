import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_loading_view.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('KdLoadingView', () {
    testWidgets('renders CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(createTestableWidget(const KdLoadingView()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders without message by default', (tester) async {
      await tester.pumpWidget(createTestableWidget(const KdLoadingView()));
      await tester.pump();

      // No text widget should be present
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('renders optional message when provided', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(const KdLoadingView(message: 'Loading...')),
      );
      await tester.pump();

      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('is centered on screen', (tester) async {
      await tester.pumpWidget(createTestableWidget(const KdLoadingView()));
      await tester.pump();

      expect(find.byType(Center), findsAtLeastNWidgets(1));
    });
  });
}
