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

    // Read homeTimezone once at init — no subscription, so profile changes
    // (name, notifications, etc.) don't trigger a full notifier rebuild.
    final initialHomeTimezone =
        ref.read(userSettingsProvider).whenOrNull(
          data: (profile) => profile.homeTimezone,
        ) ??
        deviceTimezone;

    // Listen for profile changes and update homeTimezone in-place, preserving
    // enabled / mode / currentTimezone that the user may have already set.
    ref.listen(userSettingsProvider, (_, next) {
      final nextHomeTimezone = next.asData?.value.homeTimezone;
      if (nextHomeTimezone != null && nextHomeTimezone != state.homeTimezone) {
        state = (
          enabled: state.enabled,
          mode: state.mode,
          homeTimezone: nextHomeTimezone,
          currentTimezone: state.currentTimezone,
        );
      }
    });

    return (
      enabled: false,
      mode: TimezoneMode.fixedInterval,
      homeTimezone: initialHomeTimezone,
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
