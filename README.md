# MyPill - Medication Management App

A comprehensive Flutter application for managing medications, tracking adherence, and coordinating care with caregivers. MyPill combines local-first storage with cloud sync to provide reliable medication reminders and health insights across iOS and Android platforms.

## Features

### Medication Management
- Add, edit, and organize medications with detailed information (dosage, shape, color, photo)
- Take or upload medication photos (camera/gallery) for easy identification
- Track medication inventory levels with low-stock alerts and in-app inventory updates
- Low stock push notifications triggered automatically when inventory falls below threshold
- Per-medication critical alert toggle for high-priority notifications that bypass Do Not Disturb
- Medication detail screen with real adherence history timeline (last 30 days, 10 most recent)
- Schedule details display showing type, times, active days, and interval information

### Smart Scheduling
- Multiple scheduling modes: daily, specific days of week, or interval-based
- Time-based reminders with customizable intervals
- Timezone-aware travel mode with real timezone data and dual-time display
- Fixed interval (home time) and local time adaptation modes

### Reminder System
- Automatic daily reminder generation from active schedules
- Real-time push notifications with take/snooze/skip actions
- Critical medication alerts with iOS critical interruption level and Android max priority
- Notification actions wire directly to adherence records
- Missed dose auto-detection (1 hour window)
- Home screen widgets with real-time medication status (iOS and Android)
- App lifecycle-aware: reschedules on resume, checks missed on background return

### Adherence Tracking
- Automatic tracking of medication adherence
- Weekly adherence reports with visual charts
- Per-medication adherence breakdown
- Overall adherence score

### Caregiver Coordination
- Link caregivers via QR code or deep link with share options (clipboard, LINE, Email, SMS)
- Secure invite system powered by Firebase Cloud Functions (7-day expiring codes)
- QR scanning with automatic invite code extraction and acceptance
- Server-side caregiver access revocation with bidirectional cleanup
- Caregiver dashboard with patient list and adherence status
- Notification and alert screens for missed doses and low stock
- Caregiver settings with notification preferences

### Settings & Account
- Data sharing preferences with granular toggle controls
- Backup & sync management with manual sync trigger
- Account deactivation with confirmation flow
- Account deletion with double confirmation and full data wipe

### Localization
- English and Japanese support
- Instant language switching without app restart
- Locale-aware date and time formatting

### Monetization
- AdMob banner ads on Home and Medications screens
- In-app purchase for ad removal with restore purchases support
- Clean, ad-free user experience after purchase
- Graceful degradation when ads are unavailable

## Tech Stack

- **Framework**: Flutter with Dart 3.10+
- **State Management**: Riverpod 3.x with code generation
- **Data Modeling**: Freezed + json_serializable for immutable models
- **Routing**: GoRouter for declarative navigation
- **Local Storage**: Hive (NoSQL database)
- **Cloud Backend**: Firebase (Auth, Firestore, Cloud Functions, Cloud Messaging)
- **UI Components**: Flutter Material Design 3
- **Charts & Visualization**: fl_chart
- **QR Code**: qr_flutter + mobile_scanner
- **Typography**: Google Fonts (Lexend)
- **Notifications**: flutter_local_notifications
- **Ads & IAP**: Google Mobile Ads + In-App Purchase
- **Widgets**: home_widget for home screen integration

## Prerequisites

- Flutter SDK 3.10 or higher
- Dart 3.10+
- iOS 12.0+ or Android 6.0+ (API 21+)
- Firebase project configured
- Xcode (for iOS development) or Android Studio

## Getting Started

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/my-pill.git
cd my-pill
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (Riverpod, Freezed, etc.):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Generate localization files:
```bash
flutter gen-l10n
```

### Running the App

```bash
# Run on connected device or emulator
flutter run

# Run with specific target
flutter run -d chrome          # Web
flutter run -d macos           # macOS
flutter run --debug            # Debug mode
flutter run --release          # Release mode
```

### Development Workflow

```bash
# Analyze code for errors and style issues
flutter analyze

# Run all tests
flutter test

# Watch mode for code generation
flutter pub run build_runner watch

# Clean build artifacts
flutter clean
```

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App colors, typography, spacing
│   └── theme/              # App theme configuration
├── data/
│   ├── enums/              # Schedule type, reminder status, dosage unit, etc.
│   ├── models/             # Data classes (Medication, Schedule, Reminder, etc.)
│   ├── providers/          # Riverpod state providers
│   ├── repositories/       # Data access layer
│   └── services/           # Business logic (StorageService, ReminderService, AdherenceService)
├── l10n/                   # Localization files (English, Japanese)
├── presentation/
│   ├── router/             # GoRouter configuration and route names
│   ├── screens/            # Feature screens organized by domain
│   │   ├── home/           # Home screen with medication timeline
│   │   ├── medications/    # Medication list and details
│   │   ├── schedule/       # Scheduling configuration
│   │   ├── adherence/      # Adherence reports and charts
│   │   ├── travel/         # Travel mode for timezone adjustments
│   │   ├── caregivers/     # Caregiver linking and monitoring
│   │   └── settings/       # App settings and preferences
│   └── shared/
│       ├── widgets/        # Reusable UI components (cards, dialogs, etc.)
│       └── dialogs/        # Modal dialogs
└── app.dart                # Main app configuration
```

## Key Architectural Patterns

- **Clean Architecture**: Separation of concerns with layers (presentation, data, core)
- **Repository Pattern**: Abstraction of data sources (local and remote)
- **Provider Pattern**: Riverpod for reactive state management with code generation
- **Immutable Models**: Freezed for type-safe, copy-with capabilities
- **Local-First**: Hive for offline-first capability with Firestore cloud sync

## Build Commands

```bash
# Full build workflow
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter analyze

# Build release APK (Android)
flutter build apk --release

# Build release IPA (iOS)
flutter build ios --release

# Build web version
flutter build web --release
```

## License

This project is licensed under the MIT License. See the LICENSE file for details.
