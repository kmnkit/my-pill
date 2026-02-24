import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Creates a [ProviderContainer] with common overrides for testing.
///
/// Usage:
/// ```dart
/// final container = createTestContainer(overrides: [...]);
/// addTearDown(container.dispose);
/// ```
ProviderContainer createTestContainer({
  List<dynamic> overrides = const [],
}) {
  return ProviderContainer(overrides: overrides.cast());
}
