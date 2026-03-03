<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-03-01 | Updated: 2026-03-01 -->

# helpers — Test Helpers

## Purpose
Shared test utilities used across all test categories. Provides widget test bootstrapping with proper locale and provider setup.

## Key Files

| File | Description |
|------|-------------|
| `widget_test_helpers.dart` | `createTestableWidget` and `createTestableWidgetJa` — wraps widgets in ProviderScope + MaterialApp with EN/JA locale |

## For AI Agents

### Working In This Directory
- `createTestableWidget(widget, {overrides})` — English locale, use for most tests
- `createTestableWidgetJa(widget, {overrides})` — Japanese locale, use for l10n tests
- Both helpers wrap in `ProviderScope` with the given overrides
- Import: `import 'package:kusuridoki/../test/helpers/widget_test_helpers.dart'`

### Usage
```dart
await tester.pumpWidget(
  createTestableWidget(
    const MyScreen(),
    overrides: [myProvider.overrideWithValue(mockValue)],
  ),
);
```

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
