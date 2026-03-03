<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-03-01 | Updated: 2026-03-01 -->

# models — Model Tests

## Purpose
Tests for `lib/data/models/` — verifies Freezed model construction, `copyWith`, JSON serialization/deserialization, and equality.

## For AI Agents

### Working In This Directory
- Pure Dart tests — no Flutter/Firebase setup needed
- Test JSON round-trips: `Model.fromJson(model.toJson()) == model`
- Test `copyWith` immutability
- Run: `flutter test test/data/models/`

### Common Pattern
```dart
test('fromJson/toJson round-trip', () {
  final original = Medication(id: '1', name: 'Aspirin', ...);
  final json = original.toJson();
  final restored = Medication.fromJson(json);
  expect(restored, equals(original));
});
```

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
