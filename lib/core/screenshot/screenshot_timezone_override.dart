import 'package:kusuridoki/data/enums/timezone_mode.dart';
import 'package:kusuridoki/data/providers/timezone_provider.dart';

/// Riverpod override for [timezoneSettingsProvider] used during screenshot
/// capture. Provides a Tokyo→Paris travel mode scenario so TravelModeScreen
/// renders a populated, enabled state without the real device timezone.
final timezoneSettingsOverride = timezoneSettingsProvider.overrideWith(
  () => _ScreenshotTravelTimezone(),
);

class _ScreenshotTravelTimezone extends TimezoneSettings {
  @override
  TimezoneState build() => (
    enabled: true,
    mode: TimezoneMode.fixedInterval,
    homeTimezone: 'Asia/Tokyo',
    currentTimezone: 'Europe/Paris',
  );

  /// No-op: prevent device timezone detection from overwriting the demo state.
  @override
  Future<void> refreshDeviceTimezone() async {}
}
