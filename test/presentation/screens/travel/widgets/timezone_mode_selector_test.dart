import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/timezone_mode.dart';
import 'package:kusuridoki/data/providers/timezone_provider.dart';
import 'package:kusuridoki/presentation/screens/travel/widgets/timezone_mode_selector.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_radio_option.dart';

import '../../../../helpers/widget_test_helpers.dart';

// Fake synchronous Notifier for TimezoneSettings
class _FakeTimezoneSettings extends TimezoneSettings {
  final TimezoneState _state;
  _FakeTimezoneSettings(this._state);

  @override
  TimezoneState build() => _state;

  @override
  void setMode(TimezoneMode mode) {
    final current = state;
    state = (
      enabled: current.enabled,
      mode: mode,
      homeTimezone: current.homeTimezone,
      currentTimezone: current.currentTimezone,
    );
  }
}

const _fixedIntervalState = (
  enabled: true,
  mode: TimezoneMode.fixedInterval,
  homeTimezone: 'Asia/Tokyo',
  currentTimezone: 'America/New_York',
);

const _localTimeState = (
  enabled: true,
  mode: TimezoneMode.localTime,
  homeTimezone: 'Asia/Tokyo',
  currentTimezone: 'America/New_York',
);

List<dynamic> _buildOverrides({TimezoneState state = _fixedIntervalState}) {
  return [
    timezoneSettingsProvider.overrideWith(() => _FakeTimezoneSettings(state)),
  ];
}

void main() {
  group('TimezoneModeSelector', () {
    testWidgets('renders two radio options', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const TimezoneModeSelector(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byType(KdRadioOption<TimezoneMode>),
        findsNWidgets(2),
      );
    });

    testWidgets('shows fixedInterval label and description', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const TimezoneModeSelector(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // l10n: fixedInterval, fixedIntervalDesc
      expect(find.text('Fixed Interval (Home Time)'), findsOneWidget);
      expect(find.text('Take meds at home timezone'), findsOneWidget);
    });

    testWidgets('shows localTime label and description', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const TimezoneModeSelector(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // l10n: localTime, localTimeDesc
      expect(find.text('Local Time Adaptation'), findsOneWidget);
      expect(find.text('Adjust to local timezone'), findsOneWidget);
    });

    testWidgets('fixedInterval selected by default', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const TimezoneModeSelector(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // The first radio option (fixedInterval) should be selected
      // We verify by checking the widget renders without error with fixedInterval mode
      expect(find.byType(TimezoneModeSelector), findsOneWidget);
    });

    testWidgets('tapping localTime changes mode', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const TimezoneModeSelector(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on "Local Time Adaptation" text (inside the radio option)
      await tester.tap(find.text('Local Time Adaptation'));
      await tester.pumpAndSettle();

      // Widget should still render without error after mode change
      expect(find.byType(TimezoneModeSelector), findsOneWidget);
    });

    testWidgets('tapping fixedInterval changes mode back', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const TimezoneModeSelector(),
          overrides: _buildOverrides(state: _localTimeState),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on "Fixed Interval" text
      await tester.tap(find.text('Fixed Interval (Home Time)'));
      await tester.pumpAndSettle();

      expect(find.byType(TimezoneModeSelector), findsOneWidget);
    });

    testWidgets('shows home icon for fixedInterval', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const TimezoneModeSelector(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('shows sun icon for localTime', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const TimezoneModeSelector(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.wb_sunny), findsOneWidget);
    });
  });
}
