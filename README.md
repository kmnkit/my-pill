# MyPill - Medication Management App

A comprehensive Flutter application for managing medications, tracking adherence, and coordinating care with caregivers. MyPill combines local-first storage with cloud sync to provide reliable medication reminders and health insights across iOS and Android platforms.

## Features

### Medication Management
- Add and organize medications with detailed information (dosage, shape, color, photo)
- Track medication inventory levels with low-stock alerts
- Store medication history and notes

### Smart Scheduling
- Multiple scheduling modes: daily, specific days of week, or interval-based
- Time-based reminders with customizable intervals
- Timezone-aware travel mode supporting both fixed intervals and local time adjustments

### Reminder System
- Real-time push notifications with take/snooze/skip actions
- Home screen widgets for quick access (iOS and Android)
- Flexible reminder configuration with repeat patterns

### Adherence Tracking
- Automatic tracking of medication adherence
- Weekly adherence reports with visual charts
- Per-medication adherence breakdown
- Overall adherence score

### Caregiver Coordination
- Link caregivers via QR code or deep link
- Real-time adherence monitoring for caregivers
- Secure patient-caregiver relationships

### Localization
- English and Japanese support
- Instant language switching without app restart
- Locale-aware date and time formatting

### Monetization
- AdMob integration for non-intrusive ads
- In-app purchase for ad removal
- Clean, ad-free user experience option

## Tech Stack

- **Framework**: Flutter with Dart 3.10+
- **State Management**: Riverpod 3.x with code generation
- **Data Modeling**: Freezed + json_serializable for immutable models
- **Routing**: GoRouter for declarative navigation
- **Local Storage**: Hive (NoSQL database)
- **Cloud Backend**: Firebase (Auth, Firestore, Cloud Functions, Messaging)
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
