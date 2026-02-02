import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/enums/timezone_mode.dart';

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
    return (
      enabled: false,
      mode: TimezoneMode.fixedInterval,
      homeTimezone: 'America/New_York',
      currentTimezone: 'America/New_York',
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
