import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/core/screenshot/screenshot_caption_overlay.dart';

void main() {
  group('ScreenshotCaptionOverlay', () {
    testWidgets('renders caption text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ScreenshotCaptionOverlay(
            caption: 'Test Caption',
            child: SizedBox.expand(),
          ),
        ),
      );

      expect(find.text('Test Caption'), findsOneWidget);
    });

    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ScreenshotCaptionOverlay(
            caption: 'Caption',
            child: Text('Child Content'),
          ),
        ),
      );

      expect(find.text('Child Content'), findsOneWidget);
    });

    testWidgets('has gradient decoration at the bottom', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ScreenshotCaptionOverlay(
            caption: 'Caption',
            child: SizedBox.expand(),
          ),
        ),
      );

      final decorated = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
      final decoration = decorated.decoration as BoxDecoration;
      final gradient = decoration.gradient as LinearGradient;
      expect(gradient.colors.first, Colors.transparent);
      expect(gradient.colors.last, Colors.black54);
    });
  });
}
