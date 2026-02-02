<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# services — Business Logic & External APIs

## Purpose
Stateless service classes handling business logic, local storage (Hive), cloud sync (Firestore), authentication (Firebase Auth), notifications, timezone conversions, deep linking, home widgets, ads, and in-app purchases.

## Key Files

| File | Description |
|------|-------------|
| `storage_service.dart` | Hive local storage — CRUD for all models |
| `firestore_service.dart` | Firestore cloud sync — mirrors StorageService with real-time streams |
| `auth_service.dart` | Firebase Auth — anonymous, email, Apple sign-in, account linking |
| `notification_service.dart` | Local + push notifications — scheduling, critical reminders, action handlers |
| `reminder_service.dart` | Reminder generation — create/mark/snooze reminders for dates |
| `adherence_service.dart` | Adherence calculations — daily/weekly/overall rates, medication breakdown |
| `timezone_service.dart` | Timezone conversion — time differences, medication time adjustment |
| `deep_link_service.dart` | Deep link handling — caregiver invite URLs (`/invite/{code}`) |
| `home_widget_service.dart` | Native home screen widgets — push medication summary to iOS/Android |
| `ad_service.dart` | Google AdMob — banner ads, interstitials, ad removal |
| `iap_service.dart` | In-app purchases — remove ads purchase and restore |

## For AI Agents

### Working In This Directory
- Services are stateless — injected via Riverpod providers, never instantiate directly
- `StorageService` and `FirestoreService` must maintain API parity
- Auth service supports progressive authentication (anonymous → email/Apple)
- Notification service handles both local and Firebase push notifications

### Testing Requirements
- Mock services with `mockito` when testing repositories/providers
- Test edge cases: empty data, network errors, expired tokens
- `adherence_service.dart` has existing tests in `test/data/services/`

### Common Patterns
- Async methods returning `Future<T>` or `Stream<T>`
- Error handling via try/catch with typed exceptions
- Services receive dependencies via constructor injection

## Dependencies

### Internal
- `data/models/` — All model types
- `data/enums/` — Domain constants

### External
- `hive_flutter` — Local storage
- `cloud_firestore` / `firebase_auth` / `firebase_messaging` — Firebase
- `flutter_local_notifications` — Notifications
- `timezone` — Timezone database
- `app_links` — Deep linking
- `home_widget` — Native widgets
- `google_mobile_ads` — Advertising
- `in_app_purchase` — IAP
- `uuid` — ID generation

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
