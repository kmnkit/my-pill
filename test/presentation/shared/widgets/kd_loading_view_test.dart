import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_loading_view.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('MpLoadingView', () {
    testWidgets('renders CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(createTestableWidget(const MpLoadingView()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders without message by default', (tester) async {
      await tester.pumpWidget(createTestableWidget(const MpLoadingView()));
      await tester.pump();

      // No text widget should be present
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('renders optional message when provided', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(const MpLoadingView(message: 'Loading...')),
      );
      await tester.pump();

      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('is centered on screen', (tester) async {
      await tester.pumpWidget(createTestableWidget(const MpLoadingView()));
      await tester.pump();

      expect(find.byType(Center), findsAtLeastNWidgets(1));
    });
  });
}
