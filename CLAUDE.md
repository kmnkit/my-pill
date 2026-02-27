# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## App Identity

- **App Name:** Kusuridoki (くすりどき)
- **Package ID:** `com.ginger.mypill`
- **Supported Locales:** English (`en`), Japanese (`ja`)
- **Version:** 1.0.0+1
- **Min Dart SDK:** ^3.10.8

## Session Initialization

**Serena Plugin**: Serena MCP 서버 활성화 확인 (Dart LSP 기반 코드 인텔리전스).

```bash
claude mcp list | grep serena
```

## Build & Development Commands

### Quick Start

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter run
```

### All Commands

```bash
flutter pub get                                                    # Install dependencies
dart run build_runner build --delete-conflicting-outputs            # Code generation (Freezed, Riverpod, JSON)
flutter gen-l10n                                                   # Generate l10n from ARB files
flutter run                                                        # Run app
flutter test                                                       # Run all tests
flutter analyze                                                    # Static analysis
flutter clean && flutter pub get                                   # Clean rebuild
flutter build apk --release                                        # Android build
flutter build ios --release                                        # iOS build (macOS only)
flutter test integration_test/                                     # Integration tests
flutter pub run flutter_launcher_icons:main                        # Regenerate app icons
```

**After modifying models or providers**, run `build_runner`. `.freezed.dart` and `.g.dart` files are auto-generated — never edit manually.

**After modifying ARB files** (`lib/l10n/`), run `flutter gen-l10n`.

## CI/CD

GitHub Actions (`.github/workflows/`):

**ci.yml** — PRs and pushes to main/develop:
- `flutter analyze --fatal-infos`
- `flutter test --coverage`
- Codecov upload
- Android APK build (main push only)
- iOS build (main push only)

**deploy-firebase.yml** — Firebase deployment

## Architecture

Clean Architecture with Riverpod, Freezed, GoRouter.

```
lib/
├── main.dart                    # Entry: Hive init, Firebase init, ProviderScope
├── app.dart                     # MaterialApp.router (themes, l10n, GoRouter)
├── firebase_options.dart        # Firebase config (auto-generated)
├── core/
│   ├── constants/               # AppColors, AppSpacing, AppTypography
│   ├── theme/                   # AppTheme, GlassDecoration
│   ├── utils/                   # ErrorHandler, TimezoneUtils, AppleAuthErrorMessages
│   └── extensions/              # (Dart extension methods)
├── data/
│   ├── enums/                   # PillShape, PillColor, DosageUnit, DosageTiming,
│   │                            # ScheduleType, ReminderStatus, TimezoneMode, AppleAuthError
│   ├── models/                  # Freezed: Medication, Schedule, Reminder, DosageTimeSlot,
│   │                            # AdherenceRecord, Inventory, CaregiverLink,
│   │                            # SubscriptionStatus, UserProfile
│   ├── services/                # Stateless singletons (14 services):
│   │   ├── storage_service      #   Hive local storage
│   │   ├── firestore_service    #   Cloud Firestore sync
│   │   ├── auth_service         #   Firebase Auth (Apple, Google sign-in)
│   │   ├── notification_service #   flutter_local_notifications
│   │   ├── reminder_service     #   Reminder scheduling logic
│   │   ├── adherence_service    #   Adherence tracking/rating
│   │   ├── report_service       #   PDF report generation
│   │   ├── ad_service           #   Google AdMob
│   │   ├── subscription_service #   Premium subscription + IAP management
│   │   ├── review_service       #   In-app review prompts
│   │   ├── cloud_functions_service # Firebase Cloud Functions calls
│   │   ├── deep_link_service    #   app_links handling
│   │   ├── home_widget_service  #   Native home screen widgets
│   │   └── timezone_service     #   Timezone conversion
│   ├── repositories/            # MedicationRepository, ScheduleRepository
│   └── providers/               # @riverpod code-gen (16 files, 37 annotated functions):
│       ├── auth, medication, schedule, reminder, adherence
│       ├── caregiver, caregiver_monitoring, invite
│       ├── ad, subscription
│       ├── home_widget, deep_link, timezone
│       ├── report, settings, storage_service
│       └── (all use AsyncNotifier pattern)
├── l10n/                        # Auto-generated localization (EN/JA)
└── presentation/
    ├── router/                  # GoRouter: AppRouter, RouteNames, AppRouterProvider
    ├── screens/
    │   ├── home/                # HomeScreen + GreetingHeader, LowStockBanner, MedicationTimeline, TimelineCard
    │   ├── medications/         # List, Add, Edit, Detail + PillShapeSelector, PillColorPicker, etc.
    │   ├── schedule/            # ScheduleScreen + DaySelector, FrequencySelector, TimeSlotPicker, etc.
    │   ├── adherence/           # WeeklySummaryScreen + AdherenceChart, OverallScore, MedicationBreakdown, ExportReportButton
    │   ├── settings/            # SettingsScreen + AccountSection, NotificationSettings, LanguageSelector, etc.
    │   ├── caregivers/          # FamilyScreen, CaregiverDashboard, Alerts, Notifications, InviteHandler, QRScanner
    │   ├── onboarding/          # OnboardingScreen (Apple/Google/Anonymous 통합) + 5 steps (Welcome, Name, Role, Timezone, Notification)
    │   ├── premium/             # PremiumUpsellScreen
    │   ├── travel/              # TravelModeScreen + AffectedMedList, LocationDisplay, TimezoneModelSelector
    │   └── splash/              # SplashScreen
    └── shared/
        ├── widgets/             # Mp-prefixed: MpButton, MpCard, MpAppBar, MpAvatar, MpBadge,
        │                        # MpBottomNavBar, MpColorDot, MpEmptyState, MpErrorView,
        │                        # MpLoadingView, MpMedicationCard, MpPillIcon, MpProgressBar,
        │                        # MpRadioOption, MpSectionHeader, MpTextField, MpTimePicker,
        │                        # MpToggleSwitch, GradientScaffold, MpAlertBanner,
        │                        # PremiumBadge, PremiumGate
        └── dialogs/             # MpConfirmDialog, MpReminderDialog, InventoryUpdateDialog
```

### Data Flow

```
Enums → Models → Services → Repositories → Providers → Screens
```

### Dual Storage

`StorageService` (Hive, local-first) + `FirestoreService` (cloud sync) — API parity maintained.

### Navigation

GoRouter with two `StatefulShellRoute.indexedStack` shells:
- **Patient:** `/home`, `/adherence`, `/medications`, `/settings`
- **Caregiver:** `/caregiver/patients`, `/caregiver/notifications`, `/caregiver/alerts`, `/caregiver/settings`
- Additional routes: `/onboarding`, `/schedule`, `/travel`, `/premium`, `/invite` (note: `/login` removed — auth integrated into OnboardingScreen)

### Key Dependencies

| Category | Package |
|----------|---------|
| State | flutter_riverpod, riverpod_annotation |
| Routing | go_router |
| Storage | hive_flutter |
| Firebase | firebase_core, firebase_auth, cloud_firestore, cloud_functions, firebase_messaging |
| Auth | firebase_auth (`signInWithProvider` — Apple, Google) |
| Ads | google_mobile_ads |
| IAP | in_app_purchase |
| Review | in_app_review |
| UI | google_fonts, fl_chart, qr_flutter, mobile_scanner, image_picker |
| PDF | pdf, printing |
| Notifications | flutter_local_notifications |
| Deep Links | app_links |
| Home Widget | home_widget |
| Utilities | intl, timezone, uuid, share_plus, url_launcher, path_provider, collection |
| Security | flutter_secure_storage |
| Code Gen | freezed, freezed_annotation, json_serializable, json_annotation, riverpod_generator, build_runner |

## Key Conventions

- **Imports**: Always `package:my_pill/...`, never relative
- **Models**: Freezed `@freezed` — `copyWith` for mutations, never mutate directly
- **Providers**: `@riverpod` annotation, `AsyncNotifier` pattern, `ref.invalidateSelf()` after mutations
- **Screens**: `ConsumerWidget`/`ConsumerStatefulWidget`, `AsyncValue.when()` for loading/error/data
- **Shared widgets**: `Mp` prefix (e.g., `MpButton`, `MpCard`)
- **Design tokens**: `AppColors`, `AppSpacing`, `AppTypography` from `core/constants/`
- **Localization**: `AppLocalizations.of(context)!.key` — `en`, `ja`
- **Repositories**: `const Uuid().v4()` for IDs, cascade deletes, `updatedAt` timestamps
- **Enums**: Carry UI metadata (labels, icons, colors)

## Firebase Cloud Functions

`functions/index.js` (Node 18):
- `generateInviteLink` — 7-day expiring invite code
- `acceptInvite` — bidirectional link via atomic batch writes
- `revokeAccess` — patient-initiated caregiver removal
- `deleteUserAccount` — server-side account + data deletion (GDPR/App Store compliance)
- `verifyReceipt` — IAP receipt server-side validation
- `cleanupExpiredInvites` — daily scheduled cleanup

Deploy: `firebase deploy --only functions`
Firestore rules: `firebase deploy --only firestore`

## Environment Setup

**Required files (not in git):**
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

**Firebase Emulator:**
```bash
cd functions && npm install
firebase emulators:start --only functions,firestore
```

## Testing

- **Framework**: `mockito` with `@GenerateMocks` (run `build_runner` after adding annotations)
- **Provider testing**: `ProviderContainer` with `overrides`
- **Widget testing**: `ProviderScope` wrapper with mocked providers
- **Current test files**: `test/core/`, `test/data/` (services, repositories), `test/mock_firebase.dart`

## Gotchas

- **build_runner**: Always use `--delete-conflicting-outputs`
- **Hive adapters**: New model → register `TypeAdapter` in `main.dart`
- **iOS permissions**: Add `NS*UsageDescription` to `Info.plist` with reason in target language
- **Android permissions**: Update `AndroidManifest.xml`
- **Riverpod 3.x**: `NotifierProvider` (not `StateNotifier`), no `valueOrNull`
- **Clean rebuild**: `flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs`
- **iOS Pod issues**: `cd ios && rm -rf Pods Podfile.lock && pod install && cd ..`
- **`BuildContext` across async gap**: Use `mounted` check or `ref`

## Documentation

**Core:**
- `docs/product_requirements_document.md` — PRD (English)
- `docs/product_requirements_document_ja.md` — PRD (Japanese)
- `docs/progress.md` — Development progress tracking
- `docs/feedback.md` — User feedback log

**Deployment:**
- `docs/APP_STORE_METADATA.md` — Store listing metadata
- `docs/APP_STORE_PREPARATION.md` — App Store preparation guide
- `docs/iOS_APP_STORE_DEPLOYMENT_GUIDE.md` — iOS deployment steps
- `docs/iOS_DEPLOYMENT_STATUS.md` — iOS deployment status
- `docs/iOS_DEPLOYMENT_FINAL_STATUS.md` — iOS deployment final status

**Marketing:**
- `docs/AD_CREATIVE_STRATEGY.md` — Ad creative strategy
- `docs/ad-campaign-market-research.md` — Ad campaign market research
- `docs/LINE_ADS_EXECUTION_GUIDE.md` — LINE Ads execution guide

**QA/Security:**
- `docs/qa-quality-gate-report.md` — QA quality gate report
- `docs/security-audit-2026-02-23.md` — Security audit results
- `docs/test-scenarios/` — Test scenario documents

**Design & Review:**
- `docs/UI_UX_REVIEW.md` — UI/UX review
- `docs/design_dosage_timing_redesign.md` — Dosage timing redesign spec
- `docs/CONSUMER_PANEL_INSIGHTS.md` — Consumer panel insights
- `docs/CONSUMER_PANEL_INSIGHTS_G2.md` — Consumer panel insights (G2)
- `docs/CONSUMER_PANEL_REVIEW_2026_02.md` — Consumer panel review (Feb 2026)
- `docs/feature-evaluation-ippoka.md` — Feature evaluation (Ippoka)
- `docs/stakeholder-launch-assessment.md` — Stakeholder launch assessment
- `docs/plans/` — Implementation plans

## AGENTS.md Hierarchy

- `AGENTS.md` (root), `lib/AGENTS.md`, `lib/core/AGENTS.md`, `lib/data/AGENTS.md`, `lib/presentation/AGENTS.md`
- `lib/l10n/AGENTS.md`, `assets/AGENTS.md`, `functions/AGENTS.md`, `test/AGENTS.md`, `test/data/AGENTS.md`, `docs/AGENTS.md`
