# App Store Screenshots Plan

## Overview

- **Target Stores:** Apple App Store, Google Play Store
- **Devices:** iPhone 6.7" (required), iPhone 6.5", iPad 12.9" (optional)
- **Screenshot Count:** 6 (Apple max 10, Google max 8)
- **Seed Data:** Settings > Debug Tools > "Seed Screenshot Data" (debug build only)
- **Alt Entry:** `flutter run -t lib/main_screenshot.dart`

---

## Screenshot Sequence

### 1. Home Screen — Daily Timeline

**Screen:** `/home`
**What to capture:**
- Greeting header with user name (ゆき)
- Morning meds marked as taken (green checks)
- Afternoon/evening meds pending
- Low stock banner (アムロジピン — 残り4錠)
- Bottom navigation bar visible

**Seed data highlights:**
- 07:30 ガスター ✓, 08:00 朝のおくすり ✓, 08:00 アムロジピン ✓
- 12:00 ビタミンD (pending), 20:00 アムロジピン (pending), 21:00 アレグラ (pending)

---

### 2. Medication List

**Screen:** `/medications`
**What to capture:**
- 5 medications with varied pill icons (shapes + colors)
- Low stock badge on アムロジピン
- Inventory counts visible
- Search bar at top

**Seed data highlights:**
- 朝のおくすり (packet/white), アムロジピン (round/white, LOW), ガスター (oval/pink)
- ビタミンD (capsule/yellow), アレグラ (oval/blue)

---

### 3. Weekly Adherence Report

**Screen:** `/adherence`
**What to capture:**
- Overall adherence score (~87%)
- 7-day bar chart with daily adherence
- Per-medication breakdown list
- Export report button

**Seed data highlights:**
- 14 days of adherence history
- Critical meds ~95% adherence, supplements ~83%
- Realistic pattern: occasional skip/miss

---

### 4. Add Medication (Ippoka Mode)

**Screen:** `/medications/add` (with ippoka toggle ON)
**What to capture:**
- 一包化 toggle enabled
- Medication name field filled
- Dosage input (1 pack)
- Save button visible

**Note:** This is a live form, not seeded data. Fill manually for screenshot.

---

### 5. Travel Mode

**Screen:** `/travel`
**What to capture:**
- Travel mode toggle enabled
- Current timezone display
- Timezone mode selector (Keep Home Time / Adapt to Local)
- Affected medications list
- Doctor consultation info banner

**Note:** Enable travel mode toggle manually for screenshot.

---

### 6. Settings & Privacy

**Screen:** `/settings`
**What to capture:**
- Account section with user name
- Language selector (日本語)
- Notification settings
- Privacy policy / Terms of service links
- Overall clean, organized layout

---

## Captions (3 Languages)

| # | Screen | 日本語 (JA) | English (EN) | 한국어 (KO) |
|---|--------|------------|--------------|------------|
| 1 | Home | 毎日のおくすりをワンタップで記録 | Track your daily medications with one tap | 매일 복약을 원탭으로 기록하세요 |
| 2 | Medications | 一包化も個別薬も、まとめて管理 | Manage dose packs and individual pills together | 일포화도 개별 약도 한곳에서 관리 |
| 3 | Weekly Report | 週間レポートで服薬率をひと目で確認 | Check your weekly adherence at a glance | 주간 리포트로 복약률을 한눈에 확인 |
| 4 | Add Medication | かんたん登録、一包化にも対応 | Easy setup with dose pack support | 간편 등록, 일포화도 지원 |
| 5 | Travel Mode | 海外旅行中も時差に自動対応 | Auto-adjusts for timezone changes while traveling | 해외여행 중에도 시차에 자동 대응 |
| 6 | Settings | あなたの健康データを安全に保護 | Your health data, securely protected | 당신의 건강 데이터를 안전하게 보호 |

---

## Caption Design Guidelines

- **Font:** Bold, large, centered above or below the device frame
- **Style:** White text on brand-color gradient background, or dark text on light background
- **Length:** Max 2 lines per caption
- **Hierarchy:** Caption text above device mockup for Apple; overlay style for Google Play

---

## Seeded Test Data Summary

| Category | Count | Details |
|----------|-------|---------|
| User Profile | 1 | ゆき, Japanese locale, patient role |
| Medications | 5 | 1 ippoka + 4 individual (varied shapes/colors) |
| Schedules | 5 | Morning/noon/evening/bedtime spread |
| Today's Reminders | 6 | 3 taken + 3 pending |
| Adherence Records | ~100+ | 14 days history, ~87% overall rate |
| Low Stock | 1 | アムロジピン (4/30, threshold 5) |

---

## Capture Checklist

- [ ] Run `flutter run -t lib/main_screenshot.dart` OR press "Seed Screenshot Data" in Settings
- [ ] Set device to Japanese locale
- [ ] Set device time to ~10:00 AM (morning meds taken, afternoon pending)
- [ ] Disable notifications banner / status bar clutter
- [ ] Capture each screen in order (1-6)
- [ ] Verify low stock banner appears on home screen
- [ ] Verify adherence chart shows realistic bar pattern
- [ ] Check dark mode screenshots (optional, recommended for Apple)
