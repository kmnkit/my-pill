import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kusuridoki/data/enums/timezone_mode.dart';
import 'package:kusuridoki/data/services/timezone_service.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';

part 'timezone_provider.g.dart';

typedef TimezoneState = ({
  bool enabled,
  TimezoneMode mode,
  String homeTimezone,
  String currentTimezone,
});

@riverpod
class TimezoneSettings extends _$TimezoneSettings {
  @override
  TimezoneState build() {
    final deviceTimezone = TimezoneService().currentLocation.name;

    // Read home timezone from UserProfile (fallback to device timezone)
    final userSettingsAsync = ref.watch(userSettingsProvider);
    final homeTimezone =
        userSettingsAsync.whenOrNull(data: (profile) => profile.homeTimezone) ??
        deviceTimezone;

    return (
      enabled: false,
      mode: TimezoneMode.fixedInterval,
      homeTimezone: homeTimezone,
      currentTimezone: deviceTimezone,
    );
  }

  void toggleEnabled() {
    final current = state;
    state = (
      enabled: !current.enabled,
      mode: current.mode,
      homeTimezone: current.homeTimezone,
      currentTimezone: current.currentTimezone,
    );
  }

  void setMode(TimezoneMode mode) {
    final current = state;
    state = (
      enabled: current.enabled,
      mode: mode,
      homeTimezone: current.homeTimezone,
      currentTimezone: current.currentTimezone,
    );
  }

  void setHomeTimezone(String timezone) {
    final current = state;
    state = (
      enabled: current.enabled,
      mode: current.mode,
      homeTimezone: timezone,
      currentTimezone: current.currentTimezone,
    );
  }

  void setCurrentTimezone(String timezone) {
    final current = state;
    state = (
      enabled: current.enabled,
      mode: current.mode,
      homeTimezone: current.homeTimezone,
      currentTimezone: timezone,
    );
  }
}

@riverpod
TimezoneService timezoneService(Ref ref) => TimezoneService();
