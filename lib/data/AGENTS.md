<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# data — Data Layer

## Purpose
Complete data layer following Clean Architecture. Contains enums for domain constants, Freezed immutable models, services for business logic and external API integration, repositories for data access abstraction, and Riverpod providers for state management.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `enums/` | Strongly-typed domain constants — pill shapes, colors, schedule types, etc. (see `enums/AGENTS.md`) |
| `models/` | Freezed immutable data classes with JSON serialization (see `models/AGENTS.md`) |
| `services/` | Business logic and external API integrations — storage, auth, notifications, etc. (see `services/AGENTS.md`) |
| `repositories/` | Data access abstraction with business rules (see `repositories/AGENTS.md`) |
| `providers/` | Riverpod state management providers (see `providers/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- **Dependency flow**: Enums → Models → Services → Repositories → Providers
- Adding a new feature typically requires changes across multiple subdirectories
- Always run `flutter pub run build_runner build --delete-conflicting-outputs` after modifying models or providers
- Never manually edit `.freezed.dart` or `.g.dart` generated files

### Testing Requirements
- Unit test services and repositories in `test/data/`
- Mock services when testing repositories
- Use `ProviderContainer` for testing providers

### Common Patterns
- Models use Freezed for immutability with `copyWith`
- Services are stateless singletons injected via providers
- Repositories wrap services with business rules (UUID generation, cascade deletes)
- Providers use Riverpod code generation (`@riverpod` annotation)

## Dependencies

### Internal
- `core/` — Uses constants and utilities

### External
- `flutter_riverpod` / `riverpod_annotation` — State management
- `freezed_annotation` / `json_annotation` — Model code generation
- `hive_flutter` — Local storage
- `firebase_auth` / `cloud_firestore` — Firebase services
- `uuid` — ID generation

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
