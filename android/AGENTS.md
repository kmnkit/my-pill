<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-03-01 | Updated: 2026-03-01 -->

# android — Android Platform Code

## Purpose
Android platform-specific configuration, native code, and build files. Contains Gradle build scripts, Android manifest, Kotlin entry point, app icons, and Fastlane deployment configuration.

## Key Files

| File | Description |
|------|-------------|
| `app/build.gradle` | App-level Gradle config — applicationId, minSdk, targetSdk, signing |
| `app/src/main/AndroidManifest.xml` | App manifest — permissions, activities, intent filters |
| `app/src/main/kotlin/.../MainActivity.kt` | Flutter entry point (extends FlutterActivity) |
| `app/src/main/res/values/styles.xml` | App theme styles |
| `app/google-services.json` | Firebase config for Android (not in git) |
| `fastlane/Fastfile` | Fastlane lanes for Android deployment |
| `build.gradle` | Project-level Gradle config |
| `proguard-rules.pro` | R8/ProGuard rules |

## For AI Agents

### Working In This Directory
- **Package name**: `com.ginger.mypill`
- `google-services.json` is required at `app/google-services.json` — obtain from Firebase Console
- After adding Flutter plugins with Android dependencies, run `flutter pub get` (updates Gradle)
- ProGuard rule added: `-dontwarn com.google.android.play.core.**` (required for R8 builds)
- Android icons are in `app/src/main/res/mipmap-*/` — regenerate with `flutter pub run flutter_launcher_icons:main`

### Common Issues
- R8 missing class errors: add `-dontwarn` rules to `proguard-rules.pro`
- Build failures after plugin update: run `flutter clean && flutter pub get`

### CI Notes
- CI generates a stub `google-services.json` with package name `com.gingers.mypill`
- Fastlane handles Play Store deployment via `fastlane supply`

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
