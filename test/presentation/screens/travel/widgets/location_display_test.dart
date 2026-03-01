import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/timezone_mode.dart';
import 'package:kusuridoki/data/providers/timezone_provider.dart';
import 'package:kusuridoki/data/services/timezone_service.dart';
import 'package:kusuridoki/presentation/screens/travel/widgets/location_display.dart';

import '../../../../helpers/widget_test_helpers.dart';

// Fake synchronous Notifier for TimezoneSettings
class _FakeTimezoneSettings extends TimezoneSettings {
  final TimezoneState _state;
  _FakeTimezoneSettings(this._state);

  @override
  TimezoneState build() => _state;
}

const _defaultState = (
  enabled: false,
  mode: TimezoneMode.fixedInterval,
  homeTimezone: 'Asia/Tokyo',
  currentTimezone: 'America/New_York',
);

const _sameTimezoneState = (
  enabled: false,
  mode: TimezoneMode.fixedInterval,
  homeTimezone: 'Asia/Tokyo',
  currentTimezone: 'Asia/Tokyo',
);

List<dynamic> _buildOverrides({TimezoneState state = _defaultState}) {
  return [
    timezoneSettingsProvider.overrideWith(() => _FakeTimezoneSettings(state)),
    timezoneServiceProvider.overrideWith((ref) => TimezoneService()),
  ];
}

void main() {
  setUpAll(() async {
    await TimezoneService.initialize();
  });

  group('LocationDisplay', () {
    testWidgets('renders current location with city name', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LocationDisplay(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // "America/New_York" -> "New York"
      expect(find.textContaining('New York'), findsOneWidget);
    });

    testWidgets('renders home location with city name', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LocationDisplay(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // "Asia/Tokyo" -> "Tokyo"
      expect(find.textContaining('Tokyo'), findsOneWidget);
    });

    testWidgets('displays time difference', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LocationDisplay(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // Time difference should contain "hours"
      expect(find.textContaining('hours'), findsOneWidget);
    });

    testWidgets('extracts city name from timezone string', (tester) async {
      const state = (
        enabled: false,
        mode: TimezoneMode.fixedInterval,
        homeTimezone: 'Europe/London',
        currentTimezone: 'America/Los_Angeles',
      );

      await tester.pumpWidget(
        createTestableWidget(
          const LocationDisplay(),
          overrides: _buildOverrides(state: state),
        ),
      );
      await tester.pumpAndSettle();

      // "Europe/London" -> "London", "America/Los_Angeles" -> "Los Angeles"
      expect(find.textContaining('London'), findsOneWidget);
      expect(find.textContaining('Los Angeles'), findsOneWidget);
    });

    testWidgets('shows location_on and home icons', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LocationDisplay(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.location_on), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('handles same timezone (0 hours diff)', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LocationDisplay(),
          overrides: _buildOverrides(state: _sameTimezoneState),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('+0 hours'), findsOneWidget);
    });

    testWidgets('shows edit button for changing timezone', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LocationDisplay(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('edit button has correct tooltip', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LocationDisplay(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      final iconButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.edit),
      );
      expect(iconButton.tooltip, 'Change Timezone');
    });
  });
}
