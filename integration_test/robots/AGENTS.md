<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-03-01 | Updated: 2026-03-01 -->

# robots — Robot Pattern Helpers

## Purpose
Robot pattern helpers that encapsulate screen interactions for integration tests. Each robot corresponds to a screen or feature area and exposes fluent-style methods for interactions and assertions.

## For AI Agents

### Working In This Directory
- Each robot class wraps a screen's interactions (tap, enter text, scroll, verify)
- Robot methods should return `this` for fluent chaining
- Robots use `WidgetTester` internally — pass via constructor
- Finder keys: prefer `Key('widget_key')` over text finders for stability

### Common Pattern
```dart
class HomeRobot {
  HomeRobot(this.tester);
  final WidgetTester tester;

  Future<HomeRobot> verifyMedicationVisible(String name) async {
    expect(find.text(name), findsOneWidget);
    return this;
  }
}
```

### Naming Convention
- File: `{screen}_robot.dart`
- Class: `{Screen}Robot`

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
