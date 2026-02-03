# iOS App Store Deployment Guide

**MyPill v1.0.0** — Complete step-by-step guide for submitting to the App Store.

---

## Executive Summary

This guide consolidates all iOS App Store submission steps for MyPill. The deployment process is divided into 10 phases, with automated setup mostly complete. Manual configuration is required for team setup and App Store Connect registration before building and submitting to review.

**Current Status:**
- Phases 2, 3, 4, 6: COMPLETED (automated setup finished)
- Phases 1, 5: PENDING (manual steps required)
- Phases 7-10: BLOCKED (awaiting earlier phases)

**Bundle ID:** `com.gingers.mypill`
**App Version:** 1.0.0 (Build 1)
**Deployment Target:** iOS 13.0+
**Supported Languages:** English, Japanese

---

## Phase 1: Xcode Project Setup - Team Configuration

**Status:** PENDING (Manual - Must complete before Phase 7)

This phase configures code signing and team credentials in Xcode. Without this, you cannot build or archive the app.

### Step 1.1: Open Xcode Project

1. Launch Xcode
2. Open `/Users/gingermarco/develop/my-pill/ios/Runner.xcworkspace` (use `.xcworkspace`, not `.xcodeproj`)
3. Select the **Runner** target in the sidebar

### Step 1.2: Configure Team Signing

1. Click the **Runner** target in the project navigator
2. Select the **Signing & Capabilities** tab
3. In the **Signing** section:
   - **Team:** Click the dropdown and select your Apple Developer Team
     - If you don't have a team, create one in [Apple Developer Account](https://developer.apple.com)
     - Your Apple ID must be added to the team with admin rights
   - **Bundle Identifier:** Confirm it shows `com.gingers.mypill`

**Expected result:**
```
Team: [Your Team Name] (Team ID: XXXXXXXXXX)
Bundle Identifier: com.gingers.mypill
Automatic signing: ✓ Enabled
```

### Step 1.3: Verify Signing Certificates

1. Still in **Signing & Capabilities**, under **Signing Certificate**:
   - Xcode should automatically create a development certificate
   - If it shows "No certificate is available", click the error and let Xcode create one

2. For release builds, you'll also need a **Distribution Certificate** (created automatically when archiving)

### Step 1.4: Configure App Capabilities

1. Stay in **Signing & Capabilities** tab
2. Verify these capabilities are present:
   - ✅ **Sign In with Apple** (already configured in Phase 2)
   - ✅ **Push Notifications** (aps-environment set to "production" in Runner.entitlements)

If any are missing, click **+ Capability** and add them.

### Step 1.5: Verify Entitlements File

The entitlements file at `/Users/gingermarco/develop/my-pill/ios/Runner/Runner.entitlements` should contain:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.developer.applesignin</key>
	<array>
		<string>Default</string>
	</array>
	<key>aps-environment</key>
	<string>production</string>
</dict>
</plist>
```

**Status Check:** This should already be in place from Phase 2.

---

## Phase 2: Add Required Capabilities

**Status:** COMPLETED ✓

### What Was Done

- ✅ Sign In with Apple entitlement added to Runner.entitlements
- ✅ Push Notifications capability enabled with aps-environment = "production"
- ✅ File location: `/Users/gingermarco/develop/my-pill/ios/Runner/Runner.entitlements`

**No further action needed for this phase.**

---

## Phase 3: Create PrivacyInfo.xcprivacy

**Status:** COMPLETED ✓

### What Was Done

Privacy manifest created at `/Users/gingermarco/develop/my-pill/ios/Runner/PrivacyInfo.xcprivacy` with:

**Data Collection Declared:**
- Health data (app functionality)
- Contacts (linked, no tracking)
- Photos (linked, no tracking)
- Product interaction (tracking for ads)

**API Access Declared:**
- UserDefaults (CA92.1)
- File timestamp (C617.1)
- System boot time (35F9.1)

**Tracking Domains:**
- googleadservices.com
- google.com
- doubleclick.net

### Verification

The file is embedded in the Xcode project at:
```
ios/Runner/PrivacyInfo.xcprivacy
```

To verify it's included in your build:
1. Open Xcode
2. Select Runner target
3. Go to **Build Phases** → **Copy Bundle Resources**
4. Confirm PrivacyInfo.xcprivacy is listed

**No further action needed for this phase.**

---

## Phase 4: Add Info.plist Permissions

**Status:** COMPLETED ✓

### What Was Done

Six permission descriptions added to `/Users/gingermarco/develop/my-pill/ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Take photos of your medications for easy identification.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Select medication photos from your library.</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>Save medication photos to your library.</string>

<key>NSUserTrackingUsageDescription</key>
<string>We use tracking to show you personalized ads and improve the app.</string>

<key>NSFaceIDUsageDescription</key>
<string>Use Face ID for secure login to MyPill.</string>

<key>NSNotificationUsageDescription</key>
<string>Get reminders when it's time to take your medication.</string>
```

### Verification in Xcode

1. Open `ios/Runner/Info.plist` in Xcode
2. Expand the root dictionary
3. Verify all 6 keys are present with English descriptions
4. AppStore Connect will request localized versions during submission

**No further action needed for this phase.**

---

## Phase 5: Configure App Store Connect

**Status:** PENDING (Manual - Must complete before Phase 8)

### Step 5.1: Create App on App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Sign in with your Apple ID (must be team admin)
3. Click **Apps** in the sidebar
4. Click **+ New App**

### Step 5.2: Create New App

Fill in the form with:

| Field | Value |
|-------|-------|
| Platform | iOS |
| Name | MyPill |
| Primary Language | English |
| Bundle ID | com.gingers.mypill |
| SKU | com.gingers.mypill.1 (can be any unique ID) |
| User Access | Full Access |

Click **Create** and wait for the app to be registered.

### Step 5.3: Fill in App Information

1. In App Store Connect, select your app
2. Go to **General** → **App Information**
3. Fill in:
   - **Subtitle:** "Your medication reminder companion"
   - **Category:** Medical or Lifestyle (choose Medical if available)
   - **Content Rights:** Confirm you own all content

### Step 5.4: Add Pricing & Availability

1. Go to **Pricing & Availability**
2. Set:
   - **Price Tier:** Free (since you have in-app purchases for premium)
   - **Availability:** Select target countries
   - **App Store Age Rating:** Continue with 4+

### Step 5.5: Add Screenshots & Metadata

Screenshots must be in 6.7" Display format (1290×2796 PNG). Prepare at least 3 screenshots showing:

1. **Medication Timeline** (home screen with upcoming doses)
2. **Add Medication** (creation flow)
3. **Adherence Tracking** (check-off and history)

For each language (English, Japanese):
1. Go to **App Store** in the left sidebar
2. Select language
3. Upload 3-5 screenshots
4. Fill in required fields:
   - **Name:** MyPill
   - **Subtitle:** Your medication reminder companion
   - **Description:** (see below)
   - **Keywords:** medication, pill, reminder, health, tracker
   - **Support URL:** [your support website]
   - **Privacy Policy URL:** [your privacy policy]

### Step 5.6: App Description

**English Version:**
```
MyPill is a smart medication management app that helps you never miss a dose.

Key Features:
✓ Medication Reminders - Get notified at the exact time
✓ Adherence Tracking - Check off doses and review history
✓ Inventory Management - Track pill count and refill alerts
✓ Caregiver Access - Family members can monitor adherence
✓ Photo Storage - Save pill photos for easy identification
✓ Adherence Reports - View compliance stats at a glance

Build healthy medication habits with MyPill!

⚠️ Medical Disclaimer: MyPill does not replace professional medical advice.
Always consult your healthcare provider before taking medications.
```

**Japanese Version (日本語):**
```
マイピルは、約の飲み忘れを防ぐスマートな服薬管理アプリです。

主な機能：
✓ 服薬アラーム - 指定した時間に通知を受け取り
✓ 服薬記録 - 服薬の有無をチェックして履歴確認
✓ 在庫管理 - 薬量を追跡して再購入アラートを受け取り
✓ 保護者接続 - 家族が服薬状況を監視
✓ 薬の写真保存 - 薬の写真保存で簡単識別
✓ 服薬レポート - コンプライアンス統計を一目で確認

マイピルで健康的な服薬習慣を築きましょう！

⚠️ 医学免責事項：マイピルは専門的な医学的助言に代わりません。
薬物の使用前に必ず医療提供者に相談してください。
```

### Step 5.7: Demo Account

1. Go to **App Privacy**
2. Add a demo account that reviewers can use (optional but recommended)
3. Credentials:
   - **Email:** your-test-account@example.com
   - **Password:** [set a secure password]
   - **Notes:** "No in-app purchase required to test core features"

### Step 5.8: Additional Settings

1. **Advertising:** Go to **Ad Network Attribution** if using Google Ads
2. **IDFA:** If collecting IDFA (Identifier for Advertising):
   - Answer: "Yes, we use IDFA"
   - Reason: "This app tracks user behavior for third-party advertising"

3. **Export Compliance:** Go to **General** → **Export Compliance**
   - Answer "No" to encryption questions (standard apps don't require export docs)

---

## Phase 6: Prepare Marketing Materials

**Status:** COMPLETED ✓

### What Was Prepared

All marketing materials are documented in `/Users/gingermarco/develop/my-pill/docs/APP_STORE_METADATA.md`:

**Screenshots:**
- Format: 6.7" Display (1290×2796 PNG)
- Minimum 3, recommended 5 per language
- Key screens: Timeline, Add Med, Adherence, Caregiver, Settings

**Keywords (SEO):**
- English: medication, pill, reminder, health, tracker, pharmacy, adherence, caregiver
- Korean: 약, 복약, 알림, 건강, 기록, 약국, 보호자, 추적

**Age Rating:** 4+

**No further action needed for this phase — all materials are documented.**

---

## Phase 7: Build & Archive Release

**Status:** BLOCKED (Waiting for Phase 1 - Team Configuration)

### Prerequisites

Before starting Phase 7:
- ✅ Phase 1 complete (team signing configured in Xcode)
- ✅ Flutter app tested and working locally
- ✅ All permissions granted in Info.plist (Phase 4)
- ✅ PrivacyInfo.xcprivacy in place (Phase 3)

### Step 7.1: Update Build Version Numbers

1. Open `/Users/gingermarco/develop/my-pill/pubspec.yaml`
2. Update the version line for your release:
   ```yaml
   version: 1.0.0+1
   ```
   Format: `MAJOR.MINOR.PATCH+BUILD_NUMBER`
   - First build: `1.0.0+1`
   - Each subsequent build increments the build number: `1.0.0+2`, `1.0.0+3`, etc.

3. Save and run:
   ```bash
   flutter pub get
   ```

### Step 7.2: Clean Previous Builds

```bash
cd /Users/gingermarco/develop/my-pill
flutter clean
cd ios
rm -rf Pods Podfile.lock
cd ..
flutter pub get
```

### Step 7.3: Prepare iOS for Release Build

```bash
cd /Users/gingermarco/develop/my-pill/ios
pod install --repo-update
cd ..
```

### Step 7.4: Archive the App in Xcode

1. **Open Xcode:**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Select Release Configuration:**
   - Click on "Runner" in the project navigator
   - In the scheme selector (top bar), change from "Debug" to "Release"

3. **Select Generic iOS Device (or your device):**
   - In the device selector dropdown, select **"Any iOS Device (arm64)"** or **"Generic iOS Device"**
   - Never select a simulator for release builds

4. **Archive the App:**
   - Go to **Product** → **Archive** in the menu bar
   - Wait for the build to complete (takes 2-5 minutes)

5. **Expected Output:**
   - The Organizer window opens showing your archive
   - Archive date and size are displayed

### Step 7.5: Verify Archive Success

In the Organizer window:
1. Find your most recent archive dated today
2. Click **Validate App** (optional but recommended)
3. Select distribution certificate when prompted
4. Wait for validation to complete (should succeed with no critical errors)

**Status After Phase 7:** Archive ready in Xcode Organizer

---

## Phase 8: Upload to App Store & TestFlight

**Status:** BLOCKED (Waiting for Phase 7 - Archive)

### Step 8.1: Distribute App via App Store Connect

After creating the archive (Phase 7):

1. In the **Organizer** window (still showing your archive):
2. Click **Distribute App**
3. Select **App Store Connect**

### Step 8.2: Configure Distribution Options

1. **Distribution Method:** Select "Upload"
2. **Signing Certificate:** Select your Distribution Certificate
   - If not shown, Xcode will create one automatically
3. **Team:** Confirm your Apple Developer Team is selected

### Step 8.3: Upload to App Store Connect

1. Click **Next** → **Upload**
2. Xcode begins uploading (progress bar shown)
3. Wait for upload to complete (2-10 minutes depending on internet)

**Expected Message:**
```
Upload successful. Your app will be processed and made available soon.
```

### Step 8.4: Verify Upload in App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Select your app (MyPill)
3. Go to **Build** section
4. Verify your build appears with status: **Processing**
   - After 5-30 minutes: Status becomes **Ready to Submit**

### Step 8.5: TestFlight Internal Testing Setup (Optional)

While waiting for build processing:

1. In App Store Connect, go to **TestFlight**
2. Click **Internal Testing**
3. Add internal testers:
   - Email addresses of team members
   - They'll receive TestFlight invites

4. Select your build:
   - When status = "Ready to Submit", it's also available for testing
   - Click **Select Build for Testing**

5. Testers receive email with TestFlight link
6. They install TestFlight app and can test your build before submission

---

## Phase 9: TestFlight Testing & Validation

**Status:** BLOCKED (Waiting for Phase 8 - Upload)

### Step 9.1: Internal Testing (Recommended Before Submission)

1. **Add Internal Testers:**
   - In App Store Connect → TestFlight → Internal Testing
   - Add email addresses of your QA team

2. **Run Tests Against Real Build:**
   - Testers install from TestFlight
   - Test all critical user flows:
     - Sign in with Apple
     - Add medication
     - Set reminders
     - Check adherence history
     - Caregiver access
     - Permission prompts

3. **Check Device Compatibility:**
   - Test on iPhone 12 mini (small screen)
   - Test on iPhone 15 Pro Max (large screen)
   - Test on iPad (if targeted)
   - Minimum iOS version: 13.0

4. **Verify Functionality:**
   - Notifications appear at scheduled times
   - Camera/Photo permissions work
   - Face ID prompts correctly
   - Data syncs to Firebase

### Step 9.2: External Testing (Optional)

1. In App Store Connect → TestFlight → External Testing
2. Add external testers (up to 10,000)
3. Send invitations
4. Collect feedback before App Store submission

### Step 9.3: Fix Issues (If Found)

If testers find bugs:

1. Fix bugs in Flutter code
2. Increment build number in pubspec.yaml: `1.0.0+2`
3. Rebuild and archive (Phase 7)
4. Upload new build (Phase 8)
5. Return to Phase 9 testing

### Step 9.4: Approve for Submission

Once testing is complete with no critical issues:

1. In App Store Connect → Builds
2. Confirm your build shows: **Ready to Submit**
3. You're ready to proceed to Phase 10

---

## Phase 10: Submit to App Store Review

**Status:** BLOCKED (Waiting for Phase 9 - Testing)

### Step 10.1: Complete Missing Metadata

Before submitting, ensure in App Store Connect:

1. **App Information:** ✓ Complete
2. **Pricing & Availability:** ✓ Set
3. **App Privacy:** ✓ Privacy manifest uploaded
4. **Screenshots:** ✓ Uploaded for all languages
5. **Version Release Notes:** Fill in below

### Step 10.2: Add Version Release Notes

In App Store Connect:

1. Go to **App Store** → Your App Version → **What's New in This Version**
2. Add release notes (shown to users after update):

**English:**
```
Version 1.0.0 - Initial Release

Thank you for downloading MyPill!

New Features:
- Smart medication reminders
- Adherence tracking and history
- Medication inventory management
- Caregiver access and family sharing
- Photo storage for pill identification
- Compliance reports and insights

We're committed to helping you never miss a dose. Send feedback to support@mypill.app
```

**Japanese:**
```
バージョン 1.0.0 - 初回リリース

MyPill をダウンロードしていただきありがとうございます！

新機能：
- スマート服薬リマインダー
- 服薬記録と履歴
- 薬の在庫管理
- 保護者アクセスと家族共有
- 薬の写真保存
- コンプライアンスレポートと洞察

支援フィードバック：support@mypill.app
```

### Step 10.3: Select Build for Submission

1. Go to **Builds** section in App Store Connect
2. Select your build (should show **Ready to Submit**)
3. The build is now associated with your version

### Step 10.4: Complete Questionnaire

Before submission, App Store Connect may ask:

**"Does your app use encryption?"** → No (for standard apps)

**"Does your app require a demo account?"** → Yes
- Provide credentials if your app needs login

**"Does your app contain medical/health information?"** → Yes
- You declared this in PrivacyInfo.xcprivacy

**"Does your app use IDFA?"** → Yes
- For Google Ads tracking

### Step 10.5: Submit for Review

1. In App Store Connect, your app version shows **Ready to Submit**
2. Click the **Submit for Review** button (or **Next** then **Submit**)
3. Review the checklist one final time
4. Click **Submit** to send to App Review team

**Expected Result:**
```
Status: Waiting for Review
Submitted: [Today's date]
```

### Step 10.6: Monitor Review Status

**Review Timeline:**
- **Days 1-2:** Waiting for Review (App Review team gets assignment)
- **Days 2-5:** In Review (team tests your app)
- **Days 5-7:** Decision made (Approved, Rejected, or Needs Info)

**Check Status:**
1. Go to App Store Connect → Your App
2. Status shows current review stage
3. Notifications sent via email when status changes

### Step 10.7: Handle Review Feedback

**If Approved:**
- ✅ App appears on App Store within hours
- Release immediately or schedule release date
- Post announcement to your users

**If Rejected:**
- ❌ Email explains rejection reason (usually fixable)
- Fix the issue
- Increment build number
- Resubmit (faster review on resubmission, ~1-2 days)

**Common Rejection Reasons:**
- Broken sign-in with Apple → Fix entitlements
- Permission descriptions unclear → Update Info.plist
- Crashes in demo account → Fix app code, rebuild
- Privacy issues → Update PrivacyInfo.xcprivacy

---

## Troubleshooting

### Build Issues

**Problem: "Team not found" error when archiving**

Solution:
1. Open Xcode project
2. Select Runner target → Signing & Capabilities
3. Team dropdown shows your team
4. If blank, click dropdown to select/create team
5. Retry archive (Product → Archive)

**Problem: "Code signing error" during archive**

Solution:
1. Go to Xcode preferences (Xcode → Settings)
2. Accounts tab → Select your Apple ID
3. Click "Manage Certificates"
4. If empty, click + to create Distribution Certificate
5. Close and retry archive

**Problem: "Provisioning profile invalid"**

Solution:
```bash
cd /Users/gingermarco/develop/my-pill
rm -rf ~/Library/Developer/Xcode/DerivedData/*
flutter clean
cd ios && rm -rf Pods Podfile.lock
cd .. && flutter pub get
```

Then retry archive.

### Upload Issues

**Problem: "Upload failed" in Xcode**

Solution:
1. Check internet connection
2. Verify Apple ID has team admin rights
3. In Xcode → Settings → Accounts, sign out and back in
4. Retry distribute

**Problem: Build appears in App Store Connect but stuck on "Processing"**

Solution:
- Wait 30 minutes (normal processing time)
- Check internet connection on your Mac
- If stuck >1 hour, contact App Store Connect support

### Review Issues

**Problem: App rejected for "Broken Sign in with Apple"**

Solution:
1. Verify entitlements file has:
   ```xml
   <key>com.apple.developer.applesignin</key>
   <array><string>Default</string></array>
   ```
2. Verify Sign In with Apple is enabled in Signing & Capabilities
3. Rebuild, increment build number
4. Resubmit with new build

**Problem: "Metadata failure" - Description or screenshots rejected**

Solution:
- Review feedback email (usually about screenshots or description)
- Fix metadata in App Store Connect
- Resubmit (no rebuild needed for metadata-only changes)

**Problem: App approved but not appearing on App Store**

Solution:
- Approved apps take 1-24 hours to appear
- Verify app is set to "Auto-release on approval" (not "Manual release")
- Check App Store after 24 hours
- If still missing, contact App Store Connect support

---

## Next Steps Checklist

Use this checklist to track progress:

### Immediate Actions (Before Building)

- [ ] **Phase 1 Complete:** Team signing configured in Xcode
  - [ ] Apple Developer Team assigned
  - [ ] Bundle ID: com.gingers.mypill confirmed
  - [ ] Sign In with Apple capability enabled
  - [ ] Push Notifications capability enabled

- [ ] **Phase 5 Complete:** App Store Connect registration
  - [ ] App created in App Store Connect
  - [ ] App name, category, SKU set
  - [ ] Screenshots uploaded (min 3 per language)
  - [ ] App description added (English & Japanese)
  - [ ] Keywords and support URL filled in
  - [ ] Demo account credentials added (if needed)
  - [ ] Age rating confirmed (4+)

### Build & Release (Phases 7-10)

- [ ] **Phase 7:** Archive created
  - [ ] pubspec.yaml version updated
  - [ ] Clean build performed (flutter clean)
  - [ ] Archive successful in Xcode Organizer
  - [ ] Validation passed (optional but recommended)

- [ ] **Phase 8:** Uploaded to App Store Connect
  - [ ] Build distributed via Distribute App
  - [ ] Upload completed successfully
  - [ ] Build appears in App Store Connect (status: Ready to Submit)

- [ ] **Phase 9:** TestFlight testing complete
  - [ ] Internal testers invited
  - [ ] Core features tested on device
  - [ ] No critical bugs found
  - [ ] Build approved for submission

- [ ] **Phase 10:** Submitted to App Review
  - [ ] Release notes added
  - [ ] All metadata verified
  - [ ] Questionnaire completed
  - [ ] App submitted for review
  - [ ] Review status monitored
  - [ ] App approved and released on App Store

### Post-Release

- [ ] App appears on App Store
- [ ] Share download link with users
- [ ] Monitor reviews and ratings
- [ ] Plan updates for Phase 2 features (caregiver portal, advanced analytics)

---

## Quick Reference

### Important File Paths

| File | Purpose | Status |
|------|---------|--------|
| `/ios/Runner.xcworkspace` | Xcode workspace (OPEN THIS) | Active |
| `/ios/Runner/Runner.entitlements` | Signing entitlements | Complete |
| `/ios/Runner/PrivacyInfo.xcprivacy` | Privacy manifest | Complete |
| `/ios/Runner/Info.plist` | Permission descriptions | Complete |
| `/pubspec.yaml` | App version (1.0.0+1) | Update before Phase 7 |
| `/docs/APP_STORE_METADATA.md` | Marketing materials | Complete |

### Key URLs

| Service | URL |
|---------|-----|
| Apple Developer | https://developer.apple.com |
| App Store Connect | https://appstoreconnect.apple.com |
| Xcode Download | https://developer.apple.com/download/all/ |

### Essential Commands

```bash
# Clean and rebuild
flutter clean && flutter pub get

# Update pods
cd ios && pod install --repo-update && cd ..

# Open Xcode workspace
open ios/Runner.xcworkspace

# Run on device
flutter run -v

# Build release
flutter build ios --release
```

---

## Support

For questions or issues:
1. Check the **Troubleshooting** section above
2. Review [Apple App Store Connect Help](https://developer.apple.com/app-store/connect/)
3. Contact [Apple Developer Support](https://developer.apple.com/support/)
4. Check Flutter documentation: https://flutter.dev/docs/deployment/ios

---

**Document Version:** 1.0
**Last Updated:** February 3, 2025
**For MyPill v1.0.0**
