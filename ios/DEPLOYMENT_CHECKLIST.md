# iOS App Store Deployment Checklist

## Before You Can Build for App Store

### 1. Firebase Setup (Required)

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project (or create one)
3. Click **Add app** > **iOS**
4. Enter Bundle ID: `com.marcoginger.mypill`
5. Download `GoogleService-Info.plist`
6. Place it in `ios/Runner/GoogleService-Info.plist`
7. In Xcode, add the file to Runner target (File > Add Files to "Runner")

**After adding GoogleService-Info.plist:**
- Open the file and find `REVERSED_CLIENT_ID`
- Update `ios/Runner/Info.plist` CFBundleURLSchemes with this value

### 2. Apple Developer Portal Setup (Required)

1. Go to [Certificates, Identifiers & Profiles](https://developer.apple.com/account/resources/identifiers/list)
2. Create App ID with Bundle ID: `com.marcoginger.mypill`
3. Enable capabilities:
   - [x] Sign In with Apple
   - [x] Push Notifications
   - [x] In-App Purchase
   - [x] App Groups (`group.com.marcoginger.mypill`)

4. Create Provisioning Profiles:
   - Development (for TestFlight)
   - Distribution (for App Store)

### 3. AdMob Setup (Required for Ads)

1. Go to [AdMob Console](https://admob.google.com)
2. Add your app (iOS, Bundle ID: `com.marcoginger.mypill`)
3. Create Ad Units:
   - Banner Ad Unit
   - Interstitial Ad Unit
4. Update these files with your Ad Unit IDs:

**ios/Runner/Info.plist:**
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-YOUR_APP_ID~XXXXXXXXXX</string>
```

**lib/data/services/ad_service.dart:**
```dart
static const String _prodBannerAdUnitIdIOS = 'ca-app-pub-YOUR_APP_ID/BANNER_ID';
static const String _prodInterstitialAdUnitIdIOS = 'ca-app-pub-YOUR_APP_ID/INTERSTITIAL_ID';
```

### 4. APNs Setup (Required for Push Notifications)

1. In Apple Developer Portal, go to **Keys**
2. Create a new key with **Apple Push Notifications service (APNs)**
3. Download the .p8 file
4. In Firebase Console > Project Settings > Cloud Messaging
5. Upload the APNs key

### 5. Xcode Configuration

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner target > Signing & Capabilities
3. Select your Team
4. Verify all capabilities are enabled:
   - Sign In with Apple
   - Push Notifications
   - In-App Purchase
   - App Groups

### 6. App Store Connect Setup

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Create new app:
   - Platform: iOS
   - Name: MyPill - Medication Reminder
   - Bundle ID: `com.marcoginger.mypill`
   - SKU: `mypill-ios-2024`

3. Add In-App Purchases:
   | Product ID | Type | Price |
   |------------|------|-------|
   | `remove_ads` | Non-Consumable | $2.99 |
   | `premium_monthly` | Auto-Renewable | $4.99/mo |
   | `premium_yearly` | Auto-Renewable | $39.99/yr |

---

## Files That Need Manual Updates

| File | What to Update |
|------|----------------|
| `ios/Runner/GoogleService-Info.plist` | Download from Firebase |
| `ios/Runner/Info.plist` | Replace `YOUR_REVERSED_CLIENT_ID` with actual value |
| `ios/Runner/Info.plist` | Replace `ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY` with AdMob App ID |
| `lib/data/services/ad_service.dart` | Replace production ad unit IDs |

---

## Build Commands

```bash
# Clean and prepare
flutter clean
rm -rf ios/Pods ios/Podfile.lock
flutter pub get
cd ios && pod install && cd ..

# Analyze code
flutter analyze

# Build for App Store
flutter build ipa --release

# Or use Xcode:
# 1. Open ios/Runner.xcworkspace
# 2. Product > Archive
# 3. Distribute App > App Store Connect
```

---

## Launch Assets Needed

- [ ] Launch screen images (LaunchImage.imageset)
- [ ] App Store screenshots (6.7", 6.5", 5.5")
- [ ] App icon (already in place)
- [ ] Privacy Policy URL
- [ ] Support URL

---

## Pre-Submission Checklist

- [ ] All placeholder IDs replaced with production values
- [ ] GoogleService-Info.plist added
- [ ] `flutter analyze` passes with no errors
- [ ] `flutter build ipa --release` succeeds
- [ ] TestFlight internal testing completed
- [ ] All IAP products tested in Sandbox
- [ ] Privacy Policy hosted and accessible
