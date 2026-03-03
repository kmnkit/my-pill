<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-03-01 | Updated: 2026-03-01 -->

# utils — Integration Test Utilities

## Purpose
Shared utilities for integration tests: app bootstrapping, Firebase mocking, mock service implementations, test data fixtures, and helper functions.

## Key Files

| File | Description |
|------|-------------|
| `test_app.dart` | App entry point for tests — initializes app with mocked providers |
| `mock_services.dart` | In-memory service implementations replacing real Firebase services |
| `test_data.dart` | Consistent test fixtures — sample medications, schedules, users |
| `test_helpers.dart` | Utility functions — wait helpers, finder utilities |
| `firebase_test_setup.dart` | Firebase mock initialization for integration tests |

## For AI Agents

### Working In This Directory
- `test_app.dart` should override all Firebase-dependent providers with mocks
- `mock_services.dart` implements the same interfaces as real services — keep in sync
- `test_data.dart` is the single source of truth for test fixture data
- Call `await firebase_test_setup.setupFirebase()` in `setUpAll` for Firebase-dependent tests

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
