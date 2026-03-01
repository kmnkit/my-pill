import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:kusuridoki/presentation/screens/travel/widgets/timezone_picker.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  setUpAll(() {
    tz_data.initializeTimeZones();
  });

  group('TimezonePicker', () {
    testWidgets('shows bottom sheet with search field', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showTimezonePicker(context),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Search field should be present
      expect(find.byType(TextField), findsOneWidget);
      // Title
      expect(find.text('Select Destination Timezone'), findsOneWidget);
    });

    testWidgets('filters timezones by search query', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showTimezonePicker(context),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Type "Tokyo" in the search field
      await tester.enterText(find.byType(TextField), 'Tokyo');
      await tester.pumpAndSettle();

      // Should find Tokyo in the list
      expect(find.textContaining('Tokyo'), findsWidgets);
    });

    testWidgets('shows no results message for non-existent timezone',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showTimezonePicker(context),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'xyznonexistent');
      await tester.pumpAndSettle();

      // Should show "No timezones found" (reuses onboardingTimezoneNoResults)
      expect(find.text('No timezones found'), findsOneWidget);
    });

    testWidgets('tapping a timezone item returns its name', (tester) async {
      String? selectedTimezone;

      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                selectedTimezone = await showTimezonePicker(context);
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Search for a specific timezone to narrow the list
      await tester.enterText(find.byType(TextField), 'Tokyo');
      await tester.pumpAndSettle();

      // Tap the ListTile containing Tokyo (not just the Text widget)
      final tokyoListTile = find.ancestor(
        of: find.textContaining('Tokyo'),
        matching: find.byType(ListTile),
      ).first;
      await tester.tap(tokyoListTile);
      await tester.pumpAndSettle();

      expect(selectedTimezone, equals('Asia/Tokyo'));
    });
  });
}
