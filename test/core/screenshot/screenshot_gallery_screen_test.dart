import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/core/screenshot/screenshot_gallery_screen.dart';

void main() {
  group('ScreenshotGalleryScreen', () {
    testWidgets('renders Capture All button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: ScreenshotGalleryScreen()),
        ),
      );
      expect(find.text('Capture All'), findsOneWidget);
    });

    test('has exactly 5 screen configs', () {
      expect(ScreenshotGalleryScreen.screenConfigs.length, 5);
    });

    test('screen config filenames are correct and in order', () {
      final bases =
          ScreenshotGalleryScreen.screenConfigs
              .map((c) => c.filenameBase)
              .toList();
      expect(bases, [
        '01_home',
        '02_medications_list',
        '03_weekly_summary',
        '04_caregiver',
        '05_travel_mode',
      ]);
    });

    test('caregiver config wraps screen in ProviderScope for mock data', () {
      final caregiverConfig = ScreenshotGalleryScreen.screenConfigs.firstWhere(
        (c) => c.filenameBase == '04_caregiver',
      );
      expect(caregiverConfig.screen, isA<ProviderScope>());
    });
  });
}
