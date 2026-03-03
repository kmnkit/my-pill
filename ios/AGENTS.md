<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-03-01 | Updated: 2026-03-01 -->

# ios — iOS Platform Code

## Purpose
iOS platform-specific configuration, native code, and deployment files. Contains Xcode project, Info.plist, entitlements, app icons, launch screen, and Fastlane deployment configuration.

## Key Files

| File | Description |
|------|-------------|
| `Runner/Info.plist` | iOS app configuration — permissions, URL schemes, bundle ID |
| `Runner/AppDelegate.swift` | Flutter app delegate — Firebase, notifications init |
| `Runner/Runner.entitlements` | App entitlements — Sign in with Apple, associated domains |
| `Runner/RunnerRelease.entitlements` | Release-specific entitlements |
| `Runner/PrivacyInfo.xcprivacy` | Apple Privacy Manifest (required since iOS 17) |
| `Runner/GoogleService-Info.plist` | Firebase config for iOS (not in git) |
| `Podfile` | CocoaPods dependency spec |
| `fastlane/Fastfile` | Fastlane lanes for iOS deployment |
| `fastlane/Matchfile` | Code signing via Fastlane Match |

## For AI Agents

### Working In This Directory
- **Bundle ID**: `com.ginger.mypill`
- `GoogleService-Info.plist` is required at `ios/Runner/` — obtain from Firebase Console
- After adding Flutter plugins with iOS dependencies: `cd ios && pod install`
- Pod issues: `cd ios && rm -rf Pods Podfile.lock && pod install`

### Permission Strings (Info.plist)
Every `NS*UsageDescription` must explain WHY in Japanese (primary market):
- `NSCameraUsageDescription` — QR scanner for caregiver invites
- `NSPhotoLibraryUsageDescription` — Medication photo selection
- `NSUserNotificationsUsageDescription` — Medication reminders

### Sign in with Apple
- Entitlements: `com.apple.developer.applesignin` must be present
- Xcode: Signing & Capabilities → "Sign in with Apple" required
- Apple Developer: Bundle ID must have Sign in with Apple capability enabled

### CI Notes
- CI generates a stub `GoogleService-Info.plist` with bundle ID `com.ginger.mypill`
- Fastlane Match manages code signing certificates
- Release builds use `RunnerRelease.entitlements`

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
