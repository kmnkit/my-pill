// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_widget_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(homeWidgetUpdater)
final homeWidgetUpdaterProvider = HomeWidgetUpdaterProvider._();

final class HomeWidgetUpdaterProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  HomeWidgetUpdaterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeWidgetUpdaterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeWidgetUpdaterHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return homeWidgetUpdater(ref);
  }
}

String _$homeWidgetUpdaterHash() => r'9dd3e505d92e04c7a13b8b9309009b256e2ecbbf';
